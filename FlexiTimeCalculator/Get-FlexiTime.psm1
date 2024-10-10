function Get-FlexiTime {
    [CmdletBinding(DefaultParameterSetName = "SuppliedDate")]
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

        [Parameter(ParameterSetName = "AddDays", Mandatory)]
        [int]
        $AddDays,

        [Parameter(ParameterSetName = "SubtractDays", Mandatory)]
        [int]
        $SubtractDays,

        [Parameter(ParameterSetName = "Tomorrow", Mandatory)]
        [switch]
        $Tomorrow,

        [Parameter(ParameterSetName = "Yesterday", Mandatory)]
        [switch]
        $Yesterday,

        [Parameter()]
        [string]
        $DefaultsFileLocation = "Config.json"
    )

    [int] $RemainingTimeInMinutes = 0

    $defaults = Get-FlexiTimeDefaults $DefaultsFileLocation

    foreach ($key in $defaults.Keys) {
        Set-Variable $key $defaults[$key]
    }

    if ($AddDays -or $SubtractDays -or $Tomorrow -or $Yesterday) {
        if (-not $StartTime -and -not $EndTime) {
            throw "StartTime or EndTime are required when using AddDays, SubtractDays, Tomorrow, or Yesterday arguments."
        }

        if ($AddDays -or $SubtractDays) {
            $RelativeAddDays = $AddDays ? $AddDays : $SubtractDays * -1

            if ($StartTime) {
                $StartTime = $StartTime.AddDays($RelativeAddDays)
            }

            if ($EndTime) {
                $EndTime = $EndTime.AddDays($RelativeAddDays)
            }
        }
        elseif ($Tomorrow -or $Yesterday) {
            $TodayAddDays = $Tomorrow ? 1 : -1

            if ($StartTime) {
                $Today = Get-Date -Hour $StartTime.Hour -Minute $StartTime.Minute -Second $StartTime.Second -Millisecond $StartTime.Millisecond

                $StartTime = $Today.AddDays($TodayAddDays)
            }

            if ($EndTime) {
                $Today = Get-Date -Hour $EndTime.Hour -Minute $EndTime.Minute -Second $EndTime.Second -Millisecond $EndTime.Millisecond

                $EndTime = $Today.AddDays($TodayAddDays)
            }
        }
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

    if ($LunchTimeInMinutes -lt 0) {
        throw "LunchTimeInMinutes must be a positive number."
    }

    if ($WorkingDayInMinutes -lt 0) {
        throw "WorkingDayInMinutes must be a positive number."
    }

    if ($StartTime -and $EndTime) {
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
    elseif ($StartTime -and -not $EndTime) {
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
