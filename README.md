# ✨ Shape Generator — NASM x86 Assembly

<p align="center">
  <b>Turn low-level Assembly instructions into ASCII art.</b><br>
  A console-based shape generator built with NASM and 32-bit x86 Assembly.
</p>

<p align="center">
  <img alt="Language" src="https://img.shields.io/badge/Language-x86%20Assembly-00599C?style=for-the-badge">
  <img alt="Assembler" src="https://img.shields.io/badge/Assembler-NASM-orange?style=for-the-badge">
  <img alt="Architecture" src="https://img.shields.io/badge/Architecture-32--bit%20x86-purple?style=for-the-badge">
  <img alt="Platform" src="https://img.shields.io/badge/Platform-Linux-black?style=for-the-badge&logo=linux&logoColor=white">
</p>

---

## 🎨 About the Project

**Shape Generator** is a menu-driven Assembly Language program that creates ASCII-art shapes directly in the terminal. Users can choose a shape, select a **solid** or **hollow** style, and customize its dimensions.

Built as part of an Integrated Computer Systems assignment, this project explores how loops, comparisons, registers, memory, and Linux system calls can work together to produce visual patterns at a low level.

## 🌟 Features

- 🔵 **Circle** — generate a circle using a configurable radius.
- 🔺 **Triangle** — draw solid or hollow triangles.
- ❤️ **Heart** — create a heart pattern with a selected size.
- ⬛ **Square** — generate solid or hollow squares.
- ▭ **Rectangle** — customize length and breadth.
- 🧱 **Two drawing styles** — choose solid or hollow for supported shapes.
- 🛡️ **Input validation** — checks menu choices and shape dimensions.
- 🔁 **Interactive menu** — generate multiple shapes before exiting.

## 🧰 Tech Stack

| Technology | Role |
|---|---|
| NASM | Assembles the source code |
| 32-bit x86 Assembly | Implements the menu, calculations, loops, and drawing logic |
| Linux / Ubuntu | Runs the compiled program |
| WSL2 | Allows the program to run on Windows through Ubuntu |
| GNU `ld` | Links the 32-bit object file |
| Git & GitHub | Version control and project hosting |

## 🚀 Getting Started

### Prerequisites

- Windows with WSL2 and Ubuntu, or a compatible Linux environment.
- NASM assembler.
- GNU linker (`ld`) and supporting tools from `binutils`.

### 1. Install the tools

On Ubuntu or WSL2, run:

```bash
sudo apt update
sudo apt install nasm binutils
```

### 2. Clone this repository

```bash
git clone https://github.com/sana-syed123/YOUR-REPOSITORY.git
cd YOUR-REPOSITORY
```

> Replace `YOUR-REPOSITORY` with the actual name of this GitHub repository.

### 3. Assemble the program

If the source file is named `shape_generator.asm`, run:

```bash
nasm -f elf32 shape_generator.asm -o shape_generator.o
```

### 4. Link the executable

```bash
ld -m elf_i386 shape_generator.o -o shape_generator
```

### 5. Run it

```bash
./shape_generator
```

> **Note:** This source targets 32-bit Linux and uses the `int 0x80` system-call interface. The commands above assume the source file is in the current directory and that your environment supports running 32-bit executables.

## 🎮 How to Use

1. Launch the program.
2. Choose a shape from the main menu.
3. Select **Solid** or **Hollow** when prompted.
4. Enter the requested dimensions within the displayed range.
5. View the generated ASCII pattern.
6. Return to the menu to create another shape, or choose **Exit Program**.

### Shape menu

| Menu option | Shape |
|---:|---|
| `1` | Circle |
| `2` | Triangle |
| `3` | Heart |
| `4` | Square |
| `5` | Rectangle |
| `6` | Exit Program |

### Input ranges

| Shape / dimension | Accepted range |
|---|---:|
| Circle radius | 5–15 |
| Triangle size | 5–20 |
| Heart size | 5–15 |
| Square size | 5–25 |
| Rectangle length | 5–25 |
| Rectangle breadth | 5–25 |

## 🧠 Assembly Concepts Demonstrated

- **Registers:** temporary storage and arithmetic operations.
- **Loops:** nested row and column loops to draw patterns.
- **Comparisons and jumps:** `CMP`, `JE`, `JL`, `JG`, and related control-flow instructions.
- **Memory sections:** `.data`, `.bss`, and `.text`.
- **Input/output:** Linux `sys_read` and `sys_write` system calls.
- **Procedures:** reusable routines for printing, reading input, and drawing shapes.
- **ASCII-to-integer conversion:** processing user-entered dimensions.
- **Program termination:** Linux `sys_exit` via `int 0x80`.

## 📁 Project Structure

```text
.
├── shape_generator.asm   # NASM x86 Assembly source code
└── README.md             # Project documentation
```

Add any additional files or screenshots to this tree if your repository includes them.

## 🛣️ Future Improvements

- [ ] Improve numeric input parsing and reject malformed input more robustly.
- [ ] Refine shape symmetry and spacing across terminal sizes.
- [ ] Add more patterns, such as diamonds, stars, and polygons.
- [ ] Add automated test cases for input validation and shape generation.
- [ ] Improve terminal compatibility and screen-clearing behavior.

## 👩‍💻 Author

**Sana Syed**  
GitHub: [@sana-syed123](https://github.com/sana-syed123)

---

<p align="center">
  <i>Small instructions. Big patterns. Low-level creativity. ✨</i>
</p>
