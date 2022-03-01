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
Get-Calendar [[-Month] <String>] [[-Year] <Int32>] [-HighlightDate <String[]>] [-FirstDay <DayOfWeek>] [-NoANSI] [-MonthOnly] [<CommonParameters>]
```

### span

```yaml
Get-Calendar -Start <String> -End <String> [-HighlightDate <String[]>] [-FirstDay <DayOfWeek>] [-NoANSI] [-MonthOnly] [<CommonParameters>]
```

## DESCRIPTION

This command displays a visual representation of a calendar. It supports multiple months, as well as the ability to highlight a specific date or dates. The default display uses ANSI escape sequences. You can adjust the color scheme using Set-PSCalendarConfiguration.

When you enter Highlight, Start, or End dates, be sure to use the format that is culturally appropriate. It should match the pattern you get from running this command:

(Get-Culture).datetimeformat.ShortDatePattern

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-Calendar

                  July 2021

 Sun   Mon   Tue   Wed   Thu   Fri   Sat
  27    28    29    30     1     2     3
   4     5     6     7     8     9    10
  11    12    13    14    15    16    17
  18    19    20    21    22    23    24
  25    26    27    28    29    30    31
```

Show the current month. The current day will be formatted in color.

### Example 2

```powershell
PS C:\>  Get-Calendar -start "3/1/2021" -end "5/1/2021"
```

Display monthly calendars from March to May, 2021.

### Example 3

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

### Example 4

```powershell
PS C:\> Get-Calendar august -firstday Monday -highlight 1/8/2021,15,8,2021

                August 2021

 Mon   Tue   Wed   Thu   Fri   Sat   Sun
  26    27    28    29    30    31     1
   2     3     4     5     6     7     8
   9    10    11    12    13    14    15
  16    17    18    19    20    21    22
  23    24    25    26    27    28    29
  30    31     1     2     3     4
```

In Windows PowerShell, all of the commands appear to respect culture settings. However, when running in PowerShell 7 there appears to be a bug in .NET Core and how it returns culture information for some cultures, specifically the first day of the week. If you run `Get-Calendar` or `Show-Calendar` and the week begins on the wrong day, use the `FirstDay` parameter to override the detected .NET values with the correct one. If you are running under the en-AU culture in PowerShell 7, you would need to run this command.

### Example 5

```powershell
PS C:\> Get-Calendar -NoANSI -Start 7/1/2021 -end 9/1/2021  | Out-File c:\work\Q3.txt
```

Get the calendars for a month of ranges with no ANSI formatting and save the output to a text file.

### Example 6

```powershell
PS C:\> Get-Calendar -Month January -Year 2022 -NoANSI -MonthOnly

               January 2022

 Sun   Mon   Tue   Wed   Thu   Fri   Sat
                                       1
   2     3     4     5     6     7     8
   9    10    11    12    13    14    15
  16    17    18    19    20    21    22
  23    24    25    26    27    28    29
  30    31
```

Suppress leading and trailing days from other months with the MonthOnly parameter.

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

The first month to display. You must format the dates to match your culture. It should match the pattern you get from running this command:

(Get-Culture).datetimeformat.ShortDatePattern

```yaml
Type: String
Parameter Sets: span
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -End

The last month to display. You must format the dates to match your culture. It should match the pattern you get from running this command:

(Get-Culture).datetimeformat.ShortDatePattern

```yaml
Type: String
Parameter Sets: span
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HighlightDate

Specific days (named) to highlight. These dates are color formatted using ANSI escape sequences. You must format the dates to match your culture. It should match the pattern you get from running this command:

(Get-Culture).datetimeformat.ShortDatePattern

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).date.toString()
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstDay

Specify the first day of the week. There is a potential bug in .NET Core where the detected first day of the week is incorrect. If that is true for your culture, use this parameter to manually specify the correct first day of the week.

```yaml
Type: DayOfWeek
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ([System.Globalization.CultureInfo]::CurrentCulture).DateTimeFormat.FirstDayOfWeek
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoANSI

Do not use any ANSI formatting. The output will be plain-text. This also means that the current day and highlight dates will not be reflected in the output. This parameter has no affect when running the command in the PowerShell ISE. There is no color formatting when using this host.

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

### -MonthOnly

Do not show any leading or trailing days from other months.

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

### CommonParameters.

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

[Get-NCalendar](Get-NCalendar.md)
