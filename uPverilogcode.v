// ELEC4480 DCA (Verilog)
// Assignment4, 

module assign4 (
	input CK, 	
	input RESET, 		
	output reg DONE, 
	output reg [4:0] OUTADDR, 
	output reg [31:0] OUTDATA, 
	output reg OUTVALID	
	);
	
	reg [31:0] PC;				//Program Counter
	reg [31:0] ROM[26:0];	//Instructions
	reg [31:0] R[31:0];		//Registers
	reg [31:0] M[31:0];		//Memory
	wire [31:0] instruction = ROM[PC[6:2]];
	wire [5:0] opcode = instruction[31:26];
	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [4:0] rd = instruction[15:11];
	wire [4:0] shamt = instruction[10:6];
	wire [5:0] funct = instruction[5:0];
   wire [31:0] im = {{16{instruction[15]}}, instruction[15:0]}; 
	// ^^ for immediate instructions, MSB sign- extended 
   wire [25:0]	ads = instruction[25:0];	//for jump instructions
	wire [6:0] temp = R[rs] + im;
	integer a;

	initial
	begin
		DONE 		<=0;
		ROM[0]	<=32'b00100100000010110000000000000100; 
		ROM[1]	<=32'b00100100000010100000000000000000; 
		ROM[2]	<=32'b00100100000010010000000000000001; 
		ROM[3]	<=32'b00100100000010000000000000000000; 
		ROM[4]	<=32'b00100100000011000010000000000000; 
		ROM[5]	<=32'b10101101100010100000000000000000; 
		ROM[6]	<=32'b00000001010010010101000000100001; 
		ROM[7]	<=32'b00100101100011000000000000000100; 
		ROM[8]	<=32'b00101101010000010000000000010000; 
		ROM[9]	<=32'b00010100001000001111111111111011; 
		ROM[10]	<=32'b00100101100011000000000000001000;
		ROM[11]	<=32'b00000001010010010101000000100011;
		ROM[12]	<=32'b10101101100010101111111111111000;
		ROM[13]	<=32'b00000001100010110110000000100001;
		ROM[14]	<=32'b00010001010000000000000000000001;
		ROM[15]	<=32'b00001000000000000000000000001011;
		ROM[16]	<=32'b00100100000011000001111111111000;
		ROM[17]	<=32'b00100100000010110000000000100000;
		ROM[18]	<=32'b10001101100011010000000000001000;
		ROM[19]	<=32'b00100101101011011000000000000000;
		ROM[20]	<=32'b10101101100011010000000000001000;
		ROM[21]	<=32'b00000001010010010101000000100001;
		ROM[22]	<=32'b00100101100011000000000000000100;
		ROM[23]	<=32'b00000001010010110000100000101011;
		ROM[24]	<=32'b00010100001000001111111111111001;
		ROM[25]	<=32'b00100100000000100000000000001010;
		ROM[26]	<=32'b00000000000000000000000000001100;
	end
			
			
	always @(posedge CK)
	begin	
		OUTVALID <= 0;
		
		//If RESET asserted, reset PC, clear registers + memory
		if (RESET == 1)
		begin
			PC = 0;
			for (a = 0; a < 32; a = a+1) 
			begin
				R[a] <= 32'b00000000000000000000000000000000;
				M[a] <= 32'b00000000000000000000000000000000;
			end 
		end
		
		//if RESET not asserted, process instructions
		if (RESET != 1)
		begin			
			PC = PC + 4;
			case (opcode)
								//all R-Type
				6'b000000: 	
				begin		
				case (funct)
					6'b100001:							//ADDU
						R[rd] <= R[rs] + R[rt];
					6'b101011:							//STLU
						R[rd] <= (R[rs] < R[rt])? 1:0; 
					6'b100011:							//SUBU
						R[rd] <= R[rs] - R[rt];
					6'b001100: 							//SYSCALL
						DONE <= 1;
				endcase
				end
								//all I-Type
				6'b001001:							//ADDIU
					R[rt] <= R[rs] + im;
				6'b000100:							//BEQ
					if(R[rs]==R[rt]) 
						PC = PC + {im, 2'b00};
				6'b000101:							//BNE
					if(R[rs]!=R[rt])
						PC = PC + {im, 2'b00};
				6'b100011:							//LW
					R[rt] <= M[temp[6:2]];
				6'b101011:							//SW
				begin
					M[temp[6:2]] <= R[rt];
					OUTADDR <= temp[6:2];
					OUTDATA <= R[rt];
					OUTVALID <= 1;
				end
				6'b001011:							//SLTIU
					R[rt] <= (R[rs] < im)? 1:0;
								//all J-Type
				6'b000010:							//JUMP
					PC <= {ads, 2'b00};	
					// "2'b00" is used to shift left by 2
			endcase
		end
	end
		
endmodule
 



