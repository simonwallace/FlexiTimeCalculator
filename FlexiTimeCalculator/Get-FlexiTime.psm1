function Get-FlexiTime {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [Nullable[DateTime]]
        $StartTime,

        [Parameter(Position = 1)]
        [int]
        $LunchTimeInMinutes,

        [Parameter(Position = 2)]
        [Nullable[DateTime]]
        $EndTime,

        [Parameter(Position = 3)]
        [int]
        $CarryOverTimeInMinutes,

        [Parameter()]
        [int]
        $WorkingDayInMinutes = 450,

        [Parameter()]
        [string]
        $DefaultsFileLocation = "Config.json"
    )

    [int] $RemainingTimeInMinutes = 0

    $defaults = Get-FlexiTimeDefaults $DefaultsFileLocation

    foreach ($key in $defaults.Keys) {
        Set-Variable $key $defaults[$key]
    }

    # If StartTime is after EndTime, assume that the working day
    # actually spans two different days (e.g. 23:00 - 07:00) 
    # If only time was supplied, PowerShell will default to the current date
    if ($StartTime -and $EndTime -and ($StartTime -gt $EndTime)) {
        if ($StartTime.Date -ne $EndTime.Date) {
            throw "StartTime should be earlier than EndTime."
        }

        $EndTime = $EndTime.AddDays(1)
    }

    if ($LunchTimeInMinutes -le 0) {
        throw "LunchTimeInMinutes must be a positive number."
    }

    if ($WorkingDayInMinutes -le 0) {
        throw "WorkingDayInMinutes must be a positive number."
    }

    if ($StartTime -and $LunchTimeInMinutes -and $EndTime) {
        $RemainingTimeInMinutes = $WorkingDayInMinutes - (($EndTime - $StartTime).TotalMinutes - $LunchTimeInMinutes - $CarryOverTimeInMinutes)
        
        if ($RemainingTimeInMinutes -gt 0) {
            Write-Host "Behind by $RemainingTimeInMinutes minutes." -ForegroundColor Yellow
        }
        elseif ($RemainingTimeInMinutes -lt 0) {
            Write-Host "Over by $($RemainingTimeInMinutes * -1) minutes." -ForegroundColor Cyan
        }
        else {
            Write-Host "Standard number of hours worked." -ForegroundColor Green
        }
    }
    elseif ($StartTime -and $LunchTimeInMinutes -and -not $EndTime) {
        $EndTime = $StartTime.AddMinutes($WorkingDayInMinutes + $LunchTimeInMinutes + $CarryOverTimeInMinutes)

        $RemainingTimeInMinutes = 0

        Write-Host "End time: $($EndTime.ToString('HH:mm'))"
    }

    return [ordered]@{
        StartTime = $StartTime;
        LunchTimeInMinutes = $LunchTimeInMinutes;
        EndTime = $EndTime;
        CarryOverTimeInMinutes = $CarryOverTimeInMinutes;
        WorkingDayInMinutes = $WorkingDayInMinutes;
        RemainingTimeInMinutes = $RemainingTimeInMinutes;
    }
}

Export-ModuleMember -Function Get-FlexiTime
