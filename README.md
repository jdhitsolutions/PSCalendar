# PSCalendar

This module contains a few functions for displaying a calendar in the PowerShell console. The primary function is based on code originally published by Lee Holmes at http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/
.

You can install this module from the PowerShell Gallery.

```powershell
Install-Module PSCalendar
```

## Get-Calendar

The commands in this module have been updated to take advantage of new features in Windows PowerShell. The main function, [Get-Calendar](), will display the current month in the console, highlighting the current date with asterisks.

![get-calendar](assets/get-calendar.png)

But you can also specify a calendar by month and year.

![get calendar by month](assets/get-calendar-2.png)

In this example you can see that I specified dates to highlight. Or you can specify a range of months.

![get calendar range](assets/get-calendar-3.png)

The function should be culturally aware. The commands in this module that have a `-Month` parameter should autocomplete to culture specific month names.

![autocomplete months](assets/autocomplete-month.png)

There is a similar autocompletion for `-Year` that begins with the current year and then the next 5 years. Although nothing prevents you from entering any year you want.

## Show-Calendar

The module also contains a command to write a colorized version of the calendar to the console host. Whereas `Get-Calendar` writes a string to the pipeline, `Show-Calendar` writes directly to the host using `Write-Host`.

![show-calendar](assets/show-calendar.png)

This command is in essence a "wrapper" function for `Get-Calendar`.

![show calendar with highlights](assets/show-calendar-2.png)

 *last updated 9/28/2018*
