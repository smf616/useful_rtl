module XC_FWFT_WRAPPER #(
    parameter WIDTH       = 32,
    parameter DEPTH       = 8,
    parameter LOG2_DEPTH  = 3
)(
    input                       clk_i,
    input                       rst_i,
    input                       clr_i,
    input                       wr_i,
    input  [WIDTH-1:0]          data_i,
    input                       rd_i,
    output [WIDTH-1:0]          data_o,    // FWFT输出
    output                      full_o,
    output                      ne_o,
    input  [LOG2_DEPTH-1:0]     af_count_i,
    input  [LOG2_DEPTH-1:0]     ae_count_i,
    output                      af_o,
    output                      ae_o
);

// 核心FIFO实例
wire [WIDTH-1:0] core_data_o;
wire             core_full_o;
wire             core_ne_o;
wire             core_af_o;
wire             core_ae_o;
reg              core_rd_i;

XC_SYNC_FIFO_STD #(
    .WIDTH      (WIDTH),
    .DEPTH      (DEPTH),
    .LOG2_DEPTH (LOG2_DEPTH)
) core_fifo (
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .clr_i      (clr_i),
    .wr_i       (wr_i),
    .data_i     (data_i),
    .rd_i       (core_rd_i),
    .data_o     (core_data_o),
    .full_o     (core_full_o),
    .ne_o       (core_ne_o),
    .af_count_i (af_count_i),
    .ae_count_i (ae_count_i),
    .af_o       (core_af_o),
    .ae_o       (core_ae_o)
);

// FWFT逻辑
reg [WIDTH-1:0] data_reg;    // 输出寄存器
reg             data_valid;  // 寄存器有效标志
reg [WIDTH-1:0] data_o;      // FWFT输出
reg             ne_o;

// 输出数据和非空标志
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        data_reg   <= 0;
        data_valid <= 0;
        data_o     <= 0;
        ne_o       <= 0;
    end
    else if (clr_i) begin
        data_reg   <= 0;
        data_valid <= 0;
        data_o     <= 0;
        ne_o       <= 0;
    end
    else begin
        // 加载数据到data_reg
        if (core_rd_i && core_ne_o) begin
            data_reg   <= core_data_o;
            data_valid <= 1;
        end
        else if (rd_i && data_valid && !core_ne_o) begin
            // 核心FIFO空，仅消耗data_reg
            data_valid <= 0;
        end

        // 输出逻辑
        if (data_valid) begin
            data_o <= data_reg;
            ne_o   <= 1;
        end
        else if (core_rd_i && core_ne_o) begin
            // 直接透传核心FIFO数据（data_reg未就绪时）
            data_o <= core_data_o;
            ne_o   <= 1;
        end
        else begin
            data_o <= 0;
            ne_o   <= 0;
        end
    end
end

// 控制核心FIFO读
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        core_rd_i <= 0;
    else if (clr_i)
        core_rd_i <= 0;
    else
        core_rd_i <= (!data_valid && core_ne_o) || (rd_i && core_ne_o);
end


// always @(*) begin
//     core_rd_i = (!data_valid && core_ne_o) || (rd_i && core_ne_o);
// end


// 直通状态信号
assign full_o = core_full_o;
assign af_o   = core_af_o;
assign ae_o   = core_ae_o;

endmodule