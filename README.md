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

- `[[-StartTime] <DateTimeOffset>]`
- `[[-LunchTimeInMinutes] <int>]`
- `[[-EndTime] <DateTimeOffset>]`
- `[[-CarryOverTimeInMinutes] <int>]`
- `[-WorkingDayInMinutes <int>]` (default: `450`)
- `[-AddDays <int>]`
- `[-SubtractDays <int>]`
- `[-Tomorrow]`
- `[-Yesterday]`
- `[-DefaultsFileLocation <string>]` (default: `"Config.json"`)

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int>`

Get the end time if the start time and lunch time are known.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30
```

```Log
End time: 17:00

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:00:00 +01:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -CarryOverTimeInMinutes <int>`

Get the end time if the start time, lunch time, and carry over time are known.

If the carry over time is less than 0, then extra time worked on a previous day will be carried over.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -CarryOverTimeInMinutes -30
```

```Log
End time: 16:30

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00 +01:00
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
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:30:00 +01:00
CarryOverTimeInMinutes         30
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -EndTime <DateTimeOffset>`

Get the remaining time if the start time, lunch time, and end time are known.

If the remaining time is 0, then the standard working day is complete at the supplied end time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:00
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:00:00 +01:00
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
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00 +01:00
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
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 17:15:00 +01:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         -15
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -EndTime <DateTimeOffset> -CarryOverTimeInMinutes <int>`

Get the remaining time if the start time, lunch time, end time, and carry over time are known.

If the carry over time is less than 0, then extra time worked on a previous day will be carried over.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 16:30 -CarryOverTimeInMinutes -30
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00 +01:00
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
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00 +01:00
CarryOverTimeInMinutes         30
WorkingDayInMinutes            450
RemainingTimeInMinutes         60
```

#### `Get-FlexiTime <DateTimeOffset> <int> <DateTimeOffset> <int>`

StartTime, LunchTimeInMinutes, EndTime, and CarryOverTimeInMinutes are also positional arguments, so the argument names can be omitted.

```PowerShell
Get-FlexiTime 09:00 30 16:30 45
```

```Log
Behind by 75 minutes.

Name                           Value
----                           -----
StartTime                      03/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        03/07/2020 16:30:00 +01:00
CarryOverTimeInMinutes         45
WorkingDayInMinutes            450
RemainingTimeInMinutes         75
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -EndTime <DateTimeOffset> -AddDays <int>`

Add the specified number of days to the start time and end time (if specified) and get the remaining time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:00 -AddDays 3
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      06/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        06/07/2020 17:00:00 +01:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -EndTime <DateTimeOffset> -SubtractDays <int>`

Subtract the specified number of days from the start time and end time (if specified) and get the remaining time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:00 -SubtractDays 3
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      30/06/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        30/06/2020 17:00:00 +01:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -EndTime <DateTimeOffset> -Tomorrow`

Increase the start time and end time (if specified) by one day and get the remaining time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:00 -Tomorrow
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      04/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        04/07/2020 17:00:00 +01:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```

#### `Get-FlexiTime -StartTime <DateTimeOffset> -LunchTimeInMinutes <int> -EndTime <DateTimeOffset> -Yesterday`

Decrease the start time and end time (if specified) by one day and get the remaining time.

```PowerShell
Get-FlexiTime -StartTime 09:00 -LunchTimeInMinutes 30 -EndTime 17:00 -Yesterday
```

```Log
Standard number of hours worked.

Name                           Value
----                           -----
StartTime                      02/07/2020 09:00:00 +01:00
LunchTimeInMinutes             30
EndTime                        02/07/2020 17:00:00 +01:00
CarryOverTimeInMinutes         0
WorkingDayInMinutes            450
RemainingTimeInMinutes         0
```
