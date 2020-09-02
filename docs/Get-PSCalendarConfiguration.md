---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: https://github.com/jdhitsolutions/PSCalendar/blob/master/docs/Get-PSCalendarConfiguration.md
schema: 2.0.0
---

# Get-PSCalendarConfiguration

## SYNOPSIS

Get the current PSCalendar ANSI configuration.

## SYNTAX

```yaml
Get-PSCalendarConfiguration [<CommonParameters>]
```

## DESCRIPTION

Get-Calendar and Show-Calendar commands rely on ANSI escape sequences to colorize the output. You can use this command to view the current settings. The settings will use an appropriate escape character based on your PowerShell version. Use Set-PSCalendarConfiguration to modify the settings.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSCalendarConfiguration

Title     : `e[38;5;3m
DayOfWeek : `e[1;4;36m
Today     : `e[91m
Highlight : `e[92m
```

The display will be formatted with the corresponding ANSI escape sequence. The escape character, will reflect your current PowerShell version.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSCalendarConfiguration

## NOTES

## RELATED LINKS

[Set-PSCalendarConfiguration](Set-PSCalendarConfiguration.md)
