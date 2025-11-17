$cbUrl = "https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi"
$cbMsi = "C:\Windows\Temp\CloudbaseInitSetup_Stable_x64.msi"

if (-not (Test-Path $cbMsi)) {
  Invoke-WebRequest -Uri $cbUrl -OutFile $cbMsi -UseBasicParsing
}

Start-Process msiexec.exe -ArgumentList "/i `"$cbMsi`" /qn ADDLOCAL=ALL" -Wait

$confDir = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf"
$newConf = @"
[DEFAULT]
logging_serial_port=COM1
username=Administrator
allow_reboot=true
first_logon_behaviour=no
plugins=cloudbaseinit.plugins.common.mtu.MTUPlugin,
        cloudbaseinit.plugins.common.userdata.UserDataPlugin,
        cloudbaseinit.plugins.common.sethostname.SetHostnamePlugin,
        cloudbaseinit.plugins.common.localscripts.LocalScriptsPlugin,
        cloudbaseinit.plugins.common.networkconfig.NetworkConfigPlugin
"@
$newConf | Set-Content -Path "$confDir\cloudbase-init.conf" -Encoding UTF8

Set-Service -Name cloudbase-init -StartupType Automatic
