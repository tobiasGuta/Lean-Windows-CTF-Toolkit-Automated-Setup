# Lean Windows CTF Toolkit - Automated Setup

This repository contains a PowerShell script that automatically downloads and sets up essential reverse engineering tools for CTF competitions on Windows.

## Tools Included

- Ghidra — Industry-standard disassembler and static analysis tool
- x64dbg — Powerful Windows debugger with GUI
- Detect It Easy (DIE) — File type and packer detection
- dnSpyEx — .NET decompiler and debugger
- HxD — Lightweight hex editor
- ImHex — Modern hex editor with advanced features

## Prerequisites

- Windows 10/11 (Windows Server also works)
- Administrator privileges (required to create `C:\Tools`)
- Internet connection (to download tools)
- Java 17+ (required for Ghidra only — see installation section below)

# Quick Start

## Method 1: Run Directly (Recommended)

1. Right-click the Start menu and select **"Windows Terminal (Admin)"** or **"PowerShell (Admin)"**

2. Enable script execution (one-time setup):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

3. Download and run the script:

```powershell
# Download the script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/tobiasGuta/Lean-Windows-CTF-Toolkit-Automated-Setup/main/Setup-CTFToolkit.ps1" -OutFile "$env:TEMP\Setup-CTFToolkit.ps1"

# Run it
& "$env:TEMP\Setup-CTFToolkit.ps1"
```

## Method 2: Clone Repository

```powershell
# Clone this repository
git clone https://github.com/tobiasGuta/Lean-Windows-CTF-Toolkit-Automated-Setup.git
cd Lean-Windows-CTF-Toolkit-Automated-Setup

# Run the setup script as Administrator
.\Setup-CTFToolkit.ps1
```

## What the Script Does

- Creates `C:\Tools` directory structure
- Downloads latest versions of all tools
- Extracts portable versions (no installers)
- Verifies Java installation for Ghidra
- Provides clear launch instructions
- Offers to add tools to system PATH
- Cleans up temporary files

# Installing Java (for Ghidra)

Ghidra requires Java 17 or higher. If you don't have it:

## Quick Install

```powershell
# Using winget (Windows 11/modern Windows 10)
winget install EclipseAdoptium.Temurin.17.JDK

# Or download manually from:
# https://adoptium.net/temurin/releases/?version=17
```

## Verify Installation

```powershell
java -version
```

You should see something like:

```text
openjdk version "17.0.x" 2023-xx-xx
```

## Tool Locations

After installation, all tools will be in:

```text
C:\Tools\
├── Ghidra\
├── x64dbg\
├── DetectItEasy\
├── dnSpyEx\
├── HxD\
└── ImHex\
```

# Usage Guide

## 1. Analyzing an Unknown File

### Step 1: Run Detect It Easy

Path:

```text
C:\Tools\DetectItEasy\die.exe
```

Actions:

- Drag and drop the challenge file
- Check if it's packed/obfuscated
- Note the compiler and architecture

### Step 2: Choose the Right Tool

- If it says `.NET` → Use dnSpyEx
- If it's packed → Use x64dbg to unpack first
- If it's native C/C++ → Use Ghidra

## 2. Static Analysis with Ghidra

```text
1. Launch: C:\Tools\Ghidra\ghidra_*\ghidraRun.bat
2. Create new project
3. Import your challenge file
4. Analyze with default settings
5. Find main() function
6. Read the decompiled C code
```

## 3. Dynamic Debugging with x64dbg

```text
1. Launch: C:\Tools\x64dbg\release\x96dbg.exe
2. File → Open → Select challenge.exe
3. Find the password check function (Ctrl+G to go to address)
4. Set breakpoint (F2)
5. Run (F9)
6. Step through (F7/F8) and watch registers
```

## 4. .NET Decompilation with dnSpyEx

```text
1. Launch: C:\Tools\dnSpyEx\dnSpy.exe
2. File → Open → Select challenge.exe
3. Expand namespaces in tree view
4. Find Main() or suspicious functions
5. Read the C# source code (nearly perfect decompilation)
```

## 5. Hex Editing

### HxD (Simple and Fast)

```text
1. Launch: C:\Tools\HxD\HxD.exe
2. File → Open
3. Edit bytes directly
4. Save
```

### ImHex (Advanced Features)

```text
1. Launch: C:\Tools\ImHex\imhex.exe
2. More features: patterns, data visualization, binary diffing
```

# Troubleshooting

## "Script execution is disabled"

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## "Download failed" / "URL not found"

The download URLs are current as of the script creation date, but may change.

To update them manually:

1. Open `Setup-CTFToolkit.ps1` in a text editor
2. Find the tool's URL section (example: `$ghidraUrl`)
3. Visit the tool's GitHub releases page
4. Copy the new download URL
5. Replace the old URL in the script

## "Ghidra won't start" / "Java not found"

Install Java 17+:

```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

Then restart your terminal and try launching Ghidra again.

## "Access denied" / "Cannot create directory"

Make sure you're running PowerShell as Administrator:

- Right-click Start
- Select **"Windows Terminal (Admin)"**

## "7z extraction failed"

For `.7z` files, the script needs 7-Zip installed:

```powershell
winget install 7zip.7zip
```

Or download from:

```text
https://www.7-zip.org/
```

# Updating Tools

To update tools later:

1. Delete the old tool folder (example: `C:\Tools\Ghidra`)
2. Update the URL in the script to the latest version
3. Run the script again

# VM Snapshot Recommendation

After installation:

1. Take a VM snapshot immediately
2. Name it `"Clean CTF Toolkit"`
3. Revert to this snapshot if something breaks

# Additional Resources

- Ghidra Documentation: https://ghidra-sre.org/
- x64dbg Documentation: https://help.x64dbg.com/
- dnSpyEx Wiki: https://github.com/dnSpyEx/dnSpy/wiki
- CTF Guide: https://ctf101.org/

# Security Notes

- These are reverse engineering tools, not malware
- Windows Defender may flag them as suspicious (false positives)
- You may need to add exclusions for `C:\Tools`
- Only use on VMs for CTF challenges
- Never analyze untrusted malware without proper isolation

# Contributing

If you find broken download URLs or want to add more tools:

1. Fork this repository
2. Update the script
3. Test on a fresh Windows VM
4. Submit a pull request

# License

This script is provided as-is for educational purposes.

Each tool has its own license:

- Ghidra — Apache License 2.0
- x64dbg — GPL v3
- Detect It Easy — MIT License
- dnSpyEx — GPL v3
- HxD — Freeware
- ImHex — GPL v2

# Disclaimer

This toolkit is intended for educational purposes and legitimate CTF competitions only.

Reverse engineering software you don't own or have permission to analyze may be illegal in your jurisdiction.

---

Happy hacking!
If you found this useful, consider starring the repository!
