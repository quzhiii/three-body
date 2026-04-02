param(
    [string[]]$SkillNames
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$repoRoot = Split-Path -Parent $PSScriptRoot

$skillDirs = Get-ChildItem -LiteralPath $repoRoot -Directory |
    Where-Object {
        $_.Name -notin @(".git", ".ruff_cache", "_backup", "scripts") -and
        (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md"))
    }

if ($PSBoundParameters.ContainsKey('SkillNames') -and $SkillNames.Count -gt 0) {
    $skillDirs = $skillDirs | Where-Object { $SkillNames -contains $_.Name }
}

if (-not $skillDirs) {
    throw "No skill directories matched the requested names."
}

foreach ($skillDir in $skillDirs) {
    $archivePath = Join-Path $repoRoot ("{0}.skill" -f $skillDir.Name)
    $tempPath = Join-Path $repoRoot ("{0}.skill.tmp" -f $skillDir.Name)

    if (Test-Path -LiteralPath $tempPath) {
        Remove-Item -LiteralPath $tempPath -Force
    }

    if (Test-Path -LiteralPath $archivePath) {
        Remove-Item -LiteralPath $archivePath -Force
    }

    $zip = [System.IO.Compression.ZipFile]::Open($tempPath, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        $files = Get-ChildItem -LiteralPath $skillDir.FullName -Recurse -File
        foreach ($file in $files) {
            $relativePath = $file.FullName.Substring($skillDir.FullName.Length + 1).Replace('\', '/')
            $entryName = "{0}/{1}" -f $skillDir.Name, $relativePath
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $zip,
                $file.FullName,
                $entryName,
                [System.IO.Compression.CompressionLevel]::Optimal
            ) | Out-Null
        }
    }
    finally {
        $zip.Dispose()
    }

    Move-Item -LiteralPath $tempPath -Destination $archivePath -Force
    Write-Host ("Built {0}" -f $archivePath) -ForegroundColor Green
}

