/*
Top level module for dlp spi controller 

*/
module spi_slave_top #(

parameter WIDTH_MAX = 1280,
parameter HEIGHT_MAX = 960,
parameter PW = 32,
parameter AW = 32,
parameter DW = 64, //fixed to 64
parameter DMA_BL = 3,
parameter BL = 4,
parameter APB_AW = 5,
parameter ID = 32'hACC

) (


input clk,
input rst_n,

input cpb_r, // no use
input cpb_w,
input [APB_AW-1:0] cpb_a, // [6-12]
input [31:0] cpb_d,
output logic [31:0] cpb_q,
output logic irq,

//read dma 
input           src_bus_rrdy,
output          src_bus_rval,
output [BL-1:0] src_bus_rlen,
output [AW-1:0] src_bus_raddr,
input  [DW-1:0] src_bus_rdata,
input           src_bus_rdval,
//write DMA
input   bus_wrdy,
output  bus_wval,
output  [BL-1:0] bus_wlen,
output  [AW-1:0] bus_waddr,
output  [DW-1:0] bus_wdata,

// SPI interface
input  logic        mosi,
output logic        miso,
input  logic        sclk,
input  logic        cs_n
);


//define regilist 
localparam IDR = 0;
localparam CR = 1;
localparam SR = 2;
localparam SA = 3;
localparam DMA_LR_READ = 4;
localparam DA = 5;
localparam DMA_LR = 6; //dma read length must be burst aligned 64 byte aligned 
//control package id and type
localparam PKGR0 = 7;
localparam PKGR1 = 8;
localparam DBGR2 = 9;
localparam DBGR3 = 10;


wire cr_we = cpb_a == CR && cpb_w;
wire sr_we = cpb_a == SR && cpb_w;
wire sa_rd_we = cpb_a == SA && cpb_w;
wire lr_rd_we = cpb_a == DMA_LR_READ && cpb_w;
//write dma 
wire pio_adr_we = cpb_a == DA && cpb_w;
wire pio_len_we = cpb_a == DMA_LR && cpb_w;


logic dma_read_done;
logic dma_write_done;

logic [31:0] dma_read_length;
logic [7:0] mask_d;

always_ff@(posedge clk or negedge rst_n)
    if (!rst_n)
        dma_read_length <= 0;
    else if (lr_rd_we)
        dma_read_length <= cpb_d;


always @(posedge clk or negedge rst_n)
    if (!rst_n)
        mask_d <= 8'h7c;
    else if (cpb_a == PKGR1 && cpb_w)
        mask_d <= cpb_d[7:0];




//spi slave config 
logic cpha,cpol;
logic [4:0] bit_length;
logic [31:0] control;


logic [31:0] pkt_tx_data_slave;
logic pkt_tx_data_valid_slave, pkt_tx_data_ready_slave;

logic [31:0] pkt_data_in_slave;
logic pkt_data_in_ready_master;   
logic pkt_data_in_valid_slave, pkt_data_in_ready_slave;

//word aligned ，e.g 4 bytes , 8 bytes ,12 bytes
logic [31:0] tx_base_addr_slave;
logic [31:0] tx_length_slave;
logic [15:0] tx_packet_type_slave; //package type
logic [15:0] tx_id_slave;

// use rising edge as start of transfer 
logic tx_start_slave;
logic tx_data_end_slave; //the last word of tx transfer 
logic tx_enable_slave; // enable tx side statemachine 
logic tx_sending_slave; //state != IDLE
logic packet_tx_error; //length_error or timeout for tx 

//spi slave side signals wire 
logic spi_tx_error; //when spi clock arrived but miso fifo is empty.
logic spi_tx_done_pulse;

// enable rx side statemachine 
logic [31:0] rx_data_s;
logic rx_data_valid_s;
logic [31:0] pkt_rx_addr;
logic [31:0] pkt_rx_length;
logic [31:0] pkt_rx_data;
logic        pkt_rx_data_valid;
logic [15:0] pkt_rx_id;
logic [15:0] pkt_rx_type;
logic        pkg_rx_start;
logic        pkg_rx_end;
logic        pkt_rx_enable;
logic        pkg_rx_error;

logic        header_crc_error;
logic        data_crc_error;

logic [15:0] header_crc_error_cnt; //count crc error 
logic [15:0] data_crc_error_cnt;

//en for three modules 
logic package_rx_en;
logic package_tx_en;
logic dma_read_en;
logic dma_write_en;

logic dma_read_done_is;
logic dma_write_done_is;
logic packet_tx_error_is; //length_error or tx package timeout , as read dma timeout 
logic header_crc_error_is; //rx crc header error irq 
logic data_crc_error_is; // rx data crc error
logic pkg_rx_error_is; //rx timeout or crc error
logic spi_tx_error_is; // spi tx error , spi clock arrived but fifo is empty 


always @(posedge clk or negedge rst_n)
    if (!rst_n) begin 
        dma_read_done_is <= 1'b0;
        dma_write_done_is <= 1'b0;
        packet_tx_error_is <= 1'b0;
        header_crc_error_is <= 1'b0;
        data_crc_error_is <= 1'b0;
        pkg_rx_error_is <= 1'b0;
        spi_tx_error_is <= 1'b0;
    end else begin 
        dma_read_done_is <= ~dma_read_done_is ? (dma_read_done ? 1'b1 & ~mask_d[0] : 1'b0) : ((sr_we && cpb_d[0]) ? 1'b0 : 1'b1); 
        dma_write_done_is <= ~dma_write_done_is ? (dma_write_done ? 1'b1 & ~mask_d[1] : 1'b0) : ((sr_we && cpb_d[1]) ? 1'b0 : 1'b1); 
        packet_tx_error_is <= ~packet_tx_error_is ? (packet_tx_error ? 1'b1 & ~mask_d[2] : 1'b0) : ((sr_we && cpb_d[2]) ? 1'b0 : 1'b1); 
        header_crc_error_is <= ~header_crc_error_is ? (header_crc_error ? 1'b1 & ~mask_d[3] : 1'b0) : ((sr_we && cpb_d[3]) ? 1'b0 : 1'b1); 
        data_crc_error_is <= ~data_crc_error_is ? (data_crc_error ? 1'b1 & ~mask_d[4] : 1'b0) : ((sr_we && cpb_d[4]) ? 1'b0 : 1'b1); 
        pkg_rx_error_is <= ~pkg_rx_error_is ? (pkg_rx_error ? 1'b1 & ~mask_d[5] : 1'b0) : ((sr_we && cpb_d[5]) ? 1'b0 : 1'b1); 
        spi_tx_error_is <= ~spi_tx_error_is ? (spi_tx_error ? 1'b1 & ~mask_d[6] : 1'b0) : ((sr_we && cpb_d[6]) ? 1'b0 : 1'b1); 
    end 

always @(posedge clk or negedge rst_n)
    if(!rst_n) begin 
        header_crc_error_cnt <= 0;
        data_crc_error_cnt <= 0;
    end else if (!package_rx_en) begin 
        header_crc_error_cnt <= 0;
        data_crc_error_cnt <= 0; 
    end else begin 
        if (header_crc_error) header_crc_error_cnt <= header_crc_error_cnt + 1'b1;
        if (data_crc_error) data_crc_error_cnt <= data_crc_error_cnt + 1'b1;
    end 


assign irq = |({dma_read_done_is,dma_write_done_is,packet_tx_error_is,header_crc_error_is,
                data_crc_error_is,pkg_rx_error_is,spi_tx_error_is} & ~mask_d);


spi_packet_tx u_spi_packet_tx_slave (
    .clk           (clk),
    .rst_n         (package_tx_en),
    .data_in       (pkt_data_in_slave),
    .data_in_valid (pkt_data_in_valid_slave),
    .data_in_ready (pkt_data_in_ready_slave),
    .tx_base_addr  (tx_base_addr_slave),
    .tx_length     (tx_length_slave),
    .tx_data       (pkt_tx_data_slave),
    .tx_data_valid (pkt_tx_data_valid_slave),
    .tx_data_ready (pkt_tx_data_ready_slave),
    .tx_packet_type (tx_packet_type_slave),
    .tx_id         (tx_id_slave),
    .tx_data_end   (tx_data_end_slave),
    .tx_enable     (1'b1),
    .sending       (tx_sending_slave),
    .error         (packet_tx_error)
);

spi_packet_rx u_spi_packet_rx (
    .clk           (clk),
    .rst_n         (package_rx_en),
    .rx_data       (rx_data_s),
    .rx_data_valid (rx_data_valid_s),
    .pkt_rx_enable (1'b1),
    .pkt_rx_addr    (pkt_rx_addr),
    .pkt_rx_length  (pkt_rx_length),
    .pkt_rx_data      (pkt_rx_data),
    .pkt_rx_data_valid(pkt_rx_data_valid),
    .pkt_rx_id        (pkt_rx_id),
    .pkt_rx_type      (pkt_rx_type),  
    .pkg_rx_start  (pkg_rx_start),
    .pkg_rx_end    (pkg_rx_end),
    .header_crc_error(header_crc_error),
    .data_crc_error(data_crc_error),
    .error(pkg_rx_error)
);


spi_slave uut_slave (
    .sys_clk(clk),
    .sys_rst_n(rst_n),
    .mosi(mosi),
    .miso(miso),
    .sclk(sclk),
    .cs_n(cs_n),
    .control(control),
    .tx_data_valid(pkt_tx_data_valid_slave),
    .tx_data_ready(pkt_tx_data_ready_slave),
    .tx_error(spi_tx_error),
    .tx_done_pulse(spi_tx_done_pulse),
    .tx_data(pkt_tx_data_slave),
    .rx_data(rx_data_s),
    .rx_data_valid(rx_data_valid_s)
);


always @(posedge clk or negedge rst_n)
    if (!rst_n) begin 
        package_rx_en <= 1'b0;
        package_tx_en <= 1'b0;
        dma_read_en <= 1'b0;
        dma_write_en <= 1'b0;
        cpol <= 1'b0;
        cpha <= 1'b1;
    end else if (cr_we) begin 
        dma_read_en <= cpb_d[0];
        dma_write_en <= cpb_d[1];
        package_tx_en <= cpb_d[2];
        package_rx_en <= cpb_d[3];
        cpha <= ~cpb_d[4] ? 1'b1 : 1'b1;
        cpol <= cpb_d[5];
    end 

//config spi slave , fixed config when in spi_slave_top module
assign control = {(dma_read_length[31:2]+6), 5'd31, 3'b010, 3'b000, cpol, cpha, 3'b001};


//dma read part ************************************************************

logic dma_w_rdy;
logic dma_w_val;
logic dma_w_eof;
logic [DW-1:0] dma_w_d;

logic [31:0] src_rd_adr;

logic  dma_rd_rdy/*synthesis keep*/;
logic  dma_rd_val/*synthesis keep*/;
logic  dma_rd_eof/*synthesis keep*/;
logic  dma_rd_done/*synthesis keep*/;
logic [DW-1:0] dma_rd_d;
logic dma_rd_eof_1;
logic dst_read_tx_done;

xlib_xyz_dma_r #(
.AW(AW), 
.AL(3), 
.BL(DMA_BL), 
.LW($clog2(WIDTH_MAX*HEIGHT_MAX)+2)
) u_src_dma (
.clk        (clk),
.rst_n      (dma_read_en),
.bus_rst_n  (rst_n),
.pio_adr_we (sa_rd_we),
.pio_len_we (lr_rd_we),
.pio_d      (cpb_d),
.pio_adr    (src_rd_adr),
.pio_len    (),
.dma_done   (dma_read_done),
.dma_err    (),
.dma_rdy    (dma_rd_rdy),
.dma_val    (dma_rd_val),
.dma_eof    (dma_rd_eof),
.dma_d      (dma_rd_d),
.bus_rrdy   (src_bus_rrdy),
.bus_rval   (src_bus_rval),
.bus_rlen   (src_bus_rlen),
.bus_raddr  (src_bus_raddr),
.bus_rdata  (src_bus_rdata),
.bus_rdval  (src_bus_rdval));

wire [2:0] bpp_r = PW / 8 - 1;

xlib_stream_w2p #(
.PW(PW), 
.DW(DW)
)w2p_U(
.clk(clk),
.rst_n(dma_read_en),
.clr_n(1'b1),
.bpp(bpp_r), // byte per primitive: 0=1B, 1=2B, 2=3B, 3=4B ...
.m_rdy(dma_rd_rdy),
.m_val(dma_rd_val),
.m_eof(dma_rd_eof),
.m_dat(dma_rd_d),
.s_rdy(pkt_data_in_ready_slave),
.s_val(pkt_data_in_valid_slave),
.s_eof(dma_rd_eof_1),
.s_dat(pkt_data_in_slave)
);

assign dst_read_tx_done = pkt_data_in_ready_slave & pkt_data_in_valid_slave & dma_rd_eof_1;


//tx_base_addr_slave,no mean to send addr to tx2 , just to remain the same package structure
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        tx_base_addr_slave <= '0;
    else if (sa_rd_we)
        tx_base_addr_slave <= cpb_d;

assign tx_length_slave = dma_read_length;

//id for tx;
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        tx_id_slave <= '0;
    else if (!package_tx_en)
        tx_id_slave <= '0;
    else if (dst_read_tx_done)
        tx_id_slave <= tx_id_slave + 1'b1;

//type for tx 
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        tx_packet_type_slave <= '0;
    else if (!package_tx_en)
        tx_packet_type_slave <= '0;
    else if (cpb_a == PKGR0 && cpb_w)
        tx_packet_type_slave <= cpb_d[15:0];

//dma write part ************************************************************


logic [31:0] dst_adr;

logic dma_w_error;//write dma fifo is full 


logic [31:0] pkt_rx_data_1;
logic pkt_rx_valid_1;
logic [31:0] data_temp;
logic dma_w_val_pre;
logic [DW-1:0] dma_w_d_pre;



typedef enum logic [2:0] {
    IDLE,
    SPI_TYPE_ID,
    SPI_SYNC_DMA,
    DMA_PADDING,
    SPI_SYNC_DONE
} state_t;

state_t state, next_state;





assign pkt_rx_valid_1 = (state == SPI_TYPE_ID) || (state == SPI_SYNC_DMA && pkt_rx_data_valid);

logic merge_cnt;
logic [3:0] padding_cnt; // burst is aligned with 8 * 8 = 64 bytes equal to 16 words 

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        merge_cnt <= 0;
    else if (!dma_write_en)
        merge_cnt <= 0;
    else if (state == SPI_TYPE_ID || state == SPI_SYNC_DMA) begin 
        if (state == SPI_TYPE_ID || pkt_rx_data_valid)
            merge_cnt <= merge_cnt + 1'b1;
    end else 
        merge_cnt <= 0;


always @(posedge clk or negedge rst_n)
    if (!rst_n)
        padding_cnt <= 0;
    else if (!dma_write_en)
        padding_cnt <= 0;
    else if (state == SPI_TYPE_ID || state == SPI_SYNC_DMA || state == DMA_PADDING) begin 
        if (state == SPI_TYPE_ID || pkt_rx_data_valid || state == DMA_PADDING)
            padding_cnt <= padding_cnt + 1'b1;
    end else if (state == IDLE)
        padding_cnt <= 0;


always_comb begin 
    if (state == SPI_TYPE_ID)
        pkt_rx_data_1 = {pkt_rx_type,pkt_rx_id};
    else if (state == DMA_PADDING)
        pkt_rx_data_1 = '0;
    else 
        pkt_rx_data_1 = pkt_rx_data;
end 


always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dma_w_val_pre <= 1'b0;
            dma_w_d_pre <= 64'b0;
            data_temp <= 32'b0;
        end
        else if (pkt_rx_valid_1) begin
            case (merge_cnt)
                1'b0: begin
                    data_temp <= pkt_rx_data_1;
                    dma_w_val_pre <= 1'b0;
                end
                1'b1: begin
                    dma_w_d_pre <= {data_temp, pkt_rx_data_1};
                    dma_w_val_pre <= 1'b1;
                end
            endcase
        end
        else begin
            dma_w_val_pre <= 1'b0;
        end
    end


always @(posedge clk or negedge rst_n)
    if (!rst_n)
        state <= IDLE;
    else if (!dma_write_en)
        state <= IDLE;
    else 
        state <= next_state;

always_comb begin 
     next_state = state;
     case (state)
        IDLE : begin 
            if (pkg_rx_start)
                next_state = SPI_TYPE_ID;
        end 

        SPI_TYPE_ID : begin 
            next_state = SPI_SYNC_DMA;
        end 

        SPI_SYNC_DMA : begin 
            if (pkg_rx_end) begin 
                if (padding_cnt == 4'd15)
                    next_state = SPI_SYNC_DONE;
                else 
                    next_state = DMA_PADDING;
            end 
        end 
        DMA_PADDING : begin 
            if (padding_cnt == 4'd15)
                next_state = SPI_SYNC_DONE;
        end 
        SPI_SYNC_DONE : begin 
            next_state = IDLE;
        end 
     endcase 
end 


assign dma_w_val = dma_w_val_pre;
assign dma_w_d = dma_w_d_pre;
assign dma_w_eof = (state == SPI_SYNC_DMA && pkg_rx_end && padding_cnt == 4'd15) || (state == DMA_PADDING && padding_cnt == 4'd15);
//error 
assign dma_w_error = dma_w_val && ~dma_w_rdy;


multi_dma_w #(
    .AW(AW),
    .AL($clog2(DW/8)),
    .BL(DMA_BL),
    .CH(1)
) multi_dma_w_dut (
    .clk(clk),
    .rst_n(dma_write_en),
    .bus_rst_n(rst_n),
    .pio_adr_we(pio_adr_we),
    .pio_len_we(pio_len_we),
    .pio_d(cpb_d),
    .pio_adr(dst_adr),  //output 
    .dma_done(dma_write_done),
    .dma_rdy(dma_w_rdy),
    .dma_val(dma_w_val),
    .dma_eof(dma_w_eof),
    .dma_d(dma_w_d),
    .bus_wrdy(bus_wrdy),
    .bus_wval(bus_wval),
    .bus_wlen(bus_wlen),
    .bus_waddr(bus_waddr),
    .bus_wdata(bus_wdata)
);

//cpb_q logic 

always_comb begin 

case (cpb_a)
  IDR : cpb_q = ID;
  CR : cpb_q = {cpol,cpha,package_rx_en,package_tx_en,dma_write_en,dma_read_en};
  SR : cpb_q = {tx_sending_slave,dma_read_done_is,dma_write_done_is,packet_tx_error_is,header_crc_error_is,
                data_crc_error_is,pkg_rx_error_is,spi_tx_error_is};
  SA : cpb_q = src_rd_adr;
  DMA_LR_READ : cpb_q = dma_read_length;
  DA : cpb_q = dst_adr;
  PKGR0 : cpb_q = {tx_packet_type_slave,tx_id_slave};
  PKGR1 : cpb_q = mask_d;
  DBGR2 : cpb_q = {pkt_rx_data_1};
  DBGR3 : cpb_q = {data_crc_error_cnt,header_crc_error_cnt};

  default:cpb_q = ID;
endcase 
end 






endmodule 