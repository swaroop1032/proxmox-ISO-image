winrm quickconfig -quiet
Set-Service WinRM -StartupType Automatic
Remove-Item -Recurse -Force C:\Windows\Temp\* -ErrorAction SilentlyContinue
& "$env:SystemRoot\System32\Sysprep\Sysprep.exe" /generalize /oobe /shutdown
