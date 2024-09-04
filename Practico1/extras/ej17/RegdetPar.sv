module RegdetPar #(parameter int unsigned N = 4)
                  (input logic [N-1:0] in, clk, reset,
                   output logic out);

    logic d;
    detPar #(N) detPar_inst (.in(in), .out(d));
    flopr #(N) flopr_inst (.clk(clk), .reset(reset), .d(in), .q(d));

endmodule
