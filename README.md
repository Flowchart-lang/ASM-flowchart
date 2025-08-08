# ASM-Flowchart (NASM x86\_64 Linux Edition)

**ASM-Flowchart** is a minimalistic, assembly-language implementation of the Flowchart-Lang (FCL) concept. This version runs on Linux using the NASM assembler for x86\_64 architecture. It interprets a small subset of the FCL language directly in low-level assembly.

---

## Getting Started

To run ASM-Flowchart programs, you'll need the NASM assembler and a Linux environment.

> **Note:** This is a Linux-only version, unlike the original Python FCL which was Windows-focused.

### 1. Prerequisites

* **NASM**: Install via your package manager:

```bash
sudo apt install nasm   # Debian/Ubuntu
sudo dnf install nasm   # Fedora
```

* **Linux x86\_64**: This code is 64-bit and uses Linux system calls.

---

### 2. Setup

Save the interpreter code as `asm_flowchart.asm`.

Assemble and link:

```bash
nasm -f elf64 asm_flowchart.asm -o asm_flowchart.o
ld asm_flowchart.o -o asm_flowchart
```

Run:

```bash
./asm_flowchart myprogram.fcl
```

---

## Supported FCL Commands

This first NASM version supports a reduced command set compared to Python FCL:

| Command | Description                        |
| ------- | ---------------------------------- |
| `START` | Marks program start (required).    |
| `END`   | Marks program end (required).      |
| `PRINT` | Displays a string to the terminal. |

> Planned features for later versions: `SET`, `INPUT`, `IF/ELSE`, `WHILE`, `INCREMENT`.

---

## FCL Program Format

Programs are plain text `.fcl` files.

Example:

```fcl
START
PRINT "Hello from NASM!"
END
```

---

## How It Works

1. The NASM interpreter reads the `.fcl` file line-by-line.
2. It compares each line to known commands.
3. `PRINT` lines output text directly.
4. Execution stops when `END` is reached.

---

## Running an Example

Example program `example.fcl`:

```fcl
START
PRINT "ASM-Flowchart running in Linux!"
END
```

Steps:

```bash
nasm -f elf64 asm_flowchart.asm -o asm_flowchart.o
ld asm_flowchart.o -o asm_flowchart
./asm_flowchart example.fcl
```

Output:

```
ASM-Flowchart running in Linux!
```

---

## Extending the Interpreter

Since NASM lacks built-in high-level features, every new command requires explicit implementation using:

* File I/O syscalls (`open`, `read`, `close`)
* String parsing in memory
* Conditional jumps (`je`, `jne`)
* Loops using labels and jumps

Planned expansions:

* Variable storage using `.bss` segment
* Numeric parsing and arithmetic
* User input handling via `read` syscall
* Conditionals (`IF`, `ELSE`, `ENDIF`)
* Loops (`WHILE`, `ENDWHILE`)

---

## License

This project is free to use, modify, and learn from.

---

**Note:** This NASM version is intentionally minimal — it demonstrates how a high-level interpreter idea like FCL can be ported to a low-level assembly environment while keeping the core concept intact.
