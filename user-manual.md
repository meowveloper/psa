# User Manual: Password Strength Auditor (PSA)

Welcome! This guide will help you run the Password Strength Auditor tool on your computer.

**What is this tool?**
This is a "Command Line" tool. It doesn't have a graphical window with buttons. instead, you type text commands to tell it what to do. This allows it to be extremely fast and powerful.

---

## 1. Which file should I download?

Go to the `releases` folder and download the file that matches your computer:

### 🖥️ For Windows
*   **Most Computers:** Download `psa_x86_64-windows.exe`
*   **Surface Pro X / ARM Laptops:** Download `psa_aarch64-windows.exe`

### 🍎 For macOS
*   **New Macs (M1, M2, M3 chips):** Download `psa_aarch64-macos`
*   **Older Macs (Intel chips):** Download `psa_x86_64-macos`

### 🐧 For Linux
*   **Standard PC/Laptop:** Download `psa_x86_64-linux-musl`
*   **Raspberry Pi / ARM:** Download `psa_aarch64-linux-musl`

---

## 2. How to Run on Windows

1.  **Download:** Move the downloaded file (e.g., `psa_x86_64-windows.exe`) to your **Downloads** folder.
2.  **Open Command Prompt:**
    *   Press the **Windows Key** on your keyboard.
    *   Type `cmd` and press **Enter**.
3.  **Go to Downloads:**
    Type this command and press **Enter**:
    ```cmd
    cd Downloads
    ```
4.  **Run the Tool:**
    Type the command below (replace the name if you downloaded the ARM version):
    ```cmd
    psa_x86_64-windows.exe -m=audit
    ```
    *If you see a menu appear, you did it!*

---

## 3. How to Run on macOS

1.  **Download:** Move the file (e.g., `psa_aarch64-macos`) to your **Downloads** folder.
2.  **Open Terminal:**
    *   Press **Command + Space**.
    *   Type `Terminal` and press **Enter**.
3.  **Go to Downloads:**
    Type this command and press **Enter**:
    ```bash
    cd ~/Downloads
    ```
4.  **Allow Execution:**
    Macs protect you from new programs. You need to tell it this one is safe to run.
    Type this and press **Enter**:
    ```bash
    chmod +x psa_aarch64-macos
    ```
    *(Note: If you downloaded the Intel version, type `chmod +x psa_x86_64-macos` instead)*
5.  **Run the Tool:**
    Type this command and press **Enter**:
    ```bash
    ./psa_aarch64-macos -m=audit
    ```
    *(Note: If you get a "Malicious Software" or "Unverified Developer" popup, go to **System Settings > Privacy & Security** and click **"Allow Anyway"** for the file. Then run the command again.)*

---

## 4. How to Use the Modes

The tool uses "flags" to know what mode to run. Here are the three main ways to use it.

### Mode A: Audit (Best for beginners)
This mode lets you check many passwords at once interactively.
*   **Command:** `psa_x86_64-windows.exe -m=audit`
*   **What it does:** It will ask you for a file containing hashes and test them all.

### Mode B: Brute Force (Guessing)
This tries to guess a single password by checking every combination.
*   **Command:**
    ```cmd
    psa_x86_64-windows.exe -m=brute -h=5f4dcc3b5aa765d61d8327deb882cf99
    ```
    *(Replace `5f4...` with the actual hash you want to crack)*
*   **Note:** You **must** provide the `-h=` flag followed by the MD5 hash.

### Mode C: Dictionary Attack (Word List)
This checks a list of words to see if the password is in there.
*   **Command:**
    ```cmd
    psa_x86_64-windows.exe -m=dict -h=5f4dcc3b5aa765d61d8327deb882cf99 -w=rockyou.txt
    ```
*   **Requirements:**
    *   `-h=...` : The MD5 hash you want to crack.
    *   `-w=...` : The file name of your wordlist (e.g., `rockyou.txt`). **Make sure this file is in the same folder!**

---

## Troubleshooting

*   **"The system cannot find the file specified":**
    *   Did you type `cd Downloads`?
    *   Is the file actually named `psa_x86_64-windows.exe`? Check your folder. If it's `psa_x86_64-windows (1).exe`, rename it or type the correct name.
*   **"Permission denied" (macOS/Linux):**
    *   Did you run the `chmod +x ...` command?
*   **"Missing argument":**
    *   Did you forget `-h=` or `-w=`? Check the examples above.