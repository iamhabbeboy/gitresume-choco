
# $ErrorActionPreference = 'Stop' # stop on all errors
# $toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# $url64      = '' # 64bit URL here (HTTPS preferred) or remove - if installer contains both (very rare), use $url




# $packageArgs = @{
#   packageName   = $env:ChocolateyPackageName
#   unzipLocation = $toolsDir
#   fileType      = 'EXE' #only one  of these: exe, msi, msu
#   url64bit      = $url64
#   #file         = $fileLocation

#   softwareName  = 'gitresume*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
 
#   checksum64    = ''
#   checksumType64= 'sha256' #default is checksumType

#   # MSI
#   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
#   validExitCodes= @(0, 3010, 1641)
# }

# Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage


$ErrorActionPreference = 'Stop'

$packageName = 'gitresume'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = 'https://github.com/iamhabbeboy/gitresume-cli/releases/download/v0.1.0/gitresume-cli_0.1.0_windows_amd64.zip'
$checksum    = '3b207d2e5658fc7a0e7a244a9913508d2491eb083f185afc17b907e60e6cca1e'
$checksumType = 'sha256'

# Step 1: Download and extract the ZIP
Install-ChocolateyZipPackage `
  -PackageName $packageName `
  -Url $url `
  -Checksum $checksum `
  -ChecksumType $checksumType `
  -UnzipLocation $toolsDir

# Step 2: Locate the extracted EXE file
$exePath = Get-ChildItem -Path $toolsDir -Recurse -Filter 'gitresume.exe' | Select-Object -First 1

if (-not $exePath) {
    Write-Error "gitresume.exe not found after extraction. Check your archive structure."
    exit 1
}

# Step 3: Move the EXE to the tools directory (flatten if nested)
$targetPath = Join-Path $toolsDir 'gitresume.exe'
Move-Item $exePath.FullName $targetPath -Force

# Step 4: Add the tools directory to PATH (so users can run 'gitresume' globally)
Install-ChocolateyPath $toolsDir 'Machine'

Write-Host "✅ gitresume has been installed successfully!"
Write-Host "You can now run 'gitresume' from any terminal window."
