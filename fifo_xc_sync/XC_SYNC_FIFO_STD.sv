module XC_SYNC_FIFO_STD #(
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
    output reg [WIDTH-1:0]      data_o,    // 延迟一拍输出
    output                      full_o,
    output                      ne_o,
    input  [LOG2_DEPTH-1:0]     af_count_i,
    input  [LOG2_DEPTH-1:0]     ae_count_i,
    output                      af_o,
    output                      ae_o
);

reg [LOG2_DEPTH:0] r_rd_ptr;
reg [LOG2_DEPTH:0] r_wr_ptr;

// 指针管理
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        r_rd_ptr <= 0;
        r_wr_ptr <= 0;
    end
    else if (clr_i) begin
        r_rd_ptr <= 0;
        r_wr_ptr <= 0;
    end
    else begin
        if (rd_i && ne_o) begin  // 仅非空时读
            if (r_rd_ptr[LOG2_DEPTH-1:0] == DEPTH-1) begin
                r_rd_ptr[LOG2_DEPTH]    <= ~r_rd_ptr[LOG2_DEPTH];
                r_rd_ptr[LOG2_DEPTH-1:0]<= 0;
            end
            else begin
                r_rd_ptr[LOG2_DEPTH-1:0]<= r_rd_ptr[LOG2_DEPTH-1:0] + 1;
            end
        end
        if (wr_i && !full_o) begin  // 仅非满时写
            if (r_wr_ptr[LOG2_DEPTH-1:0] == DEPTH-1) begin
                r_wr_ptr[LOG2_DEPTH]    <= ~r_wr_ptr[LOG2_DEPTH];
                r_wr_ptr[LOG2_DEPTH-1:0]<= 0;
            end
            else begin
                r_wr_ptr[LOG2_DEPTH-1:0]<= r_wr_ptr[LOG2_DEPTH-1:0] + 1;
            end
        end
    end
end

// FIFO状态
assign full_o = (r_wr_ptr[LOG2_DEPTH] ^ r_rd_ptr[LOG2_DEPTH]) &&
                (r_wr_ptr[LOG2_DEPTH-1:0] == r_rd_ptr[LOG2_DEPTH-1:0]);
assign ne_o   = (r_wr_ptr != r_rd_ptr);

wire [LOG2_DEPTH:0] abs_diff_wr_rd_ptr;
assign abs_diff_wr_rd_ptr = (r_wr_ptr[LOG2_DEPTH] ^ r_rd_ptr[LOG2_DEPTH]) ? 
                            (DEPTH + r_wr_ptr[LOG2_DEPTH-1:0] - r_rd_ptr[LOG2_DEPTH-1:0]) :
                            (r_wr_ptr[LOG2_DEPTH-1:0] - r_rd_ptr[LOG2_DEPTH-1:0]);

assign af_o = (abs_diff_wr_rd_ptr >= af_count_i);
assign ae_o = (abs_diff_wr_rd_ptr <= ae_count_i);

// RAM存储
reg [WIDTH-1:0] r_fifo_data [0:DEPTH-1];
integer i;
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        for (i = 0; i < DEPTH; i = i + 1)
            r_fifo_data[i] <= 0;
    else if (clr_i)
        for (i = 0; i < DEPTH; i = i + 1)
            r_fifo_data[i] <= 0;
    else if (wr_i && !full_o)
        r_fifo_data[r_wr_ptr[LOG2_DEPTH-1:0]] <= data_i;
end

// 读数据（延迟一拍）
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        data_o <= 0;
    else if (rd_i && ne_o)
        data_o <= r_fifo_data[r_rd_ptr[LOG2_DEPTH-1:0]];
end

endmodule