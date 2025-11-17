$driverPaths = @('D:\viostor\w10\amd64','D:\NetKVM\w10\amd64','D:\Balloon\w10\amd64')
foreach ($p in $driverPaths) { if (Test-Path $p) { pnputil /add-driver "$p\*.inf" /install } }
