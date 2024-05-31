Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$pgName
)

Push-Location $($MyInvocation.InvocationName | Split-Path)
Push-Location ..
Remove-Item -Path dMT -Recurse -Force -ErrorAction Ignore
New-Item -ItemType Directory -Force -Path "dMT"
Push-Location "dMT"

#TODO - Call the deployment tool.

Pop-Location
Pop-Location
Pop-Location
Pop-Location
