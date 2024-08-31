module maindec_tb();
    logic [10:0] Op;
    logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    logic [1:0] ALUOp;

    logic [19:0] op_and_expected_signals [0:9] = '{
        {11'b111_1100_0010, 9'b0_1_1_1_1_0_0_00}, // LDUR
        {11'b111_1100_0000, 9'b1_1_0_0_0_1_0_00}, // STUR
        {11'b101_1010_0001, 9'b1_0_0_0_0_0_1_01}, // CBZ
        {11'b101_1010_0010, 9'b1_0_0_0_0_0_1_01}, // CBZ
        {11'b101_1010_0100, 9'b1_0_0_0_0_0_1_01}, // CBZ
        {11'b100_0101_1000, 9'b0_0_0_1_0_0_0_10}, // R-format 
        {11'b110_0101_1000, 9'b0_0_0_1_0_0_0_10}, // R-format 
        {11'b100_0101_0000, 9'b0_0_0_1_0_0_0_10}, // R-format 
        {11'b101_0101_0000, 9'b0_0_0_1_0_0_0_10}, // R-format 
        {11'b000_0000_1111, 9'b0_0_0_0_0_0_0_00}  // default
    };

    logic [31:0] errors;

    maindec dut(Op, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);
    
    logic Reg2Loc_expected, ALUSrc_expected, MemtoReg_expected, RegWrite_expected, MemRead_expected, MemWrite_expected, Branch_expected;
    logic [1:0] ALUOp_expected;

    initial begin
        errors = 0;
        for (int i=0; i<10; ++i) begin
            # 1ns;
            {Op, Reg2Loc_expected, ALUSrc_expected, MemtoReg_expected, RegWrite_expected, MemRead_expected, MemWrite_expected, Branch_expected, ALUOp_expected} = op_and_expected_signals[i];
            # 1ns;
            if (Reg2Loc !== Reg2Loc_expected & 
                ALUSrc !== ALUSrc_expected & 
                MemtoReg !== MemtoReg_expected & 
                RegWrite !== RegWrite_expected & 
                MemRead !== MemRead_expected & 
                MemWrite !== MemWrite_expected & 
                Branch !== Branch_expected & 
                ALUOp !== ALUOp_expected ) begin
                    $display("El caso %d FALLO.", i);
                    errors++;
            end
            # 8ns;
        end
        $display("Ocurrieron %d errores en el maindec_tb.", errors);
	    $stop;
    end
endmodule