#### 奇偶校验

The odd parity checking appends a bit so that the total number of bits with value 1 is odd. Similarly, the even parity checking appends a bit so that the total number of bits with value 1 is even.

奇校验：原始码流+校验位 总共有奇数个1

偶校验：原始码流+校验位 总共有偶数个1



```verilog
//使用XOR法设计奇偶校验器
module parity_checker01(
    input           clk,
    input           rst_n,
    input           parity_odd,	//是否为奇校验：奇数校验为1，偶数校验位0
    input   [7:0]   data_in,	//输入的八位数据
    output  [8:0]   data_out,	//输出的九位数据
    output  reg     even_bit,	//偶数校验码
    output  reg     odd_bit		//计数校验码
    );
 
 //使用按位异或确定偶数校验码和奇数校验码   
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
	    even_bit <= 1'b0;
	    odd_bit  <= 1'b0;
    end
    else begin
	    even_bit <= ^data_in;   //偶校验条件下计算出来的校验位
	    odd_bit  <= ~(^data_in);//奇校验条件下计算出来的校验位
    end
end
 
 //组合逻辑完成输入数据与校验码的拼接
assign data_out = parity_odd ? {data_in[7:0],odd_bit} 
		      	     : {data_in[7:0],even_bit};
   
endmodule
```
