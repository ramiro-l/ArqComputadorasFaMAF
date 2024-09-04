module flipFlop
        (input logic d, clk, reset,
         output logic q);

    always_ff @(posedge clk, negedge reset)
        if (~reset)
            q <= 1'b0;
        else
            q <= d;

endmodule
