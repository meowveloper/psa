# Password Strength Auditor (PSA)

**PSA** is a high-performance, cross-platform command-line tool designed for auditing password strength. Written in **Zig**, it leverages manual memory management and zero-allocation optimization to deliver maximum speed.

## 🚀 Features

*   **Dictionary Attack:** High-speed wordlist checking with optimized file I/O.
*   **Brute-Force Attack:** Recursive character combination generation with interactive configuration.
*   **Audit Mode:** Batch processing of multiple hashes with automated security scoring and reporting.
*   **Cross-Platform:** Compiles natively for Linux, Windows, and macOS.
*   **Zero Dependencies:** Uses Zig's standard library for all cryptography (MD5) and I/O.

---

## 🛠️ Build Instructions

### Prerequisites
*   **Zig Compiler:** Version **0.15.2** (Strict Requirement)
    *   [Download Zig](https://ziglang.org/download/)
    *   Verify installation: `zig version`

### 1. Native Build (Linux)
To build the executable for your current machine:

```bash
zig build
```
*Output:* `zig-out/bin/psa`

### 2. Cross-Compilation (Windows)
To generate a Windows `.exe` file from Linux/macOS:

```bash
zig build -Dtarget=x86_64-windows
```
*Output:* `zig-out/bin/psa.exe`

### 3. Cross-Compilation (macOS)
**Apple Silicon (M1/M2/M3):**
```bash
zig build -Dtarget=aarch64-macos
```

**Intel Macs:**
```bash
zig build -Dtarget=x86_64-macos
```

---

## 📖 Usage Guide

The tool uses a mode-based interface (`-m`).

### 1. Dictionary Attack
Check a single hash against a wordlist file.

**Command:**
```bash
./psa -m=dict -h=<HASH> -w=<WORDLIST_PATH>
```

**Example:**
```bash
./psa -m=dict -h=5f4dcc3b5aa765d61d8327deb882cf99 -w=rockyou.txt
```

### 2. Brute-Force Attack
Attempt to crack a single hash by trying all character combinations. This mode is **interactive**; you will be prompted to select the character set and maximum length.

**Command:**
```bash
./psa -m=brute -h=<HASH>
```

**Example:**
```bash
./psa -m=brute -h=5f4dcc3b5aa765d61d8327deb882cf99
```

### 3. Audit Mode
Batch audit a list of hashes. The tool will generate a detailed security report including a vulnerability score and recommendations.

**Command:**
```bash
./psa -m=audit
```
*Follow the interactive prompts to provide the path to your hash list and wordlist.*

---

## ⚠️ Ethical Disclaimer
**This tool is for educational and authorized security auditing purposes only.**
Using this tool against systems or data you do not own or have explicit permission to test is illegal and unethical. The authors assume no liability for misuse of this software.
