# Flexi-Time Calculator

Helps to manage flexible working times.

## Setup

Copies the module to the current user's PowerShell modules directory.

### Install

```PowerShell
.\Setup.ps1 -Install
```
or
```PowerShell
.\Setup.ps1
```

### Uninstall

```PowerShell
.\Setup.ps1 -Uninstall
```

## Usage

### `Get-FlexiTime`

- `[[-StartTime] <datetime>]`
- `[[-LunchTimeInMinutes] <int>]`
- `[[-EndTime] <datetime>]`
- `[[-CarryOverTimeInMinutes] <int>]`
- `[[-WorkingDayInMinutes] <int>]` (default: `450`)
- `[[-DefaultsFileLocation] <string>]` (default: `"Config.json"`)

#### `Get-FlexiTime -StartTime <dateTime> -LunchTimeInMinutes <int>`

Get the end time if the start time and lunch time are known.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30
```

```Log
End time: 17:00

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:00:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <dateTime> -LunchTimeInMinutes <int> -CarryOverTimeInMinutes <int>`

Get the end time if the start time, lunch time, and carry over time are known.

If the carry over time is less than 0, then extra time worked on a previous day will be carried over.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -CarryOverTimeInMinutes -30
```

```Log
End time: 16:30

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00
CarryOverTimeInMinutes         -30
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

If the carry over time is more than 0, then time owed from a previous day will be carried over.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -CarryOverTimeInMinutes 30
```

```Log
End time: 17:30

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:30:00
CarryOverTimeInMinutes         30
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <dateTime> -LunchTimeInMinutes <int> -EndTime <dateTime>`

Get the remaining time if the start time, lunch time, and end time are known.

If the remaining time is 0, then the standard working day is complete at the supplied end time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:00
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:00:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

If the remaining time is more than 0, then the standard working day will not be complete by the supplied end time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 16:30
```

```Log
Behind by 30 minutes.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         30
```

If the remaining time is less than 0, then extra time will be worked during the day by the supplied end time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:15
```

```Log
Over by 15 minutes.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:15:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         -15
```

#### `Get-FlexiTime -StartTime <dateTime> -LunchTimeInMinutes <int> -EndTime <dateTime> -CarryOverTimeInMinutes <int>`

Get the remaining time if the start time, lunch time, end time, and carry over time are known.

If the carry over time is less than 0, then extra time worked on a previous day will be carried over.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 16:30 -CarryOverTimeInMinutes -30
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00
CarryOverTimeInMinutes         -30
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

If the carry over time is more than 0, then time owed from a previous day will be carried over.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 16:30 -CarryOverTimeInMinutes 30
```

```Log
Behind by 60 minutes.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00
CarryOverTimeInMinutes         30
WorkingDayInMinutes            450
RemainingTimeInMinutes         60
```
