`timescale 1 ns / 100 ps
`define CLK_FREQ 5
`define TESTVECTOR_SIZE 4
`define TESTVECTOR_INPUT_LONG 261
`define TESTVECTOR_OUTPUT_LONG 193


module execute_tb();

    logic clk, reset;
    logic [31:0] _vector_index_, _error_count_;
    logic [`TESTVECTOR_INPUT_LONG+`TESTVECTOR_OUTPUT_LONG-1:0] _testvectors_ [0:`TESTVECTOR_SIZE-1];

    /* --------------------------------------------------------- */
    // Señales de entrada para el modulo a probar.
    logic AluSrc;
    logic [3:0] AluControl;
    logic [63:0] PC_E, signImm_E, readData1_E, readData2_E;
    logic [63:0] PCBranch_E, aluResult_E, writeData_E;
    logic zero_E;

    // Modulo a probar.
    execute dut(
        .AluSrc(AluSrc),           // Input
        .AluControl(AluControl),   // Input
        .PC_E(PC_E),               // Input
        .signImm_E(signImm_E),     // Input
        .readData1_E(readData1_E), // Input
        .readData2_E(readData2_E), // Input
        .PCBranch_E(PCBranch_E),   // Output
        .aluResult_E(aluResult_E), // Output
        .writeData_E(writeData_E), // Output
        .zero_E(zero_E)            // Output
    );
    // Senales de salida del modulo a probar.
    logic [63:0] expected_PCBranch_E, expected_aluResult_E, expected_writeData_E;
    logic expected_zero_E;
    /* --------------------------------------------------------- */

    // Configurando las variables.
    logic [`TESTVECTOR_INPUT_LONG-1:0]  _input_;
    logic [`TESTVECTOR_OUTPUT_LONG-1:0] _output_;
    logic [`TESTVECTOR_OUTPUT_LONG-1:0] _expected_output_;

    initial begin
        clk = 1; reset = 1;
        _error_count_ = 0;
        _vector_index_ = 0;

        /* --------------------------------------------------------- */
        $readmemb("execute_tv.bin", _testvectors_);
        /* --------------------------------------------------------- */

        #100; reset = 0;
    end


    always @(posedge clk) begin
        if (~reset) begin
            #1;
            /* --------------------------------------------------------- */
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
            // Cargamos el test vector:
            {_input_, _expected_output_} = _testvectors_[_vector_index_];

            /* --------------------------------------------------------- */
            // Cargamos los inputs:
            { AluSrc,
              AluControl,
              PC_E,
              signImm_E,
              readData1_E,
              readData2_E } = _input_;
            // Cargamos los outputs esperados:
            { expected_PCBranch_E,
              expected_aluResult_E,
              expected_writeData_E,
              expected_zero_E } = _expected_output_;
            #1;
            // Obtenemos el output producido:
            _output_ = { PCBranch_E,
                         aluResult_E,
                         writeData_E,
                         zero_E };
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
