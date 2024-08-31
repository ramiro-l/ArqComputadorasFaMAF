`timescale 1 ns / 100 ps
`define CLK_FREQ 5
`define TESTVECTOR_SIZE 2
`define TESTVECTOR_INPUT_LONG 261
`define TESTVECTOR_OUTPUT_LONG 193


module execute_tb();
    // Configuracion del vector de test.
    logic [31:0]  _error_count_;
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
        _error_count_ = 0;

        /* --------------------------------------------------------- */
        $readmemb("execute_tv.bin", _testvectors_);
        /* --------------------------------------------------------- */

        #(`CLK_FREQ*2);
        for (int i = 0; i < `TESTVECTOR_SIZE; i++) begin
            // Cargamos el test vector:
            {_input_, _expected_output_} = _testvectors_[i];

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
            #`CLK_FREQ;
            /* --------------------------------------------------------- */

            /* --------------------------------------------------------- */
            // Obtenemos el output producido:
            _output_ = { PCBranch_E,
                         aluResult_E,
                         writeData_E,
                         zero_E };
            if (_output_ !== _expected_output_) begin
                $display("\n**************************************************");
                $display("Error: TEST %d", i);
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
            #`CLK_FREQ;
        end

        $display("\n==============================================================");
        $display("%d tests completados con %d errores", `TESTVECTOR_SIZE, _error_count_);
        $display("==============================================================\n");
        $stop;
    end

endmodule
