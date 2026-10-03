$repoPath = $PSScriptRoot
Set-Location $repoPath

$gitPath = "git"

# Her calismanin ciktisini kaydet (.gitignore'daki *.log sayesinde commitlenmez)
$runLog = Join-Path $repoPath "auto-commit.log"
Start-Transcript -Path $runLog -Append | Out-Null

# GitHub'da yapilan degisiklikleri (orn. web'den readme duzenleme) once cek,
# yoksa push "rejected (fetch first)" hatasi verir
& $gitPath pull --rebase origin main

# Onceki calismadan kalan push edilmemis commit varsa once onlari gonder
& $gitPath push origin main

$commitCount = Get-Random -Minimum 2 -Maximum 7

$logFile = Join-Path $repoPath "commit-log.txt"

for ($i = 1; $i -le $commitCount; $i++) {

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp | commit #$i"
    Add-Content -Path $logFile -Value $line

    & $gitPath add -A
    & $gitPath commit -m "update: $timestamp"

    # Her committen sonra push et; script yarida kesilse bile commitler GitHub'a ulassin
    & $gitPath push origin main

    if ($i -lt $commitCount) {
        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 30)
    }
}

Stop-Transcript | Out-Null
