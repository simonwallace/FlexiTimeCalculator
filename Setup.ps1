[CmdletBinding(DefaultParameterSetName = "Install")]
param (

    [Parameter(ParameterSetName = "Install")]
    [switch]
    $Install,

    [Parameter(ParameterSetName = "Uninstall")]
    [switch]
    $Uninstall
)

$MODULE_NAME = "FlexiTimeCalculator"

$installDirectory = $env:PSModulePath.Split([System.IO.Path]::PathSeparator)[0]

if (Test-Path "$installDirectory/$MODULE_NAME") {

    Remove-Item "$installDirectory/$MODULE_NAME" -Recurse
}

if ($Uninstall)  {

    Write-Host "Removed $MODULE_NAME from '$installDirectory'."

    return
}

Copy-Item "$PSScriptRoot/$MODULE_NAME" "$installDirectory/$MODULE_NAME" -Recurse -Force

Write-Host "Installed $MODULE_NAME to '$installDirectory'."
