module alu_tb();
    logic [63:0] a, b, result, result_expected;
    logic [3:0] ALUcontrol;
    logic zero, zero_expected;
    logic [30:0] errors, i;

    logic [196:0] inputs_and_expected_outputs [29:0] = {
    //   op_code     a           b           result      zero          op  sign
        { 4'b0000 ,  64'd1206 ,  64'd4404 ,  64'd52   , 1'b0  },  // AND ++
        { 4'b0000 , -64'd3781 , -64'd3642 , -64'd3838 , 1'b0  },  // AND --
        { 4'b0000 ,  64'd1749 , -64'd4761 ,  64'd1093 , 1'b0  },  // AND +-
        { 4'b0000 , -64'd2729 ,  64'd1176 ,  64'd1040 , 1'b0  },  // AND -+
        { 4'b0000 ,  64'd2060 ,  64'd4512 ,  64'd0    , 1'b1  },  // AND zero
        { 4'b0000 ,  64'd0    ,  64'd0    ,  64'd0    , 1'b1  },  // AND zero

        { 4'b0001 ,  64'd4249 ,  64'd3605 ,  64'd7837 , 1'b0  },  // OR  ++
        { 4'b0001 , -64'd1592 , -64'd1624 , -64'd1560 , 1'b0  },  // OR  --
        { 4'b0001 ,  64'd4967 , -64'd1791 , -64'd1177 , 1'b0  },  // OR  +-
        { 4'b0001 , -64'd4723 ,  64'd1265 , -64'd4611 , 1'b0  },  // OR  -+
        { 4'b0001 ,  64'd0    ,  64'd0    ,  64'd0    , 1'b1  },  // OR  zero

        { 4'b0010 ,  64'd4781 ,  64'd1346 ,  64'd6127 , 1'b0  },  // ADD ++
        { 4'b0010 , -64'd1612 , -64'd3144 , -64'd4756 , 1'b0  },  // ADD --
        { 4'b0010 ,  64'd1018 , -64'd2654 , -64'd1636 , 1'b0  },  // ADD +-
        { 4'b0010 , -64'd3112 ,  64'd2260 , -64'd852  , 1'b0  },  // ADD -+
        { 4'b0010 ,  64'd0    ,  64'd0    ,  64'd0    , 1'b1  },  // ADD zero
        { 4'b0010 ,  64'd0    ,  64'd0    ,  64'd0    , 1'b1  },  // ADD zero

        { 4'b0110 ,  64'd2108 ,  64'd2669 , -64'd561  , 1'b0  },  // SUB ++
        { 4'b0110 , -64'd3596 , -64'd2585 , -64'd1011 , 1'b0  },  // SUB --
        { 4'b0110 ,  64'd2561 , -64'd1864 ,  64'd4425 , 1'b0  },  // SUB +-
        { 4'b0110 , -64'd4970 ,  64'd1359 , -64'd6329 , 1'b0  },  // SUB -+
        { 4'b0110 ,  64'd0    ,  64'd0    ,  64'd0    , 1'b1  },  // SUB zero

        { 4'b0111 ,  64'd4356 ,  64'd3196 ,  64'd3196 , 1'b0  },  // SLT ++
        { 4'b0111 , -64'd1497 , -64'd4556 , -64'd4556 , 1'b0  },  // SLT --
        { 4'b0111 ,  64'd4721 , -64'd4816 , -64'd4816 , 1'b0  },  // SLT +-
        { 4'b0111 , -64'd1972 ,  64'd3314 ,  64'd3314 , 1'b0  },  // SLT -+
        { 4'b0111 ,  64'd1282 ,  64'd0    ,  64'd0    , 1'b1  },  // SLT zero
    //   op_code     a                b        result              zero        op           sign
       { 4'b0010 , 1'b0,{63{1'b1}} , 64'd1  , {64{1'b1}}       , 1'b1  }, // ADD overflow ++
        { 4'b0010 , {64{1'b1}}      , 64'd1  , 1'b1,{63{1'b0}}  , 1'b1  }, // ADD overflow -+
        { 4'b0110 , {64{1'b1}}      , 64'd1  , {63{1'b1}},1'b0  , 1'b0  }  // SUB overflow -+
    // OBS:  En los casos de overflow se trunca el resultado y tambien perdemos el signo.
    };

    alu dut(
        .a(a),
        .b(b),
        .ALUcontrol(ALUcontrol),
        .result(result),
        .zero(zero)
    );

    initial begin
        errors = 0; i = 0;
    end

    always begin
        #1ns;
        {ALUcontrol, a, b, result_expected, zero_expected} = inputs_and_expected_outputs[i];
        #1ns;

        if (result !== result_expected || zero !== zero_expected) begin
            errors = errors + 1;
            $display("Error en el caso %d.", i);
        end

         i++; #8ns;
        if (inputs_and_expected_outputs[i] === 'x) begin
            $display("Errores totales: %d.", errors);
            $stop;
        end
    end

endmodule
