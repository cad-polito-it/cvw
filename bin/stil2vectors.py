#!/usr/bin/env python3
"""Convert TestMAX STIL patterns of the ALU adder into add_vectors.inc (Lab 6 prototype).

Usage: stil2vectors.py [--addsub] <patterns.stil> <output.inc> [max_patterns]
Each pattern sets A[31:0] and B[31:0] (A[32] and B[32] must be 0); it becomes one
pair (A, B) of the data-driven loop in add_test.S. X is written as 0.
With --addsub, CI may be 1: those patterns go to sub_vectors as (A, ~B), because
SUB drives the adder with ~rs2 and carry-in 1 (addsub_test.S).
"""
import re
import sys

args = sys.argv[1:]
addsub = args[:1] == ["--addsub"]
if addsub:
    args = args[1:]
stil, output = args[0], args[1]
text = open(stil).read()
limit = int(args[2]) if len(args) > 2 else None

group = re.search(r'"_pi"\s*=\s*\'([^\']*)\'', text).group(1)
signals = re.findall(r'"([^"]+)"', group)


def expand(value):
    """Expand STIL repeat tokens (\\rN chars) and drop whitespace."""
    out = []
    tokens = re.findall(r'\\r(\d+)\s+(\S+)|(\S)', value)
    for count, chars, single in tokens:
        out.append(chars * int(count) if count else single)
    return "".join(out)


patterns = []
for match in re.finditer(r'"pattern (\d+)"\s*:\s*Call\s+"capture"\s*\{(.*?)\}', text, re.S):
    pi = re.search(r'"_pi"\s*=\s*([^;]*);', match.group(2))
    if pi:
        patterns.append(expand(pi.group(1)))
if limit:
    patterns = patterns[:limit]


def word(bits, name):
    value = 0
    for i in range(32):
        if bits.get(f"{name}[{i}]") == "1":
            value |= 1 << i
    return value


pairs, subs = [], []
for p in patterns:
    if len(p) != len(signals):
        sys.exit(f"pattern length {len(p)} != {len(signals)} signals")
    bits = dict(zip(signals, p))
    fixed = ("A[32]", "B[32]") if addsub else ("A[32]", "B[32]", "CI")
    for name in fixed:
        if bits.get(name) == "1":
            sys.exit(f"{name} = 1: not applicable with an ADD instruction")
    if bits.get("CI") == "1":
        subs.append((word(bits, "A"), ~word(bits, "B") & 0xFFFFFFFF))
    else:
        pairs.append((word(bits, "A"), word(bits, "B")))

def table(f, name, rows):
    f.write(f".globl {name}, {name}_end\n{name}:\n")
    for a, b in rows:
        f.write(f"    .word 0x{a:08x}, 0x{b:08x}\n")
    f.write(f"{name}_end:\n")


with open(output, "w") as f:
    src = stil.split('/')[-1]
    f.write(f"/* {len(pairs)} ADD pairs" + (f" and {len(subs)} SUB pairs" if addsub else "") +
            f" from the TestMAX patterns in {src}. */\n")
    f.write(".equ OBSERVE, 1   /* 1: store each result; signature 0: XOR, 3: rotate+XOR, 4: sum; 2: no store */\n\n")
    f.write('.section .TEST_RODATA, "a"\n.balign 4\n')
    table(f, "add_vectors", pairs)
    if addsub:
        table(f, "sub_vectors", subs)
print(f"{output}: {len(pairs)} ADD pairs" + (f", {len(subs)} SUB pairs" if addsub else "") +
      f" from {len(signals)} PIs")
