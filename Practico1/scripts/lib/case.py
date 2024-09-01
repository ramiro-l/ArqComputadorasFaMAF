from .module import Module


class Case:
    def __init__(self, inputs_gates: dict[str, int], outputs_gates: dict[str, int]):
        self.inputs = inputs_gates
        self.outputs = outputs_gates

    def __str__(self):
        inputs_str = "_".join(format_binary(value, bits)
                              for _, (value, bits) in self.inputs.items())
        outputs_str = "_".join(format_binary(value, bits)
                               for _, (value, bits) in self.outputs.items())
        return f"{inputs_str}______{outputs_str}"

    def to_hex(self):
        inputs_str = "".join(format_binary(value, bits)
                             for _, (value, bits) in self.inputs.items())
        outputs_str = "".join(format_binary(value, bits)
                              for _, (value, bits) in self.outputs.items())
        return binary_to_hex(inputs_str + outputs_str)


def format_binary(value, bits):
    return f"{value:0{bits}b}"


def binary_to_hex(bin_str):
    # Dictionary for binary to hexadecimal conversion
    hex_dict = {
        '0000': '0', '0001': '1', '0010': '2', '0011': '3',
        '0100': '4', '0101': '5', '0110': '6', '0111': '7',
        '1000': '8', '1001': '9', '1010': 'A', '1011': 'B',
        '1100': 'C', '1101': 'D', '1110': 'E', '1111': 'F'
    }

    # Pad the binary string to a multiple of 4 bits
    bin_str = bin_str.zfill(len(bin_str) + (4 - len(bin_str) % 4) % 4)

    # Convert binary to hexadecimal
    hex_str = ''.join(hex_dict[bin_str[i:i+4]]
                      for i in range(0, len(bin_str), 4))

    return hex_str
