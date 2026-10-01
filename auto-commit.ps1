$repoPath = $PSScriptRoot
Set-Location $repoPath

$gitPath = "git"

$commitCount = Get-Random -Minimum 2 -Maximum 7

$logFile = Join-Path $repoPath "commit-log.txt"

for ($i = 1; $i -le $commitCount; $i++) {

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp | commit #$i"
    Add-Content -Path $logFile -Value $line

    & $gitPath add -A
    & $gitPath commit -m "update: $timestamp"

    Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 30)
}

& $gitPath push origin main
