module signext (
	input logic [31:0] a,
	output logic [63:0] y );

	always_comb
		// Usar casez para poder detectar los singos de pregunta "?".
		casez (a[31:21])
			 11'b111_1100_0010: y = {{55{a[20]}}, a[20:12]}; // LDUR
			 11'b111_1100_0000: y = {{55{a[20]}}, a[20:12]}; // STUR
			 11'b101_1010_0???: y = {{45{a[23]}}, a[23:5] }; // CBZ
			 // En cualquier otro caso:
			 default: y = '0;										    
		endcase
endmodule 