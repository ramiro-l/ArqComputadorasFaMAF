module RegdetPar #(parameter int unsigned N = 4)
                  (input logic clk, reset,
                   input logic [N-1:0] in,
                   output logic out);

    logic d;
    detPar #(N) detPar_inst (.in(in), .out(d));
    flopr #(N) flopr_inst (.clk(clk), .reset(reset), .d(d), .q(out));

endmodule
