---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version:
schema: 2.0.0
---

# Export-PSCalendarConfiguration

## SYNOPSIS

Save the current calendar configuration settings to a file.

## SYNTAX

```yaml
Export-PSCalendarConfiguration [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

If you have customized the calendar configuration settings, and which to alway use them, use this command to export the settings to a JSON file in $HOME. The next time you import the module, the settings will be automatically imported. If you want to revert to the default settings, delete the JSON file, $HOME\PSCalendarConfiguration.json. If you uninstall the module, you will need to manually delete the JSON file.

This command was added in module version 2.10.0

## EXAMPLES

### Example 1

```powershell
PS C:\> Export-PSCalendarConfiguration
```

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

### -Passthru

Show the configuration settings file.

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

### System.Io.FileInfo

## NOTES

This command has an alias of Save-PSCalendarConfiguration.

Learn more about PowerShell: https://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Get-PSCalendarConfiguration](./Get-PSCalendarConfiguration.md)

[Set-PSCalendarConfiguration](./Set-PSCalendarConfiguration.md)
