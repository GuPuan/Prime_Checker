# Prime Checker Project

This project implements two different methods for checking whether a number is prime. Each implementation is housed in separate modules, each with its own approach to determining the primality of an input number.

## Project Structure

- **Prime_Checker_mod1**: Contains the first implementation using the MOD operation.
- **Prime_Checker_custom_mod2**: Contains the second implementation using a custom subtraction method to simulate the MOD function.

## 1. Implementation Details

### 1.1 Implementation 1: Using Mod Functions

The first implementation checks the primality of a number using the MOD operation. Here are the key steps:

- If the input number is `0` or `1`, it is immediately determined to be non-prime.
- For other numbers, a set of fixed divisors (2, 3, 5, and 7) is used to test divisibility.
- The MOD operation (`input_number mod divisor`) checks if the number is divisible by any of these divisors.
- If the result of the MOD operation is 0 for any divisor, the number is non-prime.
- If none of the divisors produce a remainder of 0, the number is determined to be prime.

For more details, refer to the code in the **Prime_Checker_mod1** directory.

### 1.2 Implementation 2: Custom Mod Functions

In the second implementation, the built-in MOD operation is replaced by a custom algorithm using subtraction to simulate modulus:

- The input number (`input_temp`) is first checked for special cases, such as `2`, `3`, `5`, and `7` (prime numbers) or `0` and `1` (non-prime numbers).
- If no special case is found, the algorithm enters a loop where `input_temp` is continuously subtracted by the current divisor (starting from 2).
- If `input_temp` becomes zero, it indicates divisibility, and the number is determined to be non-prime.
- If the divisor exceeds `input_temp` without finding a zero remainder, the next divisor is checked (again, from the set: 2, 3, 5, and 7).
- The process continues until a result is reached.

For more details, refer to the code in the **Prime_Checker_custom_mod2** directory.
