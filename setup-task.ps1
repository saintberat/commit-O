$scriptPath = Join-Path $PSScriptRoot "auto-commit.ps1"

$taskName = "AutoCommitDaily"
$description = "her gun 2-6 arasi rastgele commit atar"

$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "eski gorev silindi, yenisi olusturuluyor..." -ForegroundColor Yellow
}

$hour = Get-Random -Minimum 10 -Maximum 18
$minute = Get-Random -Minimum 0 -Maximum 59

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Daily -At "${hour}:${minute}"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Description $description

Write-Host ""
Write-Host "gorev basariyla olusturuldu!" -ForegroundColor Green
Write-Host "gorev adi   : $taskName" -ForegroundColor Cyan
Write-Host "calisma     : her gun saat $($hour.ToString('00')):$($minute.ToString('00'))" -ForegroundColor Cyan
Write-Host "script      : $scriptPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "not: bu scriptin calismasi icin git yuklu ve repo push yetkisi olmali." -ForegroundColor Yellow
