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
Show-Calendar [[-Month] <String>] [[-Year] <Int32>] [-HighlightDate <String[]>]
 [-HighlightColor <ConsoleColor>] [-TitleColor <ConsoleColor>] [-DayColor <ConsoleColor>]
 [-TodayColor <ConsoleColor>] [-Position <Coordinates>] [<CommonParameters>]
```

## DESCRIPTION

This command is a wrapper for Get-Calendar that will display the specified month in a colorized format. The command uses Write-Host so it does not write anything to the pipeline.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Show-Calendar
```

Display a colorized version of the current month. The current day will also be colorized.

### EXAMPLE 2

```powershell
PS C:\> Show-Calendar -Month February -Year 2020 -HighlightDate 2/22/20 -HighlightColor red
```

Display February 2020 and highlight the 22nd in red.

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

Specific days (named) to highlight. These dates are surrounded by asterisk characters.

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

### -HighlightColor

Specify a console color to use for the highlighted dates.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:
Accepted values: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

Required: False
Position: Named
Default value: Green
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayColor

Specify a color for the days of the week heading.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Cyan
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

### -TitleColor

Specify a color for the days of the month heading.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Yellow
Accept pipeline input: False
Accept wildcard characters: False
```

### -TodayColor

Specify a color to mark today.

```yaml
Type: ConsoleColor
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Red
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

This command should have an alias of scal. It writes to the PowerShell hosting application not to the PowerShell pipeline.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Calendar]()

[Show-GuiCalendar]()
