$cbUrl = "https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi"
$cbMsi = "C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi"
if (-not (Test-Path $cbMsi)) { Invoke-WebRequest -Uri $cbUrl -OutFile $cbMsi -UseBasicParsing }
Start-Process msiexec.exe -ArgumentList "/i `"$cbMsi`" /qn ADDLOCAL=ALL" -Wait
Set-Service -Name cloudbase-init -StartupType Automatic
