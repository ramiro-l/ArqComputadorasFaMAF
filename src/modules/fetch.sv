module fetch (
    input logic PCSrc_F, clk, reset,
    input logic [63:0] PCBranch_F,
    output logic [63:0] imem_addr_F );

    logic [63:0] output_adder,output_mux, output_flopr;

	mux2  MUX(output_adder, PCBranch_F, PCSrc_F, output_mux);
	flopr PC(clk, reset, output_mux, output_flopr);
    adder Add(output_flopr, 64'd4, output_adder);
	
    assign imem_addr_F = output_flopr;

endmodule