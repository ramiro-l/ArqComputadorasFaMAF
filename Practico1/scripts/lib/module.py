class Module:
    def __init__(self, name: str, inputs_gates_bits: dict[str, int], outputs_gates_bits: dict[str, int]):
        self.name = name
        self.inputs_gates_bits: dict[str, int] = inputs_gates_bits
        self.outputs_gates_bits: dict[str, int] = outputs_gates_bits

    def __call__(self, inputs_gates_values: dict[str, int]) -> dict[str, int]:
        if inputs_gates_values.keys() != self.inputs_gates_bits.keys():
            raise ValueError("Invalid inputs in case to apply logic")
        return self.apply_logic(inputs_gates_values)

    def apply_logic(self, inputs_gates_values: dict[str, int]) -> dict[str, int]:
        raise NotImplementedError(
            "The 'apply_logic' method must be implemented in a subclass.")

    def name_file(self):
        return f"{self.name}_tv.bin"

    def __str__(self):
        return f"Module: {self.name}\nInputsGates: {self.inputs_gates_bits}\nOutputsGates: {self.outputs_gates_bits}"
