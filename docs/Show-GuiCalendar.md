---
external help file: PSCalendar-help.xml
Module Name: PSCalendar
online version: http://bit.ly/2KLup3R
schema: 2.0.0
---

# Show-GuiCalendar

## SYNOPSIS

Display a WPF-based calendar.

## SYNTAX

### basic (Default)

```yaml
Show-GuiCalendar [[-Start] <String>] [[-End] <String>]
[-HighlightDate <Object[]>] [-Font <String>] [-FontStyle <String>]
[-FontWeight <String>] [-FirstDay <DayOfWeek>] [<CommonParameters>]
```

### bgimage

```yaml
Show-GuiCalendar [[-Start] <String>] [[-End] <String>]
[-HighlightDate <Object[]>] [-Font <String>] [-FontStyle <String>]
[-FontWeight <String>] [-BackgroundImage <String>] [-Stretch <String>]
[-FirstDay <DayOfWeek>] [<CommonParameters>]
```

### bgcolor

```yaml
Show-GuiCalendar [[-Start] <String>] [[-End] <String>]
[-HighlightDate <Object[]>] [-Font <String>] [-FontStyle <String>]
[-FontWeight <String>] [-BackgroundColor <String>] [-FirstDay <DayOfWeek>]
[<CommonParameters>]
```

## DESCRIPTION

If you are running Windows PowerShell or a version of PowerShell that supports the [System.Windows.Media] .NET class, which does NOT include PowerShell 7, you can display a graphical calendar. You can specify up to 3 months. There are also parameters to fine-tune the calendar style. The calendar form itself is transparent, but you should be able to click on it to drag it around your screen. You can also use the + and - keys to increase or decrease the calendar's opacity. You may have to click on a calendar before making any adjustments.

This command launches the calendar in a separate runspace so that it doesn't block your prompt. However, if you close the PowerShell session that launched the calendar, the calendar will also automatically close.

You must format the dates to match your culture. It should match the pattern you get from running this command:

(Get-Culture).datetimeformat.ShortDatePattern

## EXAMPLES

### Example 1

```powershell
PS C:\> Show-GuiCalendar
```

Display the current month as a graphical calendar.

### Example 2

```powershell
PS C:\> Show-GuiCalendar -start 12/2020 -end 2/2021 -highlight 12/24/19,12/25/19,12/31/19,1/1/20,2/14/20 -font 'Century Gothic' -FontStyle italic
```

Display 3 months with selected dates highlighted and style the calendar to font settings.

### Example 3

```powershell
PS C:\> Show-GuiCalendar -fontweight bold -backgroundcolor Azure
```

Display the current month with a bold font and the specified background color.

### Example 4

```powershell
PS C:\> $h = @{"7/4/2021"="4th of July";"7/14/2021"="Bastille Day";"7/22/2021"="Family Visit"}
PS C:\> Show-GuiCalendar -start 7/1/2021 -backgroundimage c:\scripts\zazu.gif -highlightDate $h
```

Display July 2021 with a background image and use the hashtable of highlight dates. A highlight summary will be displayed as a tool tip for the month.

## PARAMETERS

### -End

Enter the last month to display by date, like 3/1/2020. You cannot display more than 3 months.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Current month
Accept pipeline input: False
Accept wildcard characters: False
```

### -Font

Select a font family for your calendar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Segoi UI, QuickType, Tahoma, Lucida Console, Century Gothic

Required: False
Position: Named
Default value: Segoi UI
Accept pipeline input: False
Accept wildcard characters: False
```

### -FontStyle

Select a font style for your calendar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Normal, Italic, Oblique

Required: False
Position: Named
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -FontWeight

Select a font weight for your calendar.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Normal, DemiBold, Light, Bold

Required: False
Position: Named
Default value: Normal
Accept pipeline input: False
Accept wildcard characters: False
```

### -HighlightDate

Enter an array of dates to highlight like 12/25/202,12/31/2020 or a hashtable where the key is the date and the value is a description. This data will be displayed as a tooltip for each month.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start

Enter the first month to display by date, like 1/1/2020.

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

### -BackgroundColor

Specify calendar background color. On Windows platforms you should be able to tab complete possible colors. Or you can use a color format like '#FFF000'. Remember to wrap this kind of value in quotes.

```yaml
Type: String
Parameter Sets: bgcolor
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundImage

Specify the path to an image to use as the background.

```yaml
Type: String
Parameter Sets: bgimage
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstDay

Specify the first day of the week. Normally, .NET should detect the first day of the week based on culture settings. But if for some reason, .NET is detecting incorrect information, you can manually set the first day of the week with this parameter.

```yaml
Type: DayOfWeek
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stretch

Specify image stretch setting. Possible values are None, Fill, Uniform, and UniformToFill

```yaml
Type: String
Parameter Sets: bgimage
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

### None

## NOTES

This function requires the WPF-related assemblies. It should work in Windows PowerShell and PowerShell 7 on Windows. You will receive a warning if any incompatibility is detected.

This command should have an alias of gcal.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Show-Calendar](Show-Calendar.md)

[Get-Calendar](Get-Calendar.md)
