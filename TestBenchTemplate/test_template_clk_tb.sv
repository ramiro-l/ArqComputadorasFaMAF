// NOTA: este modulo NO anda, es solo un ejemplo de como podria ser un testbench.
`timescale 1 ns / 100 ps
`define CLK_FREQ 5

// MODIFICAR SEGUN SU NECESIDAD:
`define TESTVECTOR_SIZE 9999999
`define TESTVECTOR_INPUT_LONG 9999999
`define TESTVECTOR_OUTPUT_LONG 9999999


module test_template_clk_tb(); // (MODIFICAR NOMBRE)

    logic clk, reset;
    // Configuracion del vector de test. (NO MODIFICAR!!)
    logic [31:0] _vector_index_, _error_count_;
    logic [`TESTVECTOR_INPUT_LONG+`TESTVECTOR_OUTPUT_LONG-1:0] _testvectors_ [0:`TESTVECTOR_SIZE-1];

    /* --------------------------------------------------------- */
    // Señales de entrada para el modulo a probar. (MODIFICAR SEGUN ENTRADAS Y SALIDAS)
    logic input1, output1;

    // Modulo a probar. (MODIFICAR EL MODULO, LAS ENTRADAS Y SALIDAS)
    test_template_clk dut(
        .input1(input1),           // Input
        .output1(output1)          // Output
    );
    // Senales de salida del modulo a probar. (MODIFICAR SEGUN LAS SALIDAS)
    logic expected_output1;
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

        /* --------------------------------------------------------- */
        $readmemb("test_template_clk_tv.bin", _testvectors_); // (MODIFICAR SEGUN EL NOMBRE)
        /* --------------------------------------------------------- */

        #10; reset = 0;
    end


    always @(posedge clk) begin
        if (~reset) begin
            #1;
            /* --------------------------------------------------------- */
            // Comparamos los resultados: (MODIFICAR SEGUN SUS SALIDAS O ENTRADAS)
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
            // Cargamos los inputs: (MODIFICAR SEGUN LAS ENTRADAS)
            { input1 } = _input_;
            // Cargamos los outputs esperados: (MODIFICAR SEGUN LAS SALIDAS)
            { expected_output1 } = _expected_output_;
            #1;
            // Obtenemos el output producido: (MODIFICAR SEGUN LAS SALIDAS)
            _output_ = { output1 };
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
