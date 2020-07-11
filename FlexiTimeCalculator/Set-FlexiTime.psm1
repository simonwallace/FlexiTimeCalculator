function Set-FlexiTime {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Collections.Specialized.OrderedDictionary]
        $FlexiTimeConfiguration,

        [Parameter()]
        [string]
        $FileName
    )

    if (-not $FileName) {
        $FileName = "$($FlexiTimeConfiguration.StartTime.ToString('yyyyMMdd')).json"
    }

    if (Test-Path $FileName) {
        throw "$FileName already exists."
    }

    Set-Content $FileName (ConvertTo-Json $FlexiTimeConfiguration)
}
