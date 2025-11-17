$driverPaths = @(
  'D:\viostor\w10\amd64',
  'D:\NetKVM\w10\amd64',
  'D:\Balloon\w10\amd64'
)

foreach ($path in $driverPaths) {
  if (Test-Path $path) {
    pnputil /add-driver "$path\*.inf" /install
  } else {
    Write-Warning "Driver path not found: $path"
  }
}
