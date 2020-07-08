function Set-FlexiTimeDefaults {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]
        $FileLocation = "Config.json",

        [Parameter()]
        [Nullable[DateTime]]
        $StartTime,

        [Parameter()]
        [Nullable[int]]
        $LunchTimeInMinutes,

        [Parameter()]
        [Nullable[DateTime]]
        $EndTime,

        [Parameter()]
        [Nullable[int]]
        $CarryOverTimeInMinutes,

        [Parameter()]
        [Nullable[int]]
        $WorkingDayInMinutes
    )

    $defaults = Get-FlexiTimeDefaults $FileLocation

    if ($PSBoundParameters.Count -gt 0) {
        foreach ($parameterKey in $PSBoundParameters.Keys) {
            $defaults[$parameterKey] = $PSBoundParameters[$parameterKey]
        }

        Set-Content $FileLocation (ConvertTo-Json $defaults)
    }

    return $defaults
}

Export-ModuleMember -Function Set-FlexiTimeDefaults
