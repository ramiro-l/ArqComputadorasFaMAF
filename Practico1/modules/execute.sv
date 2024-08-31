module execute(
    input logic AluSrc,
    input logic [3:0] AluControl,
    input logic [63:0] PC_E, signImm_E, readData1_E, readData2_E,
    output logic [63:0] PCBranch_E, aluResult_E, writeData_E, 
    output logic zero_E );

    logic output_sl2, output_mux;

    adder Add(PC_E, output_sl2, PCBranch_E);
    sl2   ShiftLeft2(signImm_E, output_sl2);
    mux2  MUX(readData2_E, signImm_E, AluSrc, output_mux);
    alu   ALU(readData1_E, output_mux, AluControl, aluResult_E, zero_E);

    assign writeData_E = readData2_E;
    
endmodule