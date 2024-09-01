# Example for use of the library

```python
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
    'AND': lambda a, b: a & b,
    'OR': lambda a, b: a | b,
    'ADD': lambda a, b: a + b,
    'SUB': lambda a, b: a - b,
    'SLT': lambda a, b: b,
}


class ExampleModule(Module):
    def apply_logic(self, inputs_gates_values: dict[str, int]) -> dict[str, int]:
        input = inputs_gates_values.get("input")
        return {"output": input * 2}


example = ExampleModule("example", {"input": 4}, {"output": 8})

test_module = TestModule(example)
test_module.add_case({"input": 1})
test_module.add_case({"input": 2})
test_module.add_case({"input": 3})

cases_in_binary = test_module.generate_test_vectors()
cases_in_hexa = test_module.generate_test_vectors("hex")

print("\nBinary test cases:")
print(cases_in_binary)

print("\nHexadecimal test cases:")
print(cases_in_hexa)

print("\nFile name: '", execute.name_file(), "'")

print("\nSystemVerilog file info:")
print(
    test_module.get_test_size_systemverilog())
print(
    test_module.get_input_long_systemverilog())
print(
    test_module.get_output_long_systemverilog())

```
