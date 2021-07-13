---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: http://bit.ly/2KKKgzK
schema: 2.0.0
---

# Show-Calendar

## SYNOPSIS

Display a colorized calendar month in the console.

## SYNTAX

```yaml
Show-Calendar [[-Month] <String>] [[-Year] <Int32>] [-HighlightDate <String[]>] [-FirstDay <DayOfWeek>] [-Position <Coordinates>] [<CommonParameters>]
```

## DESCRIPTION

This command is a wrapper for Get-Calendar that essentially shows the same result. The only difference is that you can use Show-Calendar to display the calendar at a specific position in your PowerShell session. This function is also retained for backward compatibility.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Show-Calendar
```

Display a colorized version of the current month.

### EXAMPLE 2

```powershell
PS C:\> Show-Calendar -Month February -Year 2021 -HighlightDate 2/22/21
```

Display February 2021 and highlight the 22nd using the default highlight color.

### Example 3

```powershell
PS C:\> Show-Calendar  -Position ([system.management.automation.host.coordinates]::new(75,1))
```

Display the calendar at a specified X,Y position in the console. This parameter will probably not work in the PowerShell ISE.

## PARAMETERS

### -Month

Select a month to display. The command will default to the current year unless otherwise specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Current month
Accept pipeline input: False
Accept wildcard characters: False
```

### -Year

Select a year for the specified month.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: current year
Accept pipeline input: False
Accept wildcard characters: False
```

### -HighlightDate

Specify days to highlight. These dates are colored by ANSI escape sequences. You can modify them with Set-PSCalendarConfiguration. You must format the dates tpo match your culture. It should match the pattern you get from running this command: (Get-Culture).datetimeformat.ShortDatePattern

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Position

Enter a System.Management.Automation.Host.Coordinates object to specify a location for the calendar. This may not work properly in all hosts or PowerShell versions and you might need some trial and error to figure out a position that works for you.

```yaml
Type: Coordinates
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.String

## NOTES

This command should have an alias of scal.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Calendar](Get-Calendar.md)

[Show-GuiCalendar](Show-GuiCalendar.md)
