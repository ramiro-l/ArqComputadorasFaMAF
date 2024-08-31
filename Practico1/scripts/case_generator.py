class Case:
    def __init__(self, name: str, inputs: dict, outputs: dict):
        self.name = name
        self.inputs = {port: value for port, value in inputs.items()}
        self.outputs = {port: value for port, value in outputs.items()}

    def format_binary(self, value, bits):
        return f"{value:0{bits}b}"

    def __str__(self):
        inputs_str = "_".join(self.format_binary(value, bits)
                              for value, bits in self.inputs.values())
        outputs_str = "_".join(self.format_binary(value, bits)
                               for value, bits in self.outputs.values())
        return f"{inputs_str}______{outputs_str}"

    def to_hex(self):
        inputs_str = "".join(self.format_binary(value, bits)
                             for value, bits in self.inputs.values())
        outputs_str = "".join(self.format_binary(value, bits)
                              for value, bits in self.outputs.values())
        return f"{binary_to_hex(inputs_str + outputs_str)}"

    def macros_in_sv(self):
        length_bits_inputs = sum(bits for _, bits in self.inputs.values())
        length_bits_outputs = sum(bits for _, bits in self.outputs.values())
        return f"`define TESTVECTOR_INPUT_LONG {length_bits_inputs}\n`define TESTVECTOR_OUTPUT_LONG {length_bits_outputs}\n"


def binary_to_hex(bin_str):
    # Diccionario de conversión de binario a hexadecimal
    hex_dict = {
        '0000': '0', '0001': '1', '0010': '2', '0011': '3',
        '0100': '4', '0101': '5', '0110': '6', '0111': '7',
        '1000': '8', '1001': '9', '1010': 'A', '1011': 'B',
        '1100': 'C', '1101': 'D', '1110': 'E', '1111': 'F'
    }

    # Divide la cadena binaria en bloques de 4 bits
    hex_str = ''
    for i in range(0, len(bin_str), 4):
        bin_block = bin_str[i:i+4]
        if bin_block.__len__() < 4:
            bin_block = '0'*(4-bin_block.__len__()) + bin_block
        hex_str += hex_dict[bin_block]

    return hex_str
