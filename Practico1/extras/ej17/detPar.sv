module detPar #(parameter int unsigned N = 4)
        (input logic [N-1:0] in,
        output logic out);
    logic [N-1:0] temp;
    always_comb begin
        temp = in;
        out = 0;
        for (int i = 0; i < N; i = i + 1) begin
            out = out ^ temp[i];
        end
    end

endmodule
