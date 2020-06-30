function Get-FlexiTimeDefaults {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $FileLocation = "Config.json"
    )

    $defaults = [ordered]@{}

    if (Test-Path $FileLocation) {
        $json = Get-Content $FileLocation | ConvertFrom-Json
        $properties = $json.PSObject.Properties

        foreach ($property in $properties) {
            $defaults[$property.Name] = $property.Value
        }
    }

    return $defaults
}

Export-ModuleMember -Function Get-FlexiTimeDefaults
