`timescale 1ns / 1ns
module tb_memory_tester();

    parameter   DATA_WIDTH   = 128;
    parameter   ADDR_WIDTH   = 32;
    parameter   ID_WIDTH     = 8;
    parameter   AWUSER_WIDTH = 1;
    parameter   WUSER_WIDTH  = 1;
    parameter   BUSER_WIDTH  = 1;
    parameter   ARUSER_WIDTH = 1;
    parameter   RUSER_WIDTH  = 1;
    parameter ALEN        =  7;
    parameter START_ADDR  = 32'h00000000;
    parameter STOP_ADDR   = 32'h00001000;



logic clk;
logic rst_n;

logic pass;

logic [ID_WIDTH - 1 : 0]       awid;
logic [ADDR_WIDTH - 1 : 0]     awaddr;
logic [7 : 0]                  awlen;
logic [2 : 0]                  awsize;
logic [1 : 0]                  awburst;
logic                          awlock;
logic [3 : 0]                  awcache;
logic [2 : 0]                  awprot;
logic [3 : 0]                  awqos;
logic [3 : 0]                  awregion;
logic [AWUSER_WIDTH - 1 : 0]   awuser;
logic                          awvalid;
logic                          awready;
logic [DATA_WIDTH - 1 : 0]     wdata;
logic [DATA_WIDTH / 8 - 1 : 0] wstrb;
logic                          wlast;
logic [WUSER_WIDTH - 1 : 0]    wuser;
logic                          wvalid;
logic                          wready;
logic [ID_WIDTH - 1 : 0]       bid;
logic [1 : 0]                  bresp;
logic [BUSER_WIDTH - 1 : 0]    buser;
logic                          bvalid;
logic                          bready;
logic [ID_WIDTH - 1 : 0]       arid;
logic [ADDR_WIDTH - 1 : 0]     araddr;
logic [7 : 0]                  arlen;
logic [2 : 0]                  arsize;
logic [1 : 0]                  arburst;
logic                          arlock;
logic [3 : 0]                  arcache;
logic [2 : 0]                  arprot;
logic [3 : 0]                  arqos;
logic [3 : 0]                  arregion;
logic [ARUSER_WIDTH - 1 : 0]   aruser;
logic                          arvalid;
logic                          arready;
logic [ID_WIDTH - 1 : 0]       rid;
logic [DATA_WIDTH - 1 : 0]     rdata;
logic [1 : 0]                  rresp;
logic                          rlast;
logic [RUSER_WIDTH - 1 : 0]    ruser;
logic                          rvalid;
logic                          rready;


logic          wr_ack;               
logic  [31:0]  wr_addr;              
logic          wr_addr_en;           
logic          wr_busy;              
logic  [127:0] wr_data;              
logic  [15:0]  wr_datamask;          
logic          wr_en;                
logic  [31:0]  rd_addr;              
logic          rd_addr_en;           
logic          rd_busy;              
logic  [127:0] rd_data;              
logic          rd_en;                
logic          rd_valid;             
logic          rd_ack;               



//生成复位
  initial
  begin:GEN_RST
    rst_n = 1'b0;
    repeat(100)@(posedge clk);
    rst_n=1'b1;
  end

//生成时钟
  initial
  begin:GEN_CLK
  clk = 1'b0;
    forever
      #(5) clk=~clk;
  end

// initial begin 

//     @(posedge tb_memory_tester.tester.w_pattern_done);
//     repeat(1000)@(posedge clk);
//     $finish; 
// end 
ddr_slave_wrapper #(
    .DATA_WIDTH   (DATA_WIDTH   ),                              
    .ADDR_WIDTH   (ADDR_WIDTH   ),                              
    .ID_WIDTH     (ID_WIDTH     ),                              
    .AWUSER_WIDTH (AWUSER_WIDTH ),                              
    .WUSER_WIDTH  (WUSER_WIDTH  ),                              
    .BUSER_WIDTH  (BUSER_WIDTH  ),                              
    .ARUSER_WIDTH (ARUSER_WIDTH ),                              
    .RUSER_WIDTH  (RUSER_WIDTH  )                         
)ddr_slave(
    .aclk     (clk     ) ,
    .aresetn  (rst_n  )     ,
    .wr_busy  (wr_busy  )     ,
    .wr_data  (wr_data  )     ,
    .wr_datamask(wr_datamask)         ,
    .wr_addr  (wr_addr  )     ,
    .wr_en    (wr_en    ) ,
    .wr_addr_en(wr_addr_en)     ,
    .wr_ack   (wr_ack   ) ,
    .rd_busy  (rd_busy  )     ,
    .rd_addr  (rd_addr  )     ,
    .rd_addr_en(rd_addr_en)     ,
    .rd_en    (rd_en    ) ,
    .rd_data  (rd_data  )     ,
    .rd_valid (rd_valid )     ,
    .rd_ack   (rd_ack   )     ,
    .awid     (awid     ) ,
    .awaddr   (awaddr   ) ,
    .awlen    (awlen    ) ,
    .awsize   (awsize   ) ,
    .awburst  (awburst  )     ,
    .awlock   (awlock   ) ,
    .awcache  (awcache  )     ,
    .awprot   (awprot   ) ,
    .awqos    (awqos    ) ,
    .awregion (awregion )     ,
    .awuser   (awuser   ) ,
    .awvalid  (awvalid  )     ,
    .awready  (awready  )     ,
    .wdata    (wdata    ) ,
    .wstrb    (wstrb    ) ,
    .wlast    (wlast    ) ,
    .wuser    (wuser    ) ,
    .wvalid   (wvalid   ) ,
    .wready   (wready   ) ,
    .bid      (bid      ) ,
    .bresp    (bresp    ) ,
    .buser    (buser    ) ,
    .bvalid   (bvalid   ) ,
    .bready   (bready   ) ,
    .arid     (arid     ) ,
    .araddr   (araddr   ) ,
    .arlen    (arlen    ) ,
    .arsize   (arsize   ) ,
    .arburst  (arburst  )     ,
    .arlock   (arlock   ) ,
    .arcache  (arcache  )     ,
    .arprot   (arprot   ) ,
    .arqos    (arqos    ) ,
    .arregion (arregion )     ,
    .aruser   (aruser   ) ,
    .arvalid  (arvalid  )     ,
    .arready  (arready  )     ,
    .rid      (rid      ) ,
    .rdata    (rdata    ) ,
    .rresp    (rresp    ) ,
    .rlast    (rlast    ) ,
    .ruser    (ruser    ) ,
    .rvalid   (rvalid   ) ,
    .rready   (rready   )
);



memory_tester # 
(
     .WIDTH        (DATA_WIDTH       ),   
    .ALEN         (ALEN        ),   
    .START_ADDR   (START_ADDR  ),   
    .STOP_ADDR    (STOP_ADDR   ),   
    .ID_WIDTH     (ID_WIDTH    ),   
    .ADDR_WIDTH   (ADDR_WIDTH  ),   
    .WUSER_WIDTH  (WUSER_WIDTH ),   
    .AWUSER_WIDTH (AWUSER_WIDTH),   
    .RUSER_WIDTH  (RUSER_WIDTH ),   
	.BUSER_WIDTH  (BUSER_WIDTH ),   
	.ARUSER_WIDTH (ARUSER_WIDTH)   
)tester (.*);


 simple_ddr #(
    .WFIFO_WIDTH(128), //fixed
    .DM_BIT_WIDTH(16)
 )ddr_controler_U(
    .clk        (clk        )                   ,
    .rst_n      (rst_n      )                   ,
    .wr_busy    (wr_busy    )  ,
    .wr_data    (wr_data    )  ,
    .wr_datamask(wr_datamask)  ,
    .wr_addr    (wr_addr    )  ,
    .wr_en      (wr_en      )  ,
    .wr_addr_en (wr_addr_en )  ,
    .wr_ack     (wr_ack     )  ,
    .rd_busy    (rd_busy    )  ,
    .rd_addr    (rd_addr    )  ,
    .rd_addr_en (rd_addr_en )  ,
    .rd_en      (rd_en      )  ,
    .rd_data    (rd_data    )  ,
    .rd_valid   (rd_valid   )  ,
    .rd_ack     (rd_ack     )  
);

endmodule