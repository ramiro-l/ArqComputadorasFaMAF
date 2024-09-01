from .module import Module
from .case import Case


class TestModule:
    def __init__(self, module: Module):
        self.module = module
        self.cases: list[Case] = []

    def add_case(self, inputs_gates_values: dict[str, int]):
        if inputs_gates_values.keys() != self.module.inputs_gates_bits.keys():
            raise ValueError("Invalid inputs in add case")

        inputs_gates: dict[str, int, int] = {}
        for key, value in inputs_gates_values.items():
            inputs_gates.update(
                {key: (value, self.module.inputs_gates_bits[key])})

        outputs_gates: dict[str, int, int] = {}
        outputs_apply_logic = self.module.apply_logic(inputs_gates_values)
        if outputs_apply_logic.keys() != self.module.outputs_gates_bits.keys():
            raise ValueError("Invalid outputs in add case")

        for key, value in outputs_apply_logic.items():
            outputs_gates.update(
                {key: (value, self.module.outputs_gates_bits[key])})
        self.cases.append(Case(inputs_gates, outputs_gates))

    def generate_test_vectors(self, type: str = "bin"):
        res = []
        for case in self.cases:
            if type == "hex":
                res.append(case.to_hex())
            else:
                res.append(str(case))
        return res

    def get_test_size_systemverilog(self):
        return f"`define TESTVECTOR_SIZE {len(self.cases)}"

    def get_input_long_systemverilog(self):
        length_bits_inputs = sum(
            bits for bits in self.module.inputs_gates_bits.values())
        return f"`define TESTVECTOR_INPUT_LONG {length_bits_inputs}"

    def get_output_long_systemverilog(self):
        length_bits_outputs = sum(
            bits for bits in self.module.outputs_gates_bits.values())
        return f"`define TESTVECTOR_OUTPUT_LONG {length_bits_outputs}"

    def export_bin_file(self, file_path: str, type: str = "bin"):
        file_name = self.module.name_file()
        output_path = file_path + file_name
        with open(output_path, "w") as file:
            for case in self.generate_test_vectors(type):
                file.write(case + "\n")
        print(f"File {output_path} exported successfully.")

    def print_systemverilog_info(self):
        print("\nSystemVerilog file info:")
        print(self.get_test_size_systemverilog())
        print(self.get_input_long_systemverilog())
        print(self.get_output_long_systemverilog())
        print("\n")
