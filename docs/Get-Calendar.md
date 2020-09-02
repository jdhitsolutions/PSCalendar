---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: http://bit.ly/31TNoP8
schema: 2.0.0
---

# Get-Calendar

## SYNOPSIS

Displays a visual representation of a calendar.

## SYNTAX

### month (Default)

```yaml
Get-Calendar [[-Month] <String>] [[-Year] <Int32>] [-HighlightDate <DateTime[]>] [<CommonParameters>]
```

### span

```yaml
Get-Calendar -Start <DateTime> -End <DateTime> [-HighlightDate <DateTime[]>] [<CommonParameters>]
```

## DESCRIPTION

This command displays a visual representation of a calendar. It supports multiple months, as well as the ability to highlight a specific date or dates. The default display uses ANSI escape sequences. You can adjust the color scheme using Set-PSCalendarConfiguration.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-Calendar

              September 2020

 Sun   Mon   Tue   Wed   Thu   Fri   Sat
  30    31     1     2     3     4     5
   6     7     8     9    10    11    12
  13    14    15    16    17    18    19
  20    21    22    23    24    25    26
  27    28    29    30     1     2     3
```

Show the current month. The current day will be formatted in color.

### EXAMPLE 2

```powershell
PS C:\>  Get-Calendar -start "3/1/2020" -end "5/1/2020"
```

Display monthly calendars from March to May, 2020.

### EXAMPLE 3

```powershell
PS C:\> Get-Calendar December -HighlightDate 12/4/2020,12/25/2020,12/24/2020,12/31/2020


              December 2020

 Sun   Mon   Tue   Wed   Thu   Fri   Sat
  29    30     1     2     3     4     5
   6     7     8     9    10    11    12
  13    14    15    16    17    18    19
  20    21    22    23    24    25    26
  27    28    29    30    31     1     2
```

Display a month and highlight specific dates in color.

## PARAMETERS

### -Month

Select a month to display. The command will default to the current year unless otherwise specified.

```yaml
Type: String
Parameter Sets: month
Aliases:

Required: False
Position: 1
Default value: current month
Accept pipeline input: False
Accept wildcard characters: False
```

### -Year

Select a year for the specified month.

```yaml
Type: Int32
Parameter Sets: month
Aliases:

Required: False
Position: 2
Default value: Current year
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start

The first month to display.

```yaml
Type: DateTime
Parameter Sets: span
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End

The last month to display.

```yaml
Type: DateTime
Parameter Sets: span
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HighlightDate

Specific days (named) to highlight. These dates are color formatted using ANSI escape sequences.

```yaml
Type: DateTime[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).date.toString()
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

## NOTES

This command should have an alias of cal. This function was originally inspired from work by Lee Holmes at http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Date](Get-Date.md)

[Set-PSCalendarConfiguration](Set-PSCalendarConfiguration.md)

[Show-Calendar](Show-Calendar.md)

[Show-GuiCalendar](Show-GuiCalendar.md)
