from lib.module import Module
from lib.test_module import TestModule

ALU_CODE = {
    'AND':  0b0000,
    'OR':  0b0001,
    'ADD':  0b0010,
    'SUB':  0b0110,
    'SLT':  0b0111,
}

ALU_OPERATION = {
    0b0000: lambda a, b: a & b,
    0b0001: lambda a, b: a | b,
    0b0010: lambda a, b: a + b,
    0b0110: lambda a, b: a - b,
    0b0111: lambda a, b: b,
}


class Execute(Module):
    def apply_logic(self, inputs_gates_values: dict[str, int]) -> dict[str, int]:
        # Extract inputs
        alu_src = inputs_gates_values.get("AluSrc")
        alu_control = inputs_gates_values.get("AluControl")
        PC_E = inputs_gates_values.get("PC_E")
        sign_imm_e = inputs_gates_values.get("signImm_E")
        read_data1_e = inputs_gates_values.get("readData1_E")
        read_data2_e = inputs_gates_values.get("readData2_E")
        # Logic
        if alu_src:
            alu_b = sign_imm_e
        else:
            alu_b = read_data2_e
        alu_result = ALU_OPERATION[alu_control](read_data1_e, alu_b)
        if alu_result == 0:
            is_zero = 1
        else:
            is_zero = 0

        # end logic

        # Return outputs
        return {
            "PCBranch_E": (PC_E+(sign_imm_e << 2)),
            "aluResult_E": (alu_result),
            "writeData_E": (read_data2_e),
            "zero_E": (is_zero)
        }


execute_module = Execute("execute", {
    "AluSrc": 1,
    "AluControl": 4,
    "PC_E": 64,
    "signImm_E": 64,
    "readData1_E": 64,
    "readData2_E": 64
}, {
    "PCBranch_E": 64,
    "aluResult_E": 64,
    "writeData_E": 64,
    "zero_E": 1
})

test_module = TestModule(execute_module)

test_module.add_case({
    "AluSrc": 0,
    "AluControl": ALU_CODE["SLT"],
    "PC_E": 0,
    "signImm_E": 0,
    "readData1_E": 0,
    "readData2_E": 0
})
test_module.add_case({
    "AluSrc": 0,
    "AluControl": ALU_CODE["SLT"],
    "PC_E": 4,
    "signImm_E": 4,
    "readData1_E": 0,
    "readData2_E": 0
})
test_module.add_case({
    "AluSrc": 0,
    "AluControl": ALU_CODE["ADD"],
    "PC_E": 0,
    "signImm_E": 6,
    "readData1_E": 7,
    "readData2_E": 8
})
test_module.add_case({
    "AluSrc": 1,
    "AluControl": ALU_CODE["ADD"],
    "PC_E": 0,
    "signImm_E": 6,
    "readData1_E": 7,
    "readData2_E": 8
})

test_module.print_systemverilog_info()
test_module.export_bin_file("./Practico1/test-bench/", "bin")
