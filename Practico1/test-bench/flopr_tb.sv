module flopr_tb();

    localparam int unsigned N = 64;

    logic clk;
    logic reset;
    logic [N-1: 0] d;
    logic [N-1: 0] q;

    logic [31:0] i, errors;
    logic [N-1:0] XS [0:9] = '{
            $urandom,
            $urandom,
            $urandom,
            $urandom,
            $urandom,
            $urandom,
            $urandom,
            $urandom,
            $urandom,
            $urandom
        };

    flopr #(N) dut(
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    initial begin
        i = 0; errors = 0;
        reset = 1;
        #50ns;
        reset = 0;
    end

    // Inicializo el clock
    always begin
        clk = 1; #5ns; clk = 0; #5ns;
    end

    always @(posedge clk) begin
            d = XS[i]; #1ns;

            // Revisamos que no de error los primero [0...4] casos.
            if (reset === 1)    begin
                if (q !== 0) begin
                    $display("El caso %d FALLO (q !== 0)", i);
                    errors = errors + 1;
                end
            end

            // Revisamos que no de error los casos [5...9].
            if (reset === 0) begin
                 if (q !== XS[i-1]) begin
                    $display("El caso %d FALLO (q !== XS[i-1])", i);
                    errors = errors + 1;
                end
            end

            if (d === 'x) // Terminamos todos los casos de uso asique paramos.
                begin
                    $display("Se detectaron %d errores en el test de flopr",errors);
                    $stop;
                end

             i++;

        end

endmodule
