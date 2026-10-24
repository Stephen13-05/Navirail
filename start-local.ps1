$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot 'Frontend\station_explorer')
if (!(Test-Path node_modules)) { & npm.cmd ci; if ($LASTEXITCODE) { exit $LASTEXITCODE } }
& npm.cmd run build
if ($LASTEXITCODE) { exit $LASTEXITCODE }
& npm.cmd start

