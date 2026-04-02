Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ErrorMessage {
    param([string]$Message)
    $errors.Add($Message)
}

function Resolve-MarkdownTarget {
    param(
        [string]$BaseDir,
        [string]$Target
    )

    if ([string]::IsNullOrWhiteSpace($Target)) {
        return $null
    }

    $clean = $Target.Split('#')[0].Split('?')[0]
    if ([string]::IsNullOrWhiteSpace($clean)) {
        return $null
    }

    return [System.IO.Path]::GetFullPath((Join-Path $BaseDir $clean))
}

$licensePath = Join-Path $repoRoot "LICENSE"
if (-not (Test-Path -LiteralPath $licensePath)) {
    Add-ErrorMessage "Missing root LICENSE file."
}

$skillDirs = Get-ChildItem -LiteralPath $repoRoot -Directory |
    Where-Object {
        $_.Name -notin @(".git", ".ruff_cache", "_backup", "scripts") -and
        (Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md"))
    }

foreach ($dir in $skillDirs) {
    $skillFile = Join-Path $dir.FullName "SKILL.md"
    $readmeFile = Join-Path $dir.FullName "README.md"

    if (-not (Test-Path -LiteralPath $skillFile)) {
        Add-ErrorMessage "Skill package '$($dir.Name)' is missing SKILL.md."
    }

    if (-not (Test-Path -LiteralPath $readmeFile)) {
        Add-ErrorMessage "Skill package '$($dir.Name)' is missing README.md."
    }

    $artifactFile = Join-Path $repoRoot ("{0}.skill" -f $dir.Name)
    if (-not (Test-Path -LiteralPath $artifactFile)) {
        Add-ErrorMessage "Skill package '$($dir.Name)' is missing packaged artifact '$($dir.Name).skill'."
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -File |
    Where-Object {
        $_.Extension -eq ".md" -and
        $_.FullName -notmatch '[\\/]\.git[\\/]' -and
        $_.FullName -notmatch '[\\/]_backup[\\/]'
    }

$linkPattern = '\[[^\]]+\]\(([^)]+)\)'

foreach ($file in $markdownFiles) {
    $content = Get-Content -LiteralPath $file.FullName -Encoding UTF8
    foreach ($line in $content) {
        $matches = [regex]::Matches($line, $linkPattern)
        foreach ($match in $matches) {
            $target = $match.Groups[1].Value.Trim()

            if (
                [string]::IsNullOrWhiteSpace($target) -or
                $target.StartsWith("http://") -or
                $target.StartsWith("https://") -or
                $target.StartsWith("mailto:") -or
                $target.StartsWith("#")
            ) {
                continue
            }

            $resolved = Resolve-MarkdownTarget -BaseDir $file.DirectoryName -Target $target
            if ($null -eq $resolved) {
                continue
            }

            if (-not (Test-Path -LiteralPath $resolved)) {
                $relativeFile = Resolve-Path -LiteralPath $file.FullName -Relative
                Add-ErrorMessage "Broken local link in ${relativeFile}: $target"
            }
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Repository validation failed:" -ForegroundColor Red
    foreach ($message in $errors) {
        Write-Host " - $message" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Repository validation passed." -ForegroundColor Green
