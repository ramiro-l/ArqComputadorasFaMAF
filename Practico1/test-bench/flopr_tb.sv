module flopr_tb();

	parameter N = 64;

	logic clk;
	logic reset;
	logic [N-1: 0] d;
	logic [N-1: 0] q;
	
	logic [31:0] i, errors;
	logic [N-1:0] XS [0:9] = '{
			$random,
			$random,
			$random,
			$random,
			$random,
			$random,
			$random,
			$random,
			$random,
			$random
		};
		
	flopr #(N) dut(clk, reset, d, q);
	
	initial begin
		i = 0; errors = 0;
		reset = 1;
		#50ns; 
		reset = 0;
	end
	
	// Inicializo el clock
	always begin
		clk = 1; #5ns; clk = 0; #5ns; // ESTO ES UN CLOCK DE 10ns ???????????????????????????
	end	

	always @(posedge clk) begin
			d = XS[i]; #1ns;
			
			// Revisamos que no de error los primero [0...4] casos.
			if (reset === 1)	begin
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
				
			i = i + 1;
		
		end
endmodule 