import random

CANT_BITS = 64
MIN_NUMBER = 1000
MAX_NUMBER = 4999

if 2**CANT_BITS < MAX_NUMBER or 2**CANT_BITS < MIN_NUMBER:
    raise ValueError('Revisar CANT_BITS y MAX_NUMBER.')


ALU_OPERATIONS = [
    ('AND', '0000', lambda a, b: a & b),
    ('OR', '0001', lambda a, b: a | b),
    ('ADD', '0010', lambda a, b: (a + b)),
    ('SUB', '0110', lambda a, b: (a - b)),
    ('SLT', '0111', lambda _, b: b),
]
CASES = [
    ('+', '+'),
    ('-', '-'),
    ('+', '-'),
    ('-', '+'),
]


def all_cases():
    for op_name, op_code, op_fun in ALU_OPERATIONS:
        for sign_a, sign_b in CASES:
            (a, b) = numbers_of_case(sign_a, sign_b)
            result = op_fun(a, b)
            zero = "1'b1" if result == 0 else "1'b0"
            yield (
                f"4'b{op_code}",
                number_syvl(a),
                number_syvl(b),
                number_syvl(result),
                zero,
                op_name,
                sign_a + sign_b,
            )
        # Case when result is zero
        (a, b) = random_numbers_to_apply_operation_return_zero(op_name, op_fun)
        if op_fun(a, b) != 0:
            raise ValueError('Error en la generación de casos.')
        yield (
            f"4'b{op_code}",
            number_syvl(a),
            number_syvl(b),
            f" {CANT_BITS}'d0",
            "1'b1",
            op_name,
            "zero\n",
        )


def number_syvl(number):
    sign = ' ' if number >= 0 else '-'
    return f"{sign}{CANT_BITS}'d{abs(number)}"


def numbers_of_case(sign_a, sign_b):
    a = random_number_positive() if sign_a == '+' else random_number_negative()
    b = random_number_positive() if sign_b == '+' else random_number_negative()
    return (a, b)


def random_numbers_to_apply_operation_return_zero(op_name, op_fun):
    if op_name == 'SLT':
        return (random_number_positive(), 0)
    elif op_name == 'OR' or op_name == 'ADD':
        return (0, 0)
    else:
        while True:
            a = random_number_positive()
            b = random_number_positive()
            result = op_fun(a, b)
            if result == 0:
                return (a, b)


def random_number_positive():
    return random.randint(MIN_NUMBER, MAX_NUMBER)


def random_number_negative():
    return random.randint(-MAX_NUMBER, -MIN_NUMBER)


def format_cases(cases):
    formatted_cases = []
    for case in cases:
        formatted_case = '  {{ {:<8}, {:<10}, {:<10}, {:<10}, {:<5} }},  // {:<3} {:<2}'.format(
            *case)
        formatted_cases.append(formatted_case)
    return formatted_cases


header = '//  {:<8}   {:<10}  {:<10}  {:<10} {:<5}        {:<3} {:<2}'.format(
    'op_code', 'a', 'b', 'result', 'zero', 'op', 'sign')

cases = all_cases()
formatted_cases = format_cases(cases)

print("{")
print(header)
for case in formatted_cases:
    print(case)
print("}")
