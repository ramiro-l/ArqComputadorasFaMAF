module fetch (
    input logic PCSrc_F, clk, reset,
    input logic [63:0] PCBranch_F,
    output logic [63:0] imem_addr_F );

    logic [63:0] output_adder,output_mux, output_flopr;

    mux2 MUX(.d0(output_adder),
             .d1(PCBranch_F),
             .s(PCSrc_F),
             .y(output_mux));

    flopr PC(.clk(clk),
             .reset(reset),
             .d(output_mux),
             .q(output_flopr));

    adder Add(.a(output_flopr),
              .b(64'd4),
              .y(output_adder));

    assign imem_addr_F = output_flopr;

endmodule
