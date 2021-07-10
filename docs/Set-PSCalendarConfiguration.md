---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: https://bit.ly/2Vli4uJ
schema: 2.0.0
---

# Set-PSCalendarConfiguration

## SYNOPSIS

Modify the PSCalendar ANSI configuration.

## SYNTAX

```yaml
Set-PSCalendarConfiguration [[-Title] <String>] [[-DayOfWeek] <String>]
[[-Today] <String>] [[-Highlight] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Get-Calendar and Show-Calendar commands use ANSI escape sequences to colorize the output. Get-PSCalendarConfiguration will display the current settings. You can use Set-PSCalendarConfiguration to modify the settings. You will need to include the escape sequence appropriate for your PowerShell version. You do not need to include the closing escape sequence. If you are looking for suggestions, take a look at Get-PSReadlineOption.

Any configuration changes you make are only for the duration of your PowerShell session. If you want to make them more permanent, you can add Set-PSCalendarConfiguration commands to your PowerShell profile.

## EXAMPLES

### Example 1

```powershell
PS C:\>  Set-PSCalendarConfiguration -title "$([char]0x1b)[48;5;57m"
```

Change the title color scheme on Windows 5.1. Although, this would also work in PowerShell 7.

### Example 2

```powershell
PS C:\>  Set-PSCalendarConfiguration -DayOfWeek "$([char]0x1b)[48;5;57m"
```

Change the week day headings color scheme on PowerShell 7.x.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfWeek

Specify an ANSI sequence for the day of the week heading.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Highlight

Specify the ANSI escape sequence to highlight specified dates.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title

Specify the ANSI escape sequence for the calendar title which will be the month and year.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Today

Specify the ANSI escape sequence to highlight the current day.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### None

## NOTES

## RELATED LINKS

[Get-PSCalendarConfiguration](Get-PSCalendarConfiguration.md)
