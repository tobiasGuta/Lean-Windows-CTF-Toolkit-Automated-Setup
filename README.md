# Lean Windows CTF Toolkit - Automated Setup

A lean, zero-touch Windows CTF and reverse engineering toolkit bootstrapper.

This repository provides a PowerShell script that automatically installs and configures the essential tools needed for:

- Reverse engineering
- Malware analysis
- Binary exploitation
- PCAP/network analysis
- Windows exploit development
- General CTF workflows

The goal of this project is to stay lightweight and practical — only installing tools that are genuinely useful in most CTF and reversing environments.

---

# Features

- Fully automated setup
- Minimal and fast
- Portable tooling where possible
- Silent installs
- Automatic dependency handling
- Administrator-safe execution
- Clean directory structure
- Designed for Windows VMs

---

# Tools Installed

## Reverse Engineering

- Ghidra — Static analysis and decompilation
- x64dbg — Windows debugger
- Detect It Easy (DIE) — File identification and packer detection
- dnSpyEx — .NET decompiler and debugger

## Binary Analysis / Hex Editing

- HxD — Lightweight hex editor
- ImHex — Advanced binary analysis hex editor

## Networking

- Wireshark — Packet capture and PCAP analysis

## Development Environment

- Python 3.12
- Python 2.7
- Visual Studio Code
- Java 17 (required for Ghidra)

---

# Installation

## Method 1 — Direct Install (Recommended)

Open PowerShell as Administrator:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tobiasGuta/Lean-Windows-CTF-Toolkit-Automated-Setup/main/setupRE.ps1" -OutFile "$env:TEMP\setupRE.ps1"

& "$env:TEMP\setupRE.ps1"
```

---

## Method 2 — Clone Repository

```powershell
git clone https://github.com/tobiasGuta/Lean-Windows-CTF-Toolkit-Automated-Setup.git

cd Lean-Windows-CTF-Toolkit-Automated-Setup

.\setupRE.ps1
```

---

# What the Script Does

The script automatically:

- Creates the `C:\Tools` workspace
- Downloads the latest tool releases
- Extracts portable archives
- Installs required dependencies
- Installs tools silently using Winget when appropriate
- Cleans temporary files
- Skips already installed tools
- Verifies Java installation for Ghidra

---

# Installation Paths

Most portable tools are installed to:

```text
C:\Tools\
├── Ghidra\
├── x64dbg\
├── DetectItEasy\
├── dnSpyEx\
├── HxD\
└── ImHex\
```

Winget-installed applications:

- Visual Studio Code
- Wireshark
- Python 3.12
- Java 17

---

# Included Tool Usage

## Detect It Easy (DIE)

Use DIE first on unknown binaries:

```text
C:\Tools\DetectItEasy\die.exe
```

Useful for:

- Detecting packers
- Identifying compilers
- Finding architectures
- Quick malware triage

---

## Ghidra

Launch:

```text
C:\Tools\Ghidra\ghidra_*\ghidraRun.bat
```

Typical workflow:

1. Create project
2. Import binary
3. Run auto-analysis
4. Locate entry point
5. Review decompiled code

---

## x64dbg

Launch:

```text
C:\Tools\x64dbg\release\x96dbg.exe
```

Useful for:

- Dynamic analysis
- Bypass challenges
- Crackmes
- Malware debugging

---

## dnSpyEx

Launch:

```text
C:\Tools\dnSpyEx\dnSpy.exe
```

Perfect for:

- .NET malware
- C# crackmes
- Managed executable analysis

---

## Wireshark

Useful for:

- PCAP challenges
- Traffic inspection
- Malware network analysis
- Protocol reversing

---

# Troubleshooting

## Script Execution Disabled

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Winget Problems

Make sure:

- Windows App Installer is installed
- Winget works normally
- Internet connection is available

Test:

```powershell
winget --version
```

---

## Ghidra Does Not Launch

Verify Java:

```powershell
java -version
```

Install Java manually if needed:

```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

---

## Download Failures

Some vendor/CDN URLs may occasionally change.

If a tool fails to download:

1. Open `setupRE.ps1`
2. Locate the tool URL
3. Replace it with the newest release URL

---

# VM Recommendation

This toolkit is best used inside a Windows VM.

Recommended:

- VMware
- VirtualBox
- Hyper-V

After installation:

1. Take a clean snapshot
2. Name it something like:
   `Windows-CTF-Clean`
3. Revert whenever needed

---

# Security Notes

- These are legitimate reverse engineering tools
- Some AV products may flag them
- Windows Defender exclusions may be required
- Only analyze suspicious binaries inside isolated VMs
- Never test malware on your host system

---

# Philosophy

This project intentionally avoids bloating the VM with unnecessary tooling.

The focus is:

- Lean setup
- Fast deployment
- Essential tooling only
- Practical real-world reversing workflow

---

# Contributing

Pull requests are welcome for:

- Broken download URLs
- Better silent install methods
- Stability improvements
- Essential tooling additions

Please keep the project lean.

---

# Disclaimer

This toolkit is intended for:

- CTF competitions
- Malware analysis labs
- Educational reverse engineering
- Authorized security research

You are responsible for complying with local laws and regulations.

---

Happy hacking.
