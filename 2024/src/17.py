#!/usr/bin/env python3
import sys
import re


def combo(registers: list[int], value: int) -> int:
    return value if value < 4 else registers[value - 4]


def run(regs: list[int], inst: list[int]) -> list[int]:
    registers = regs[:]
    ip = 0
    outv = []

    while ip < len(inst):
        match inst[ip]:
            case 0:
                registers[0] //= 2 ** combo(registers, inst[ip + 1])
            case 1:
                registers[1] ^= inst[ip + 1]
            case 2:
                registers[1] = combo(registers, inst[ip + 1]) % 8
            case 3:
                if registers[0] == 0:
                    ip += 2
                    continue
                ip = inst[ip + 1]
                continue
            case 4:
                registers[1] ^= registers[2]
            case 5:
                outv.append(combo(registers, inst[ip + 1]) % 8)
            case 6:
                registers[1] = registers[0] // (2 ** combo(registers, inst[ip + 1]))
            case 7:
                registers[2] = registers[0] // (2 ** combo(registers, inst[ip + 1]))

        ip += 2
    return outv


def search(inst: list[int], i: int = 0, r0: int = 0) -> int | None:
    # Try 8 different possibilities for the current position
    for _ in range(8):
        # Run the program with current r0 value and check output
        result = run([r0, 0, 0], inst)
        # If output length matches instruction length and current position matches
        if i < len(result) and result[i] == inst[i]:
            # If we're at the last position, we found the answer
            if i == len(inst) - 1:
                return r0
            else:
                # Recursively search for later positions
                print(f"found {result} with {r0} for {inst}")
                return search(inst, i + 1, r0)
        r0 = r0 + (1 << 3 * (i + 1))
    return None


def main():
    parts = sys.stdin.read().strip().split("\n\n")
    regs = [int(re.findall(r"\d+", line)[0]) for line in parts[0].splitlines()]
    inst = [int(x) for x in parts[1].strip("Program: ").split(",")]

    r0_bits = search(inst)
    print(f"part_one: '{",".join(map(str, run(regs, inst)))}', part_two: '{r0_bits}'")


if __name__ == "__main__":
    main()
