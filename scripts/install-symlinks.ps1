# install-symlinks.ps1 - Setup symlinks for AI command systems (Windows)
#
# This script creates symbolic links from AI assistant directories
# (.claude, .cursor) to the centralized command repository (.ai/commands/).
#
# Requirements:
#   - Windows 10+ (with Developer Mode enabled) OR
#   - Run as Administrator
#
# Usage:
#   .\scripts\install-symlinks.ps1
#   make install-windows

#Requires -Version 5.1

# Set strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Script variables
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

# Directories
$AiCommandsGeneric = Join-Path $ProjectRoot ".ai\commands\generic"
$AiCommandsClaude = Join-Path $ProjectRoot ".ai\commands\claude"
$AiCommandsCodex = Join-Path $ProjectRoot ".ai\commands\codex"
$ClaudeCommands = Join-Path $ProjectRoot ".claude\commands"
$CursorCommands = Join-Path $ProjectRoot ".cursor\commands"

# Counters
$Script:Created = 0
$Script:Skipped = 0
$Script:Errors = 0

# Color functions
function Write-Header {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host "  AI Diagrams Toolkit - Symlink Installation (Windows)" -ForegroundColor Blue
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-DeveloperMode {
    try {
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
        $value = Get-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue
        return ($null -ne $value -and $value.AllowDevelopmentWithoutDevLicense -eq 1)
    } catch {
        return $false
    }
}

function Test-Privileges {
    Write-Info "Checking privileges..."

    $isAdmin = Test-Administrator
    $devMode = Test-DeveloperMode

    if ($isAdmin) {
        Write-Success "Running as Administrator"
        return $true
    }

    if ($devMode) {
        Write-Success "Developer Mode enabled"
        return $true
    }

    Write-Error "Insufficient privileges for creating symlinks"
    Write-Host ""
    Write-Host "  To create symlinks on Windows, you need either:" -ForegroundColor Yellow
    Write-Host "    1. Run PowerShell as Administrator, OR" -ForegroundColor Yellow
    Write-Host "    2. Enable Developer Mode in Windows Settings" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  To enable Developer Mode:" -ForegroundColor Cyan
    Write-Host "    Settings → Privacy & Security → For developers → Developer Mode" -ForegroundColor Cyan
    Write-Host ""

    return $false
}

function Test-SourceDirectories {
    Write-Info "Checking source directories..."

    if (-not (Test-Path $AiCommandsGeneric)) {
        Write-Error "Source directory not found: .ai\commands\generic\"
        exit 1
    }

    Write-Success "Source directories validated"
    Write-Host ""
}

function New-SymbolicLink {
    param(
        [string]$Target,
        [string]$Link,
        [string]$Description
    )

    # Check if target exists
    if (-not (Test-Path $Target)) {
        Write-Warning "$Description : Source not found, skipping"
        $Script:Skipped++
        return
    }

    # Remove existing link if it's a symlink
    if (Test-Path $Link) {
        $item = Get-Item $Link -Force
        if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            Write-Info "$Description : Removing existing symlink"
            $item.Delete()
        } else {
            Write-Warning "$Description : Path exists (not a symlink), skipping"
            Write-Info "  → Manually remove: $Link"
            $Script:Skipped++
            return
        }
    }

    # Create parent directory if needed
    $parentDir = Split-Path -Parent $Link
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Determine if target is directory or file
    $targetIsDirectory = Test-Path $Target -PathType Container
    $linkType = if ($targetIsDirectory) { "Directory" } else { "File" }

    # Create symlink
    try {
        # Convert to relative path for better portability
        $relativePath = [System.IO.Path]::GetRelativePath($parentDir, $Target)

        New-Item -ItemType SymbolicLink -Path $Link -Target $relativePath -Force -ErrorAction Stop | Out-Null
        Write-Success "$Description"
        $Script:Created++
    } catch {
        Write-Error "$Description : Failed to create symlink"
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        $Script:Errors++
    }
}

function Install-ClaudeSymlinks {
    Write-Info "Setting up Claude Code symlinks..."
    Write-Host ""

    # Main generic commands
    $target = Join-Path $ProjectRoot ".ai\commands\generic"
    New-SymbolicLink -Target $target -Link $ClaudeCommands -Description "Claude Code: generic commands"

    # Claude-specific commands subdirectory
    if (Test-Path $AiCommandsClaude) {
        $claudeTarget = Join-Path $ProjectRoot ".ai\commands\claude"
        $claudeLink = Join-Path $ClaudeCommands "claude"
        New-SymbolicLink -Target $claudeTarget -Link $claudeLink -Description "Claude Code: claude-specific commands"
    }

    Write-Host ""
}

function Install-CursorSymlinks {
    Write-Info "Setting up Cursor IDE symlinks..."
    Write-Host ""

    # Only generic commands (Cursor doesn't support subdirectories)
    $target = Join-Path $ProjectRoot ".ai\commands\generic"
    New-SymbolicLink -Target $target -Link $CursorCommands -Description "Cursor IDE: generic commands"

    Write-Host ""
}

function Show-CodexInstructions {
    Write-Info "Codex CLI setup instructions..."
    Write-Host ""
    Write-Host "  Codex CLI uses global scope (~/.codex/prompts/), so symlinks"
    Write-Host "  are not applicable. Copy commands manually as needed:"
    Write-Host ""
    Write-Host "  # Generic commands" -ForegroundColor Yellow
    Write-Host "  Copy-Item .ai\commands\generic\*.md -Destination ~\.codex\prompts\"
    Write-Host ""
    Write-Host "  # Codex-specific commands" -ForegroundColor Yellow
    if ((Test-Path $AiCommandsCodex) -and (Get-ChildItem $AiCommandsCodex -ErrorAction SilentlyContinue)) {
        Write-Host "  Copy-Item .ai\commands\codex\*.md -Destination ~\.codex\prompts\"
    } else {
        Write-Host "  (No codex-specific commands yet)"
    }
    Write-Host ""
    Write-Host "  After copying, restart Codex CLI to load new commands."
    Write-Host ""
}

function Test-Installation {
    Write-Info "Verifying installation..."
    Write-Host ""

    $allGood = $true

    # Check Claude Code
    if ((Test-Path $ClaudeCommands) -and ((Get-Item $ClaudeCommands -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        Write-Success "Claude Code: commands symlink valid"
    } else {
        Write-Error "Claude Code: commands symlink invalid or broken"
        $allGood = $false
    }

    # Check Cursor
    if ((Test-Path $CursorCommands) -and ((Get-Item $CursorCommands -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        Write-Success "Cursor IDE: commands symlink valid"
    } else {
        Write-Error "Cursor IDE: commands symlink invalid or broken"
        $allGood = $false
    }

    Write-Host ""

    if ($allGood) {
        Write-Success "All symlinks verified successfully!"
    } else {
        Write-Warning "Some symlinks could not be verified"
    }
}

function Show-Summary {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host "  Installation Summary" -ForegroundColor Blue
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Blue
    Write-Host ""
    Write-Host "  Symlinks created: " -NoNewline
    Write-Host $Script:Created -ForegroundColor Green
    Write-Host "  Skipped:          " -NoNewline
    Write-Host $Script:Skipped -ForegroundColor Yellow
    Write-Host "  Errors:           " -NoNewline
    Write-Host $Script:Errors -ForegroundColor Red
    Write-Host ""

    if ($Script:Errors -eq 0) {
        Write-Success "Installation completed successfully!"
        Write-Host ""
        Write-Info "Next steps:"
        Write-Host "  1. Restart Claude Code / Cursor IDE"
        Write-Host "  2. Type '/' to see available commands"
        Write-Host "  3. For Codex CLI, follow manual copy instructions above"
    } else {
        Write-Warning "Installation completed with errors"
        Write-Host ""
        Write-Info "Please check error messages above and retry"
    }

    Write-Host ""
}

# Main execution
function Main {
    Write-Header

    # Check privileges
    if (-not (Test-Privileges)) {
        exit 1
    }
    Write-Host ""

    # Check prerequisites
    Test-SourceDirectories

    # Install symlinks
    Install-ClaudeSymlinks
    Install-CursorSymlinks

    # Verify installation
    Test-Installation

    # Print Codex instructions
    Show-CodexInstructions

    # Print summary
    Show-Summary
}

# Run main function
try {
    Main
} catch {
    Write-Host ""
    Write-Error "Unexpected error occurred:"
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host $_.ScriptStackTrace -ForegroundColor Red
    exit 1
}
