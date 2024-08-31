module execute(
    input logic AluSrc,
    input logic [3:0] AluControl,
    input logic [63:0] PC_E, signImm_E, readData1_E, readData2_E,
    output logic [63:0] PCBranch_E, aluResult_E, writeData_E,
    output logic zero_E );

    logic output_sl2, output_mux;

    adder Add(.A(PC_E),
              .B(output_sl2),
              .Sum(PCBranch_E));

    sl2   ShiftLeft2(.in(signImm_E),
                     .out(output_sl2));

    mux2  MUX(.in1(readData2_E),
              .in2(signImm_E),
              .sel(AluSrc),
              .out(output_mux));

    alu   ALU(.in1(readData1_E),
             .in2(output_mux),
             .control(AluControl),
             .result(aluResult_E),
             .zero(zero_E));

    assign writeData_E = readData2_E;

endmodule
