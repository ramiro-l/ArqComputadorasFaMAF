# Porceso para crear un nuevo test con la libreria:

1. Definir primero cuales van a ser las puertas de entrada y salida con la cantidad de bits que se necesiten.
   ```python
   input_gates_bits = {"input": 4}
   output_gates_bits = {"output": 8}
   ```
2. Crear el modulo que se va a testear. Para ello debemos heredad de la clase Module y sobreescribir el metodo apply_logic.
   ```python
   class ExampleModule(Module):
       def apply_logic(self, inputs_gates_values: dict[str, int]) -> dict[str, int]:
           input = inputs_gates_values.get("input")
           return {"output": input * 2}
   ```
   > Es importatne respetar el nombre de las puertas de entrada y salida.
3. Instanciar el modulo creado.
   ```python
    example = ExampleModule("example", {"input": 4}, {"output": 8})
   ```
4. Crear el modulo de testeo y agregar los casos de prueba.
   ```python
    test_module = TestModule(example)
    test_module.add_case({"input": 1})
    test_module.add_case({"input": 2})
    test_module.add_case({"input": 3})
   ```
   > Notar que ahora les estamos pasando **los valores de las puertas de entrada** unicamente.
5. Generar los casos de prueba en binario o hexadecimal.
   ```python
    cases_in_binary = test_module.generate_test_vectors()
    cases_in_hexa = test_module.generate_test_vectors("hex")
   ```
6. Imprimir los casos de prueba.

   ```python
    print("\nBinary test cases:")
    print(cases_in_binary)

    print("\nHexadecimal test cases:")
    print(cases_in_hexa)
   ```

7. Generar el archivo .bin

   ```python
    print("\nFile name: '", execute.name_file(), "'")
    test_module.export_bin_file("./Practico1/test-bench/", "bin")

   ```

8. Imprimir la informacion del archivo SystemVerilog.
   ```python
    print("\nSystemVerilog file info:")
    print(
        test_module.get_test_size_systemverilog())
    print(
        test_module.get_input_long_systemverilog())
    print(
        test_module.get_output_long_systemverilog())
   ```

## Ejemplo completo:

```python
from lib.module import Module
from lib.test_module import TestModule

input_gates_bits = {"input": 4}
output_gates_bits = {"output": 8}

class ExampleModule(Module):
    def apply_logic(self, inputs_gates_values: dict[str, int]) -> dict[str, int]:
        input = inputs_gates_values.get("input")
        return {"output": input * 2}


example = ExampleModule("example", input_gates_bits, output_gates_bits)

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
test_module.export_bin_file("./", "bin")

print("\nSystemVerilog file info:")
print(
    test_module.get_test_size_systemverilog())
print(
    test_module.get_input_long_systemverilog())
print(
    test_module.get_output_long_systemverilog())

```
