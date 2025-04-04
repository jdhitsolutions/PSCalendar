---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: https://jdhitsolutions.com/yourls/c4c51c
schema: 2.0.0
---

# Get-NCalendar

## SYNOPSIS

Display a Linux-style ncal calendar.

## SYNTAX

```yaml
Get-NCalendar [[-Month] <String>] [[-Year] <Int32>] [-HideHighlight] [-Monday] [<CommonParameters>]
```

## DESCRIPTION

This command generates equivalent output to the ncal Linux command. This is not a 100% port of that command but it should provide similar results for the same month and year. You should enter the complete month name. There should be tab-completion for the month and year values. This command has an alias of ncal on Windows platforms.

If you run this command in the PowerShell ISE, there will be no highlighting or ANSI formatting.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-NCalendar
     March 2025
Sun  2  9 16 23 30
Mon  3 10 17 24 31
Tue     4 11 18 25
Wed     5 12 19 26
Thu     6 13 20 27
Fri     7 14 21 28
Sat  1  8 15 22 29
```

Get the calendar for the current month. The current day will be highlighted.

### Example 2

```powershell
PS C:\> ncal April 2025
     April 2025
Sun     6 13 20 27
Mon     7 14 21 28
Tue  1  8 15 22 29
Wed  2  9 16 23 30
Thu     3 10 17 24
Fri     4 11 18 25
Sat     5 12 19 26
```

Get an ncal for April 2025. This example is using the ncal alias.

### Example 3

```powershell
PS C:\> Get-MonthName | ncal

    January 2025
Sun     5 12 19 26
Mon     6 13 20 27
Tue     7 14 21 28
Wed  1  8 15 22 29
Thu  2  9 16 23 30
Fri  3 10 17 24 31
Sat     4 11 18 25

    February 2025
Sun     2  9 16 23
Mon     3 10 17 24
Tue     4 11 18 25
Wed     5 12 19 26
Thu     6 13 20 27
Fri     7 14 21 28
Sat     1  8 15 22

    March 2025
Sun  2  9 16 23 30
Mon  3 10 17 24 31
Tue     4 11 18 25
Wed     5 12 19 26
Thu     6 13 20 27
Fri     7 14 21 28
Sat  1  8 15 22 29
...
```

Display an ncal listing for the entire year.

## PARAMETERS

### -Month

Enter the full month name. You should be able to tab-complete the parameter value. The default is the current month.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: current month
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Year

Enter the 4 digit year. You should be able to tab-complete the next 5 years but you can enter any 4 digit year.
The default is the current year.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: current year
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HideHighlight

Don't highlight the current date. This parameter is automatically set to true when running in the PowerShell ISE.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Monday

Start the week on Monday.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### String

## NOTES

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-Calendar](Get-Calendar.md)

[Get-MonthName](Get-MonthName.md)
