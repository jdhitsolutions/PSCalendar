# PSCalendar

[![PSGallery Version](https://img.shields.io/powershellgallery/v/PSCalendar.png?style=for-the-badge&logo=powershell&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/PSCalendar/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/PSCalendar.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/PSCalendar/)

This module contains a few functions for displaying a calendar in the PowerShell console. The primary function is based on code originally published by Lee Holmes at [http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/](http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/)
.

You can install this module from the PowerShell Gallery.

```powershell
Install-Module PSCalendar [-scope currentuser]
```

It has been tested on PowerShell Core both under Windows and Linux and there is no reason these commands should not work, except for [Show-GuiCalendar](docs/Show-GuiCalendar.md).

## [Get-Calendar](docs/Get-Calendar.md)

The commands in this module have been updated to take advantage of new features in Windows PowerShell. The main function, [Get-Calendar](docs/Get-Calendar.md), will display the current month in the console, highlighting the current date with asterisks.

![get-calendar](assets/get-calendar.png)

But you can also specify a calendar by month and year.

![get calendar by month](assets/get-calendar-2.png)

In this example you can see that I specified dates to highlight. Or you can specify a range of months.

![get calendar range](assets/get-calendar-3.png)

The function should be culturally aware. The commands in this module that have a `-Month` parameter should autocomplete to culture specific month names.

![autocomplete months](assets/autocomplete-month.png)

There is a similar autocompletion for `-Year` that begins with the current year and then the next 5 years. Although nothing prevents you from entering any year you want.

## [Show-Calendar](docs/Show-Calendar.md)

The module also contains a command to write a colorized version of the calendar to the console host. Whereas `Get-Calendar` writes a string to the pipeline, `Show-Calendar` writes directly to the host using `Write-Host`.

![show-calendar](assets/show-calendar.png)

This command is in essence a "wrapper" function for `Get-Calendar`.

![show calendar with highlights](assets/show-calendar-2.png)

*Note: Starting with version 1.5.1, the current day will be highlighted in Red, although you can modify that via the TodayColor parameter. I did not update the screen shots.*

## [Show-GUICalendar](docs/Show-GuiCalendar)

Finally, you can display a graphical calendar using a Windows Presentation Foundation (WPF) based script. The function runs the calendar-related code in a runspace so it does not block your prompt. You can display up to 3 months and specify dates to highlight.

```powershell
PS C:\> Show-GuiCalendar 12/2018 2/2019 -highlight 12/24/18,12/25/18,12/31/18,1/1/19,1/18/19,2/14/19,2/22/19
```

![show-guicalendar](assets/show-guicalendar.png)

The calendar form is transparent. But you should be able to click on it to drag it around your screen. You can also use the + and - keys to increase or decrease the calendar's opacity. Be aware that if you close the PowerShell session that launched the calendar, the calendar too will close.

This function requires the WPF-related assemblies. It should work in Windows PowerShell. For PowerShell Core and later it might or might not work depending on your platform. You will receive a warning if any incompatibility is detected.

## Potential Issues

I have tried to make this module culture aware. Testing across cultures is not an easy process. If you encounter a problem and are not running PowerShell under the EN-US culture, run the command you are trying to use with -Verbose and post the results in a new issue.

last updated 2019-11-08 19:17:27Z UTC
