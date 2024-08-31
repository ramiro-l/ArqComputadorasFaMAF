from case_generator import Case
import random

ALU_CODE = {
    'AND':  0b0000,
    'OR':  0b0001,
    'ADD':  0b0010,
    'SUB':  0b0110,
    'SLT':  0b0111,
}

ALU_OPERATION = {
    'AND': lambda a, b: a & b,
    'OR': lambda a, b: a | b,
    'ADD': lambda a, b: a + b,
    'SUB': lambda a, b: a - b,
    'SLT': lambda a, b: b,
}


class ExecuteCase(Case):
    def __init__(self, AluSrc: int, AluControl: str, PC_E: int, signImm_E: int, readData1_E: int, readData2_E: int):
        inputs = {
            "AluSrc": (AluSrc, 1),
            "AluControl": (ALU_CODE[AluControl], 4),
            "PC_E": (PC_E, 64),
            "signImm_E": (signImm_E, 64),
            "readData1_E": (readData1_E, 64),
            "readData2_E": (readData2_E, 64)
        }
        # Logic
        if AluSrc:
            alu_b = signImm_E
        else:
            alu_b = readData2_E
        alu_result = ALU_OPERATION[AluControl](readData1_E, alu_b)
        if alu_result == 0:
            is_zero = 1
        else:
            is_zero = 0
        # end logic
        outputs = {
            "PCBranch_E": (PC_E+(signImm_E << 2), 64),
            "aluResult_E": (alu_result, 64),
            "writeData_E": (readData2_E, 64),
            "zero_E": (is_zero, 1)
        }
        super().__init__("execute", inputs, outputs)


execute_cases = [
    ExecuteCase(
        AluSrc=(0b0),
        AluControl=("SLT"),
        PC_E=(0),
        signImm_E=(0),
        readData1_E=(0),
        readData2_E=(0)
    ),
    ExecuteCase(
        AluSrc=(0b0),
        AluControl=("SLT"),
        PC_E=(4),
        signImm_E=(4),
        readData1_E=(0),
        readData2_E=(0)
    ),
    ExecuteCase(
        AluSrc=(0b0),
        AluControl=("ADD"),
        PC_E=(0),
        signImm_E=(6),
        readData1_E=(7),
        readData2_E=(8)
    ),
    ExecuteCase(
        AluSrc=(0b1),
        AluControl=("ADD"),
        PC_E=(0),
        signImm_E=(6),
        readData1_E=(7),
        readData2_E=(8)
    )]

# execute_tv.bin
for case in execute_cases:
    print(case)

print("\n INFO TO PASTE IN *_tb.sv:")
print('`define TESTVECTOR_SIZE', len(execute_cases))
print(execute_cases[0].macros_in_sv())
