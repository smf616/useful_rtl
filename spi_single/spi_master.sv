/*

* SCLKCPOL=0 is a clock which idles at the logical low voltage.
* SCLKCPOL=1 is a clock which idles at the logical high voltage.

CPHA represents the phase of each data bit's transmission cycle relative to SCLK
For CPHA=0:
    * The first data bit is output immediately when SS activates.
    * Subsequent bits are output when SCLK transitions to its idle voltage level.
    * Sampling occurs when SCLK transitions from its idle voltage level.
For CPHA=1:
    * The first data bit is output on SCLK's first clock edge after SS activates.
    * Subsequent bits are output when SCLK transitions from its idle voltage level.
    * Sampling occurs when SCLK transitions to its idle voltage level.


SPI mode	Clock polarity(CPOL)	Clock phase(CPHA)	Data is shifted out on	                    Data is sampled on
0	        0	                    0	                falling SCLK, and when SS activates	        rising SCLK
1	        0	                    1	                rising SCLK	                                falling SCLK
2	        1	                    0	                rising SCLK, and when SS activates	        falling SCLK
3	        1	                    1	                falling SCLK	                            rising SCLK


// CPOL: Clock Polarity
// CPOL=0 means clock idles at 0, leading edge is rising edge.
// CPOL=1 means clock idles at 1, leading edge is falling edge.

// CPHA: Clock Phase
// CPHA=0 means the "out" side changes the data on trailing edge of clock
//              the "in" side captures data on leading edge of clock
// CPHA=1 means the "out" side changes the data on leading edge of clock
//              the "in" side captures data on the trailing edge of clock

*/
module spi_master (
    input  logic        sys_clk,
    input  logic        sys_rst_n,

    // SPI interface
    input  logic        miso,
    output logic        mosi,
    output logic        sclk,
    output logic        cs_n,

    // Control interface
    input  logic [15:0] control,        // control[4]=CPHA, control[3]=CPOL
    input  logic        tx_data_valid,
    output logic        tx_data_ready,
    input  logic [31:0] tx_data,
    output logic [31:0] rx_data,
    output logic        rx_data_valid
);

// -----------------------------
// Control decoding
// -----------------------------
logic       CPHA, CPOL;
logic [2:0] half_clk_div; // 半个spi周期的分频系数，例如如果是2，那么一个spi_clk就是4个sys_clk周期
logic [4:0] bit_length;
logic [3:0] full_clk_div; // 一个spi周期的分频系数
logic [6:0] max_clk_edges;

assign CPHA        = control[4];
assign CPOL        = control[3];
assign half_clk_div      = control[2:0] == 0 ? 1 : control[2:0]; // 最小分频系数为1
assign bit_length  = (control[15:11] > 31) ? 31 : control[15:11] == 0 ? 7 : control[15:11]; // bit_length is 0-31, default to 8 bits
assign max_clk_edges = (bit_length + 1) * 2; 

logic leading_edge;
logic trailing_edge;
logic [6:0] spi_clk_edges; //max 64 edges, enough for 32 bits
logic [4:0] tx_bit_count,rx_bit_count;
logic spi_clk_r;
logic [3:0] spi_clk_count; // 4 bits is enough for 16 clk div

logic [31:0] tx_data_1r;

logic internal_spi_ready;

wire tx_ack = tx_data_valid && tx_data_ready;
logic tx_ack_1r;

always_comb begin
    full_clk_div = half_clk_div << 1;
end

always_ff@(posedge sys_clk or negedge sys_rst_n)
if (!sys_rst_n)begin 
    internal_spi_ready <= 1'b0;
    spi_clk_edges <= 'd0;
    leading_edge <= 1'b0;
    trailing_edge <= 1'b0;
    spi_clk_r <= 0;
    spi_clk_count <= '0;
end 
else begin 
        leading_edge <= 1'b0;
        trailing_edge <= 1'b0;
        if (tx_ack)begin 
            internal_spi_ready <= 1'b0;
            spi_clk_edges <= max_clk_edges;
        end 
        else if (spi_clk_edges > 0 && ~cs_n)begin 
                internal_spi_ready <= 1'b0;
                if (spi_clk_count == full_clk_div - 1)begin 
                    spi_clk_edges <= spi_clk_edges - 1;
                    trailing_edge <= 1'b1;
                    spi_clk_count <= 0;
                    spi_clk_r <= ~spi_clk_r;
                end 
                else if (spi_clk_count == half_clk_div - 1)begin 
                    spi_clk_edges <= spi_clk_edges - 1;
                    leading_edge <= 1'b1;
                    spi_clk_count <= spi_clk_count + 1;
                    spi_clk_r <= ~spi_clk_r;
                end 
                else  begin 
                    spi_clk_count <= spi_clk_count + 1;
                end 
            end 
        else  
        internal_spi_ready <= 1'b1;
    end 

 always_ff@(posedge sys_clk or negedge sys_rst_n)
    if (!sys_rst_n)
        sclk <= 0;
    else sclk <= spi_clk_r ? ~CPOL : CPOL; // CPOL=0 means sclk is low when idle, CPOL=1 means sclk is high when idle

always_ff@(posedge sys_clk or negedge sys_rst_n)
    if (!sys_rst_n)begin 
        tx_ack_1r <= 1'b0;
        tx_data_1r <= '0;
    end else begin 
        tx_ack_1r <= tx_ack;
        if (tx_ack)
            tx_data_1r <= tx_data;
    end 

// MOSI
always_ff @(posedge sys_clk or negedge sys_rst_n)
    if (!sys_rst_n) begin
        mosi <= 1'b0;
        tx_bit_count <= 5'd0;
    end else begin
        if (internal_spi_ready) begin
            tx_bit_count <= bit_length;
        end
        else if (tx_ack_1r && ~CPHA) begin // CPHA=0
            mosi <= tx_data_1r[bit_length];
            tx_bit_count <= bit_length - 1;
        end
        else if ((leading_edge && CPHA) || (trailing_edge && ~CPHA)) begin
            mosi <= tx_data_1r[tx_bit_count];
            tx_bit_count <= tx_bit_count - 1;
        end
    end

//MISO
always_ff @(posedge sys_clk or negedge sys_rst_n)
    if (!sys_rst_n) begin
        rx_data <= '0;
        rx_data_valid <= 1'b0;
        rx_bit_count <= 5'd0;
    end else begin
        rx_data_valid <= 1'b0;

        if (internal_spi_ready) begin
            rx_bit_count <= bit_length;
        end
        else if ((leading_edge && ~CPHA) || (trailing_edge && CPHA)) begin
            rx_data[rx_bit_count] <= miso;
            if (rx_bit_count == 0)
                rx_data_valid <= 1'b1;
            rx_bit_count <= rx_bit_count - 1;
        end
    end

// CSN control logic
logic [2:0] csn_hold_delay;     // configurable delay after last rx_data_valid
logic [2:0] burst_len;          // how many spi tx_data per burst
logic [2:0] burst_index;
logic       in_burst;
logic [2:0] csn_hold_cnt;

assign csn_hold_delay = control[10:8];   // e.g. 3 => cs_n 延迟 3 个 sys_clk
assign burst_len      = control[7:5];    // e.g. 4 => 每个 burst 发送 4 包

always_ff @(posedge sys_clk or negedge sys_rst_n)
if (!sys_rst_n) begin
    cs_n         <= 1'b1;
    burst_index  <= 0;
    csn_hold_cnt <= 0;
    in_burst     <= 0;
end else begin
    // Start new burst
    if (tx_ack && !in_burst) begin
        in_burst     <= 1'b1;
        burst_index  <= 1;
        cs_n         <= 1'b0;
    end
    // Continue burst
    else if (tx_ack && in_burst) begin
        burst_index <= burst_index + 1;
    end

    // End of burst detected
    if (rx_data_valid && in_burst && (burst_index == burst_len)) begin
        in_burst <= 1'b0;
        csn_hold_cnt <= csn_hold_delay;
    end

    // Delay before releasing cs_n
    if (!in_burst && csn_hold_cnt > 0) begin
        csn_hold_cnt <= csn_hold_cnt - 1;
        if (csn_hold_cnt == 1)
            cs_n <= 1'b1; // release cs_n at final count
    end
end

assign tx_data_ready = internal_spi_ready && (cs_n || !in_burst); // tx_data_ready is high when not in burst or cs_n is high



endmodule
