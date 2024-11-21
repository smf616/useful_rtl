///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////

module ddr_simple_dual_port_ram
#(
   parameter DATA_WIDTH    = 8,
   parameter ADDR_WIDTH    = 9,
   parameter OUTPUT_REG    = "TRUE",
   parameter RAM_INIT_FILE = ""
)
(
   input  [(DATA_WIDTH-1):0]  wdata,
   input  [(ADDR_WIDTH-1):0]  waddr, raddr,
   input                      we, wclk, re, rclk,
   output    reg              wr_ack,rd_ack,
   output [(DATA_WIDTH-1):0]  rdata
);

   localparam MEMORY_DEPTH = 2**ADDR_WIDTH;
   localparam MAX_DATA     = (1<<ADDR_WIDTH)-1;
   
   reg  [DATA_WIDTH-1:0]   ram[MEMORY_DEPTH-1:0];
   wire [DATA_WIDTH-1:0]   r_rdata_1P;
   reg  [DATA_WIDTH-1:0]   r_rdata_2P;
   
   integer i;
   initial
   begin
   // By default the Efinix memory will initialize to 0
      if (RAM_INIT_FILE != "")
      begin
         $readmemh(RAM_INIT_FILE, ram);
      end
   end
   
   always @ (posedge wclk)
      if (we)
         ram[waddr] <= wdata;

   
   always@(posedge wclk)
      if (we)
         wr_ack <= 1'b1;
      else 
         wr_ack <= 1'b0;
   
   assign r_rdata_1P = re? ram[raddr] : 'hZ;
   
   always@(posedge rclk)
      if (re)
         rd_ack <= 1'b1;
      else  
         rd_ack <= 1'b0;
   
   always @ (posedge rclk)
   begin
         r_rdata_2P <= r_rdata_1P;
   end
   
   generate
      if (OUTPUT_REG == "TRUE")
         assign   rdata = r_rdata_2P;
      else
         assign   rdata = r_rdata_1P;
   endgenerate

endmodule
