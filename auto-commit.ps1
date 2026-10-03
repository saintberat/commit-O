$repoPath = $PSScriptRoot
Set-Location $repoPath

$gitPath = "git"

# Her calismanin ciktisini kaydet (.gitignore'daki *.log sayesinde commitlenmez)
$runLog = Join-Path $repoPath "auto-commit.log"
Start-Transcript -Path $runLog -Append | Out-Null

# Task Scheduler'dan calisinca git'in gh credential helper'i bos donuyor ve push
# "could not read Username" hatasi veriyor. Token'i gh'dan kendimiz alip git'e veriyoruz.
# (Token env var'da tutulur; komut satirinda veya log'da gorunmez.)
$env:GIT_TERMINAL_PROMPT = '0'
$env:AUTO_COMMIT_TOKEN = (& gh auth token).Trim()
$credHelper = '!f() { echo username=x-access-token; echo "password=$AUTO_COMMIT_TOKEN"; }; f'

function Invoke-GitRemote {
    & $gitPath -c credential.helper= -c "credential.helper=$credHelper" @args
}

# GitHub'da yapilan degisiklikleri (orn. web'den readme duzenleme) once cek,
# yoksa push "rejected (fetch first)" hatasi verir
Invoke-GitRemote pull --rebase origin main

# Onceki calismadan kalan push edilmemis commit varsa once onlari gonder
Invoke-GitRemote push origin main

$commitCount = Get-Random -Minimum 2 -Maximum 7

$logFile = Join-Path $repoPath "commit-log.txt"

for ($i = 1; $i -le $commitCount; $i++) {

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp | commit #$i"
    Add-Content -Path $logFile -Value $line

    & $gitPath add -A
    & $gitPath commit -m "update: $timestamp"

    # Her committen sonra push et; script yarida kesilse bile commitler GitHub'a ulassin
    Invoke-GitRemote push origin main

    if ($i -lt $commitCount) {
        Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 30)
    }
}

Stop-Transcript | Out-Null
