function Get-FlexiTime {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $WorkingDayInMinutes = 450,

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
        $RemainingTimeInMinutes
    )

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
}

Export-ModuleMember -Function Get-FlexiTime
