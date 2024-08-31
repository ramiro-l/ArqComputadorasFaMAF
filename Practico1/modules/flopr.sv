module flopr #(parameter int unsigned N = 64)
    (input logic clk,
     input logic reset,
     input logic [N-1:0] d,
     output logic [N-1:0] q );

     always_ff @(posedge clk, posedge reset)
        if (reset) q <= '0;
        else q <= d;

endmodule
