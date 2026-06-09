# Offline Pharmacy HIS - QZ Tray installer helper for Windows
# Run from an elevated PowerShell window:
#   irm "https://YOUR-SITE.pages.dev/pwsh.sh" | iex

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Write-Step([string]$Message) { Write-Host "`n==> $Message" -ForegroundColor Cyan }
function Write-Ok([string]$Message) { Write-Host "    $Message" -ForegroundColor Green }
function Write-Warn([string]$Message) { Write-Host "    $Message" -ForegroundColor Yellow }

Write-Host "Offline Pharmacy HIS - QZ Tray Setup" -ForegroundColor Green
Write-Host "This script downloads the latest Windows installer from the official qzind/tray GitHub release and opens the installer." -ForegroundColor Gray

$api = "https://api.github.com/repos/qzind/tray/releases/latest"
$headers = @{ "User-Agent" = "Offline-Pharmacy-HIS-QZ-Installer"; "Accept" = "application/vnd.github+json" }

try {
    Write-Step "Checking the latest official QZ Tray release"
    $release = Invoke-RestMethod -Uri $api -Headers $headers -Method Get
    if (-not $release.tag_name) { throw "Latest release tag was not returned by GitHub." }
    Write-Ok ("Latest release: " + $release.tag_name)

    $assets = @($release.assets | Where-Object {
        $_.browser_download_url -match '^https://github\.com/qzind/tray/releases/download/' -and
        $_.name -match '(?i)\.(exe|msi)$'
    })
    if ($assets.Count -eq 0) { throw "No Windows installer asset was found in the official release." }

    $is64 = [Environment]::Is64BitOperatingSystem
    $preferred = @()
    if ($is64) {
        $preferred = @($assets | Where-Object { $_.name -match '(?i)(x86_64|amd64|x64|win64|64-bit)' })
    } else {
        $preferred = @($assets | Where-Object { $_.name -match '(?i)(x86|i386|win32|32-bit)' -and $_.name -notmatch '(?i)(x86_64|x64|64-bit)' })
    }
    $asset = if ($preferred.Count -gt 0) { $preferred[0] } else { $assets[0] }

    $tempDir = Join-Path $env:TEMP "offline-pharmacy-qz"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    $installer = Join-Path $tempDir $asset.name

    Write-Step ("Downloading " + $asset.name)
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer -UseBasicParsing
    if (-not (Test-Path $installer)) { throw "Installer download failed." }
    Write-Ok ("Downloaded to " + $installer)

    try {
        $signature = Get-AuthenticodeSignature -FilePath $installer
        Write-Ok ("Digital signature status: " + $signature.Status)
        if ($signature.Status -eq 'NotSigned') { Write-Warn "Windows reports that the downloaded installer is not signed. Review the publisher in the installer window before continuing." }
    } catch { Write-Warn "Could not read the digital signature. Review the publisher shown by Windows before continuing." }

    Write-Step "Opening the QZ Tray installer"
    if ($installer.ToLower().EndsWith('.msi')) {
        Start-Process -FilePath "msiexec.exe" -ArgumentList @('/i', ('"' + $installer + '"')) -Verb RunAs -Wait
    } else {
        Start-Process -FilePath $installer -Verb RunAs -Wait
    }

    Write-Step "Trying to start QZ Tray"
    $candidates = @(
        (Join-Path $env:ProgramFiles 'QZ Tray\qz-tray.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'QZ Tray\qz-tray.exe'),
        (Join-Path $env:LOCALAPPDATA 'QZ Tray\qz-tray.exe')
    ) | Where-Object { $_ -and (Test-Path $_) }
    if ($candidates.Count -gt 0) {
        Start-Process -FilePath $candidates[0] | Out-Null
        Write-Ok "QZ Tray started. Return to Offline Pharmacy HIS and press 'Connect QZ Tray and find printers'."
    } else {
        Write-Warn "Installation window has closed. If QZ Tray is not running, open it from the Start menu."
    }
} catch {
    Write-Host "`nInstallation helper could not complete: $($_.Exception.Message)" -ForegroundColor Red
    Write-Warn "Opening the official QZ Tray download page instead."
    Start-Process "https://qz.io/download/"
}
