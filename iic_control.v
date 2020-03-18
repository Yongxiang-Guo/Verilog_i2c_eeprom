`timescale 1ns/1ps
////////////////////////////////////////////
//Module Name	:	iic_control
//Description	:	read and write eeprom using iic bus
//Editor			:	Yongxiang
//Time			:	2019-11-25
////////////////////////////////////////////
module iic_control
	(
		input wire	clk_50M,
		input wire	rst_n,
		output reg	wr_sig,
		output reg	rd_sig,
		output reg[7:0]	addr_sig,
		output reg[7:0]	wr_data,
		input wire	done_sig
	);

reg[1:0] state;

//eeprom先写后读
always @(posedge clk_50M)
begin
	if(!rst_n)begin
		state <= 2'd0;
		addr_sig <= 8'd0;
		wr_data <= 8'd0;
		rd_sig <= 1'b0;
		wr_sig <= 1'b0;
	end
	else begin
		case(state)
			2'd0:begin
				if(done_sig)begin
					wr_sig <= 1'b0;
					rd_sig <= 1'b0;
					state <= 2'd1;
				end
				else begin
					wr_sig <= 1'b1;
					rd_sig <= 1'b0;
					wr_data <= 8'hff;	//写入数据0Xff
					addr_sig <= 8'd0;	//在eeprom的0X00地址写入数据
				end
			end
			2'd1:begin
				if(done_sig)begin
					wr_sig <= 1'b0;
					rd_sig <= 1'b0;
					state <= 2'd2;
				end
				else begin
					wr_sig <= 1'b0;
					rd_sig <= 1'b1;
					addr_sig <= 8'd0;	//在eeprom的0X00地址写入数据
				end
			end
			2'd2:begin
				state <= 2'd2;
			end
		endcase
	end
end

endmodule
