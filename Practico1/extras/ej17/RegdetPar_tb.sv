`timescale 1 ns / 100 ps
`define CLK_FREQ 5
`define TESTVECTOR_SIZE 16
`define TESTVECTOR_INPUT_LONG 5
`define TESTVECTOR_OUTPUT_LONG 1


module RegdetPar_tb #(parameter int unsigned N = 4) ();

    logic clk, reset;
    // Configuracion del vector de test. (NO MODIFICAR!!)
    logic [31:0] _vector_index_, _error_count_;
    logic [`TESTVECTOR_INPUT_LONG+`TESTVECTOR_OUTPUT_LONG-1:0] _testvectors_ [0:`TESTVECTOR_SIZE-1];

    /* --------------------------------------------------------- */
    // Señales de entrada para el modulo a probar.
    logic [N-1:0] in;
    logic reset_module, out;

    // Modulo a probar.
    RegdetPar dut(
        .in(in),                // Input
        .clk(clk),              // Input
        .reset(reset_module),   // Input
        .out(out)               // Output
    );
    // Senales de salida del modulo a probar.
    logic expected_out;
    /* --------------------------------------------------------- */

    // Configurando las variables. (NO MODIFICAR!!)
    logic [`TESTVECTOR_INPUT_LONG-1:0]  _input_;
    logic [`TESTVECTOR_OUTPUT_LONG-1:0] _output_;
    logic [`TESTVECTOR_OUTPUT_LONG-1:0] _expected_output_;

    initial begin
        // (MODIFICAR CON CUIDADO!!)
        clk = 1; reset = 1;
        _error_count_ = 0;
        _vector_index_ = 0;
        reset_module = 0;

        /* --------------------------------------------------------- */
        $readmemb("RegdetPar_tv.bin", _testvectors_);
        /* --------------------------------------------------------- */

        #10; reset = 0;
    end


    always @(posedge clk) begin
        if (~reset) begin
            #1;
            /* --------------------------------------------------------- */
            // Obtenemos el output producido:
            _output_ =  { out } ;
            // Comparamos los resultados:
            if (_output_ !== _expected_output_) begin
                $display("\n**************************************************");
                $display("Error: TEST %d", _vector_index_);
                $display("  INPUT:");
                $display("  - DADO = %b", _input_);
                $display("\n");
                $display("  OUTPUT:");
                $display("  - OBTENIDO = %b", _output_);
                $display("  - ESPERADO = %b", _expected_output_);
                $display("**************************************************\n");
                _error_count_++;
            end
            /* --------------------------------------------------------- */
        end
    end


    always @(negedge clk) begin
        if (~reset) begin
            // Cargamos el test vector: (NO MODIFICAR!!)
            {_input_, _expected_output_} = _testvectors_[_vector_index_];

            /* --------------------------------------------------------- */
            // Cargamos los inputs:
            { in, reset_module } = _input_;
            // Cargamos los outputs esperados:
            { expected_out } = _expected_output_;
            #1;
            /* --------------------------------------------------------- */

            _vector_index_++;
        end
        if (_vector_index_ == `TESTVECTOR_SIZE+1) begin
            $display("\n==============================================================");
            $display("%d tests completados con %d errores", `TESTVECTOR_SIZE, _error_count_);
            $display("==============================================================\n");
            $stop;
        end
    end

    always begin
        clk = ~clk; #`CLK_FREQ;
    end

endmodule
