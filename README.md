asm-cleaner
===========

Simple NASM + ld sample project for educational use.

Overview
--------
- Purpose: Find and optionally delete macOS metadata files
  `.DS_Store` and `.AppleDouble` in the current directory.
- As a teaching sample, it demonstrates Linux x86-64 syscalls,
  minimal argument parsing, a simple prompt, and file ops
  (`access`, `unlink`).

Usage (after build)
-------------------
- Run: `./build/asm-cleaner [--yes] [--dry-run]`
  - `--dry-run`: list found files without deleting
  - `--yes`: delete without confirmation
  - With neither, it asks for `y` to confirm per file

Build
-----
- Requirements:
  - `nasm` (Netwide Assembler)
  - `ld` from binutils

- Build:
  - `make`

If tools are missing, the Makefile prints a clear error.

Install NASM
------------
- Debian/Ubuntu: `sudo apt-get install nasm`
- Arch Linux: `sudo pacman -S nasm`
- Fedora: `sudo dnf install nasm`
- macOS (Homebrew): `brew install nasm`

Notes
-----
- No extra processing is added; this is a minimal teaching example.
- The program links directly with `ld` (no libc), using Linux syscalls.
