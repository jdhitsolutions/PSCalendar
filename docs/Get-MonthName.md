---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: https://jdhitsolutions.com/yourls/c6dbeb
schema: 2.0.0
---

# Get-MonthName

## SYNOPSIS

Get the list of month names.

## SYNTAX

```yaml
Get-MonthName [-Short] [<CommonParameters>]
```

## DESCRIPTION

This command will return a list of month names according to your current culture.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-MonthName
January
February
March
April
May
June
July
August
September
October
November
December
```

Get the standard list of month names.

### Example 2

```powershell
PS C:\> Get-MonthName -Short
Jan
Feb
Mar
Apr
May
Jun
Jul
Aug
Sep
Oct
Nov
Dec
```

Get the list of short month names.

## PARAMETERS

### -Short

Get short month names.

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

[Get-Culture]()
