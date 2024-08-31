module maindec(
    input logic [10:0] Op,
    output logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
    output logic [1:0] ALUOp);

    logic [8:0] output_signals [0:4] = '{
        9'b0_1_1_1_1_0_0_00, // LDUR
        9'b1_1_0_0_0_1_0_00, // STUR
        9'b1_0_0_0_0_0_1_01, // CBZ
        9'b0_0_0_1_0_0_0_10, // R-format
        9'b0_0_0_0_0_0_0_00  // default
    };

    always_comb begin
        casez (Op)
            // LDUR
            11'b111_1100_0010: {
                Reg2Loc,
                ALUSrc,
                MemtoReg,
                RegWrite,
                MemRead,
                MemWrite,
                Branch,
                ALUOp } = output_signals[0]; 
            // STUR
            11'b111_1100_0000: {
                Reg2Loc,
                ALUSrc,
                MemtoReg,
                RegWrite,
                MemRead,
                MemWrite,
                Branch,
                ALUOp } = output_signals[1]; 
            // CBZ 
            11'b101_1010_0???: {
                Reg2Loc,
                ALUSrc,
                MemtoReg,
                RegWrite,
                MemRead,
                MemWrite,
                Branch,
                ALUOp } = output_signals[2]; 
            // TYPE R
            11'b100_0101_1000,
            11'b110_0101_1000,
            11'b100_0101_0000,
            11'b101_0101_0000: {
                Reg2Loc,
                ALUSrc,
                MemtoReg,
                RegWrite,
                MemRead,
                MemWrite,
                Branch,
                ALUOp } = output_signals[3];
            default: {
                Reg2Loc,
                ALUSrc,
                MemtoReg,
                RegWrite,
                MemRead,
                MemWrite,
                Branch,
                ALUOp } = output_signals[4];   
        endcase
    end

endmodule