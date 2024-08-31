module fetch (
    input logic PCSrc_F, clk, reset,
    input logic [63:0] PCBranch_F,
    output logic [63:0] imem_addr_F );

    logic [63:0] output_adder,output_mux, output_flopr;

    mux2 MUX(.out(output_adder),
             .in1(PCBranch_F),
             .in2(PCSrc_F),
             .out(output_mux));

    flopr PC(.clk(clk),
             .reset(reset),
             .d(output_mux),
             .q(output_flopr));

    adder Add(.in1(output_flopr),
              .in2(64'd4),
              .out(output_adder));

    assign imem_addr_F = output_flopr;

endmodule
