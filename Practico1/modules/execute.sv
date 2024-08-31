module execute(
    input logic AluSrc,
    input logic [3:0] AluControl,
    input logic [63:0] PC_E, signImm_E, readData1_E, readData2_E,
    output logic [63:0] PCBranch_E, aluResult_E, writeData_E,
    output logic zero_E );

    logic [63:0] output_sl2, output_mux;

    adder #(64) Add(.a(PC_E),
                    .b(output_sl2),
                    .y(PCBranch_E));

    sl2  #(64) ShiftLeft2(.a(signImm_E),
                          .y(output_sl2));

    mux2 #(64) MUX(.d0(readData2_E),
                   .d1(signImm_E),
                   .s(AluSrc),
                   .y(output_mux));

    alu ALU(.a(readData1_E),
            .b(output_mux),
            .ALUControl(AluControl),
            .result(aluResult_E),
            .zero(zero_E));

    assign writeData_E = readData2_E;

endmodule
