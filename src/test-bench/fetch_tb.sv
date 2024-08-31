module fetch_tb();
    logic PCSrc_F, clk, reset;
    logic [63:0] PCBranch_F;
    logic [63:0] imem_addr_F;

    fetch dut(PCSrc_F, clk, reset, PCBranch_F, imem_addr_F);

	// Inicializo el clock
	always begin
		clk = 1; #5ns; clk = 0; #5ns;
	end	

    logic errors;
    logic [63:0] PC_aux;

    initial begin
        errors = 0;
        PCSrc_F = 0;
        // Inicie con la señal reset= ‘1’ durante 5 ciclos de clock y luego coloque reset = ‘0’
        reset = 1;
        for (int i=0; i<5; ++i) begin
            if (imem_addr_F != 64'b0) begin
                $display("El caso %d FALLO (imem_addr_F != 0) y (reset = 1)", i);
				errors++;
            end
            # 10ns;
        end
        //Analice que después de colocar reset = ‘0’ el PC inicia en “0” y que después de cada flanco positivo de clock se actualiza PC= PC+4.
        # 5ns;
        reset = 0;
        if (imem_addr_F != 64'b0) begin
            $display("FAllO el caso en el que el reset se puso en 0 y verificamos que de 0.");
			errors++;
        end
        # 5ns;
        PC_aux = 64'd4;
        for (int i=0; i<5; ++i) begin
            # 1ns;
            if (imem_addr_F != PC_aux) begin
                $display("El caso %d FALLO (imem_addr_F != PC_aux) y (reset = 0)", i);
				errors++;
            end
            # 4ns;
            PC_aux = PC_aux + 64'd4;
            # 5ns;
        end
        // Coloque PCSrc_F= ‘1’ y en el siguiente flanco positivo de clock el PC tome el valor inicializado en PCbrach_F .
        PCBranch_F = 64'd16;
        PCSrc_F = 64'd1;
        # 15ns;
        if (imem_addr_F != PCBranch_F) begin
            $display("El caso del PCBranch_F FALLO.");
			errors++;
        end
        # 5ns;
        $display("Ocurrieron %d errores en el fecth_tb.", errors);
	    $stop;
    end
endmodule