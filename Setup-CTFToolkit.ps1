# ============================================================================
# Zero-Touch Windows CTF Toolkit Setup Script
# ============================================================================

#Requires -RunAsAdministrator
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ToolsPath = "C:\Tools"
$TempPath  = "$env:TEMP\CTFToolkit"

# ============================================================================
# Helper Functions
# ============================================================================

function Write-Step {
    Write-Host "`n[*] $($args[0])" -ForegroundColor Cyan
}

function Write-Success {
    Write-Host "[+] $($args[0])" -ForegroundColor Green
}

function Write-Warning {
    Write-Host "[!] $($args[0])" -ForegroundColor Yellow
}

function Write-Error {
    Write-Host "[-] $($args[0])" -ForegroundColor Red
}

function Download-File {
    param(
        [string]$Url,
        [string]$OutputPath,
        [string]$ToolName
    )

    try {
        Write-Step "Downloading $ToolName..."

        $ProgressPreference = 'SilentlyContinue'

        Invoke-WebRequest `
            -Uri $Url `
            -OutFile $OutputPath `
            -UseBasicParsing `
            -Headers @{
                "User-Agent" = "Mozilla/5.0"
            }

        $ProgressPreference = 'Continue'

        Write-Success "$ToolName downloaded"
        return $true
    }
    catch {
        Write-Error "Failed to download $ToolName : $_"
        return $false
    }
}

function Extract-Archive {
    param(
        [string]$ArchivePath,
        [string]$DestinationPath,
        [string]$ToolName
    )

    try {
        Write-Step "Extracting $ToolName..."

        if ($ArchivePath -like "*.zip") {

            Expand-Archive `
                -Path $ArchivePath `
                -DestinationPath $DestinationPath `
                -Force

        }
        elseif ($ArchivePath -like "*.7z") {

            if (Test-Path "C:\Program Files\7-Zip\7z.exe") {

                & "C:\Program Files\7-Zip\7z.exe" `
                    x "$ArchivePath" `
                    -o"$DestinationPath" `
                    -y | Out-Null

            }
            else {
                return $false
            }
        }

        Write-Success "$ToolName extracted"
        return $true
    }
    catch {
        Write-Error "Failed to extract $ToolName"
        return $false
    }
}

function Install-WingetPackage {

    param(
        [string]$PackageId,
        [string]$DisplayName
    )

    Write-Step "Checking for $DisplayName..."

    $check = Start-Process `
        -FilePath "winget" `
        -ArgumentList "list --id $PackageId --accept-source-agreements" `
        -Wait `
        -PassThru `
        -WindowStyle Hidden

    if ($check.ExitCode -eq 0) {
        Write-Warning "$DisplayName is already installed - skipping"
        return $true
    }

    Write-Host "  Running winget install in background..." -ForegroundColor DarkGray

    $process = Start-Process `
        -FilePath "winget" `
        -ArgumentList "install --id $PackageId --exact --source winget --accept-package-agreements --accept-source-agreements --silent" `
        -Wait `
        -PassThru `
        -WindowStyle Hidden

    if (
        $process.ExitCode -eq 0 `
        -or $process.ExitCode -eq -1978335189 `
        -or $process.ExitCode -eq -1978335212
    ) {

        Write-Success "$DisplayName successfully installed!"
        return $true

    }
    else {

        Write-Error "Winget failed to install $DisplayName (Exit code: $($process.ExitCode))."
        return $false

    }
}

# ============================================================================
# Main Setup Logic
# ============================================================================

Write-Host "`nStarting CTF Toolkit Setup..." -ForegroundColor Cyan

Write-Step "Preparing directory structure..."

if (!(Test-Path $ToolsPath)) {
    New-Item -ItemType Directory -Path $ToolsPath | Out-Null
}

if (!(Test-Path $TempPath)) {
    New-Item -ItemType Directory -Path $TempPath | Out-Null
}

# ============================================================================
# Core Dependencies
# ============================================================================

Install-WingetPackage `
    -PackageId "EclipseAdoptium.Temurin.17.JDK" `
    -DisplayName "Java 17 (for Ghidra)" | Out-Null

Install-WingetPackage `
    -PackageId "Python.Python.3.12" `
    -DisplayName "Python 3.12" | Out-Null

Install-WingetPackage `
    -PackageId "Microsoft.VisualStudioCode" `
    -DisplayName "Visual Studio Code" | Out-Null

Install-WingetPackage `
    -PackageId "WiresharkFoundation.Wireshark" `
    -DisplayName "Wireshark" | Out-Null

# ============================================================================
# Python 2.7
# ============================================================================

Write-Step "Checking for Python 2.7..."

if (Test-Path "C:\Python27\python.exe") {

    Write-Warning "Python 2.7 found - skipping"

}
else {

    $py2Url = "https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi"
    $py2Msi = "$TempPath\python27.msi"

    if (Download-File $py2Url $py2Msi "Python 2.7 Installer") {

        Write-Step "Installing Python 2.7 silently..."

        $process = Start-Process `
            -FilePath "msiexec.exe" `
            -ArgumentList "/i `"$py2Msi`" /quiet /norestart ADDLOCAL=ALL" `
            -Wait `
            -PassThru

        if ($process.ExitCode -eq 0) {
            Write-Success "Python 2.7 installed to C:\Python27"
        }
    }
}

# ============================================================================
# GHIDRA
# ============================================================================

$ghidraDir = "$ToolsPath\Ghidra"

if (Test-Path $ghidraDir) {

    Write-Warning "Ghidra found - skipping"

}
else {

    $zip = "$TempPath\ghidra.zip"

    $ghidraUrl = "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.2.1_build/ghidra_11.2.1_PUBLIC_20241105.zip"

    if (Download-File $ghidraUrl $zip "Ghidra") {

        Extract-Archive $zip $ghidraDir "Ghidra" | Out-Null

    }
}

# ============================================================================
# X64DBG
# ============================================================================

$x64dbgDir = "$ToolsPath\x64dbg"

if (Test-Path $x64dbgDir) {

    Write-Warning "x64dbg found - skipping"

}
else {

    $zip = "$TempPath\x64dbg.zip"

    $x64dbgUrl = "https://cytranet.dl.sourceforge.net/project/x64dbg/snapshots/snapshot_2026-04-20_19-04.zip?viasf=1&fid=e9d8c5cb37c2593d"

    if (Download-File $x64dbgUrl $zip "x64dbg") {

        Extract-Archive $zip $x64dbgDir "x64dbg" | Out-Null

    }
}

# ============================================================================
# DETECT IT EASY
# ============================================================================

$dieDir = "$ToolsPath\DetectItEasy"

if (Test-Path $dieDir) {

    Write-Warning "Detect It Easy found - skipping"

}
else {

    $zip = "$TempPath\die.zip"

    $dieUrl = "https://github.com/horsicq/DIE-engine/releases/download/3.21/die_win64_portable_3.21_x64.zip"

    if (Download-File $dieUrl $zip "Detect It Easy") {

        Extract-Archive $zip $dieDir "Detect It Easy" | Out-Null

    }
}

# ============================================================================
# DNSPYEX
# ============================================================================

$dnspyDir = "$ToolsPath\dnSpyEx"

if (Test-Path $dnspyDir) {

    Write-Warning "dnSpyEx found - skipping"

}
else {

    $zip = "$TempPath\dnspy.zip"

    $dnspyUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.5.1/dnSpy-net-win64.zip"

    if (Download-File $dnspyUrl $zip "dnSpyEx") {

        Extract-Archive $zip $dnspyDir "dnSpyEx" | Out-Null

    }
}

# ============================================================================
# HXD
# ============================================================================

$hxdDir = "$ToolsPath\HxD"

if (Test-Path $hxdDir) {

    Write-Warning "HxD found - skipping"

}
else {

    $zip = "$TempPath\hxd.zip"

    $hxdUrl = "https://mh-nexus.de/downloads/HxDPortableSetup.zip"

    if (Download-File $hxdUrl $zip "HxD") {

        Extract-Archive $zip $hxdDir "HxD" | Out-Null

    }
}

# ============================================================================
# IMHEX
# ============================================================================

$imhexDir = "$ToolsPath\ImHex"

if (Test-Path $imhexDir) {

    Write-Warning "ImHex found - skipping"

}
else {

    $zip = "$TempPath\imhex.zip"

    $imhexUrl = "https://github.com/WerWolv/ImHex/releases/download/v1.35.4/imhex-1.35.4-Windows-Portable-x86_64.zip"

    if (Download-File $imhexUrl $zip "ImHex") {

        Extract-Archive $zip $imhexDir "ImHex" | Out-Null

    }
}

# ============================================================================
# Cleanup
# ============================================================================

Write-Step "Cleaning up temporary files..."

Remove-Item `
    -Path $TempPath `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue

Write-Success "Installation Complete! Your lab is fully provisioned."
