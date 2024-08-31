module signext_tb();

    logic [8:0] inputs_data_type_D [3:0] = {
        {1'b1, $urandom},
        {1'b0, $urandom},
        {1'b1, $urandom},
        {1'b0, $urandom}
    };
    logic [18:0] inputs_data_type_CB [1:0] = {
        {1'b1, $urandom},
        {1'b0, $urandom}
    };
    logic [31:0] inputs_data_type_NOT_INSTRUCTION[1:0] = {
        {1'b0, $urandom},
        {3'b100, $urandom}
    };

    logic [31:0] inputs [7:0] = {
    //   | optcode 11 bit     |       data 9 bits        | rest 12 bits   |         Info         |
            {11'b111_1100_0010 , {inputs_data_type_D[3]} ,    12'b0      },  // LDUR POSITIVO+  | CASO 7 |
            {11'b111_1100_0010 , {inputs_data_type_D[2]} ,    12'b0      },  // LDUR NEGATIVO-  | CASO 6 |
            {11'b111_1100_0000 , {inputs_data_type_D[1]} ,    12'b0      },  // STUR POSITIVO+  | CASO 5 |
            {11'b111_1100_0000 , {inputs_data_type_D[0]} ,    12'b0      },  // STUR NEGATIVO-  | CASO 4 |
    //   | optcode 8 bit      |        data 19 bits      | rest 5 bits   |         Info
            {8'b101_1010_0     , {inputs_data_type_CB[1]} ,     5'b0     },  // CBZ POSITIVO+   | CASO 3 |
            {8'b101_1010_0     , {inputs_data_type_CB[0]} ,     5'b0     },  // CBZ NEGATIVO-   | CASO 2 |

            {inputs_data_type_NOT_INSTRUCTION[1]},                           // NOT_INSTRUCTION | CASO 1 |
            {inputs_data_type_NOT_INSTRUCTION[0]}                            // NOT_INSTRUCTION | CASO 0 |
    };

    logic [61:0] outputs [7:0] = {
            {{55{inputs_data_type_D[3][8]}}   , {inputs_data_type_D[3]}},      // LDUR POSITIVO+
            {{55{inputs_data_type_D[2][8]}}   , {inputs_data_type_D[2]}},      // LDUR NEGATIVO-
            {{55{inputs_data_type_D[1][8]}}   , {inputs_data_type_D[1]}},      // STUR POSITIVO+
            {{55{inputs_data_type_D[0][8]}}   , {inputs_data_type_D[0]}},      // STUR NEGATIVO-
            {{45{inputs_data_type_CB[1][18]}} , {inputs_data_type_CB[1]}},  // CBZ POSITIVO+
            {{45{inputs_data_type_CB[0][18]}} , {inputs_data_type_CB[0]}},  // CBZ NEGATIVO-
            {'0},{'0} // NOT_INSTRUCTION
    };

    logic [31:0] a;
    logic [61:0] y;

    signext dut(.a(a), .y(y));
    logic [31:0] errors, i;

    initial begin
        errors = 0; i = 0;
    end

    always begin
        a = inputs[i]; #1ns;
        if (y !== outputs[i]) begin
            $display("Error en el caso %d.", i);
            errors = errors+1;
        end
        #10ns; i++;
        if (i > 7) begin
            $display("Ocurrieron %d errores.", errors);
            $stop;
        end
    end

endmodule
