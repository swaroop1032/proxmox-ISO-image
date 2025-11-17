$agent = Get-ChildItem D:\ -Recurse -Filter qemu-ga-x64.msi -ErrorAction SilentlyContinue | Select-Object -First 1
if ($agent) { Start-Process msiexec.exe -ArgumentList "/i `"$($agent.FullName)`" /qn" -Wait }
