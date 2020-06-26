function Get-FlexiTime {
    [CmdletBinding()]
    param (
        [Parameter()]
        [DateTime]
        $StartTime,

        [Parameter()]
        [int]
        $LunchLengthInMinutes,

        [Parameter()]
        [DateTime]
        $EndTime,

        [Parameter()]
        [int]
        $RemainingTimeInMinutes,

        [Parameter()]
        [int]
        $WorkingDayInMinutes = 450
    )

    # If StartTime is after EndTime, assume that the working day
    # actually spans two different days (e.g. 23:00 - 07:00) 
    # If only time was supplied, PowerShell will default to the current date
    if ($StartTime -gt $EndTime) {
        if ($StartTime.Date -ne $EndTime.Date) {
            throw "StartTime should be earlier than EndTime."
        }

        $EndTime = $EndTime.AddDays(1)
    }

    if ($LunchLengthInMinutes -le 0) {
        throw "LunchLengthInMinutes cannot be a negative number."
    }

    if ($WorkingDayInMinutes -le 0) {
        throw "WorkingDayInMinutes cannot be a negative number."
    }

    if ($StartTime -and $LunchLengthInMinutes -and $EndTime) {
        $RemainingTimeInMinutes = $WorkingDayInMinutes - (($EndTime - $StartTime).TotalMinutes - $LunchLengthInMinutes)
        
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
    elseif ($StartTime -and $LunchLengthInMinutes -and -not $EndTime) {
        $EndTime = $StartTime.AddMinutes($WorkingDayInMinutes + $LunchLengthInMinutes + $RemainingTimeInMinutes)

        Write-Host "End time: $($EndTime.ToString('HH:mm'))"
    }

    return @{
        StartTime = $StartTime;
        LunchLengthInMinutes = $LunchLengthInMinutes;
        EndTime = $EndTime;
        RemainingTimeInMinutes = $RemainingTimeInMinutes;
        WorkingDayInMinutes = $WorkingDayInMinutes;
    }
}

Export-ModuleMember -Function Get-FlexiTime
