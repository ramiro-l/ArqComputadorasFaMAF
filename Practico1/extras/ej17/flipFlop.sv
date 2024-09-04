module flipFlop
        (input logic in, clk, reset,
         output logic out);

    always_ff @(posedge clk, negedge reset)
        if (~reset)
            out <= '0;
        else
            out <= in;

endmodule
