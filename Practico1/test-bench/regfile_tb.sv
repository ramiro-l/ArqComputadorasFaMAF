module regfile_tb();
    logic clk, w_signal;
    logic [4:0] w_addres;
    logic [63:0] w_input;
    logic [4:0] r1_addres, r2_addres;
    logic [63:0] r1_output, r2_output;

    regfile dut(
        .clk(clk),
        .we3(w_signal),
        .ra1(r1_addres),
        .ra2(r2_addres),
        .wa3(w_addres),
        .wd3(w_input),
        .rd1(r1_output),
        .rd2(r2_output)
    );

    // Incializo el clock.
    always begin
        clk = 1; #5ns; clk = 0; #5ns;
    end
     logic [31:0] errors;

    initial begin
        // INICIALIZAMOS
        w_signal = '0;
        errors = 0;
        // TEST DE LECTURA
        w_signal = '0;
        for (int i = 0 ; i <= 30 ; i++ ) begin
            r1_addres = i;
            r2_addres = i;
            #5ns;
            if ( r1_output !== i) begin
                $display("La entrada de R1 para el registo X%d FALLO", i);
                errors = errors + 1;
            end
            if ( r2_output !== i) begin
                $display("La entrada de R2 para el registo X%d FALLO", i);
                errors = errors + 1;
            end
            #5ns;
        end
        // TEST DE ESCRITURA
        w_signal = '1;
        for (int i = 0 ; i <= 30 ; i++ ) begin
            w_addres = i;
            w_input = $urandom;
            #5ns;
            r1_addres = i;
            r2_addres = i;
            #1ns;
            if ( r1_output !== w_input || r2_output !== w_input) begin
                $display("El registro X%d NO se escribe correctamente", i);
                errors++;
            end
            #4ns;
        end
        w_signal = '0;
        // TEST DE LECTURA PARA EL REGISTRO XZR
        r1_addres = 5'd31;
        r2_addres = 5'd31;
        # 1ns;
        if ( r1_output !== 64'b0) begin
            $display("La entrada de R1 para el registo XZR FALLO");
            errors++;
        end
        if ( r2_output !== 64'b0) begin
            $display("La entrada de R2 para el registo XZR FALLO");
            errors++;
        end
        # 9ns;
        // TEST DE ESCRITURA PARA EL REGISTRO XZR
        w_signal = '1;
        w_addres = 5'd31;
        w_input = 64'd1;
        r1_addres = 5'd31;
        r2_addres = 5'd31;
        # 5ns;
        if ( r1_output !== 64'b0 || r2_output !== 64'b0) begin
            $display("El registro XZR se escribio y DEJO DE SER 0");
            errors++;
        end
        # 5ns;
        $display("Se detectaron %d errores en el test de regfile",errors);
        $stop;
    end

endmodule
