# Change Log for PSCalendar

## v2.1.0

+ Updated license.txt
+ Updated module commands to better handle datetime values when running under different cultures. Many parameters are now being treated as strings so they can be properly converted. [Issue #22](https://github.com/jdhitsolutions/PSCalendar/issues/22).
+ Updated private function that generates function to display enough weeks to complete a month. [Issue #21](https://github.com/jdhitsolutions/PSCalendar/issues/21).
+ Updated help files.
+ Updated `README.md`.

## v2.0.0

__This is a major update of the module with many breaking changes__

+ Complete re-write of `Get-Calendar` that now uses to ANSI escape sequences for coloring and highlighting. [Issue #17](https://github.com/jdhitsolutions/PSCalendar/issues/17).
+ Fixed issue with double-highlighting of the current day when it was found twice. (Issue #20)
+ Removed obsolete parameters from `Show-Calendar`.
+ Module reorganization to better handle non-Windows platforms. Platform-specific commands and aliases are exported in `PSCalendar.psm1`.(Issue #18)
+ Added the option to change ANSI formatting via a module-scoped hashtable. `Get-PSCalendarConfiguration` will show the current settings. `Set-PSCalendarConfiguration` will let the user modify them.
+ Created a format file, `pscalendarconfiguration.format.ps1xml`, to display the formatting values as a list.
+ Updated `README.md`.

## v1.11.0

+ Add `ThreadJob` as a required module. [Issue #19](https://github.com/jdhitsolutions/PSCalendar/issues/19)

## v1.10.0

+ Fixed cursor positioning in `Show-Calendar`
+ Refreshed some of the help examples
+ Updated `README.md`

## v1.9.0

+ Modified manifest to export all public functions and aliases
+ Modified `Show-GuiCalendar` to attempt to load WPF libraries and display a warning if it can't. [Issue #13](https://github.com/jdhitsolutions/PSCalendar/issues/13)
+ Added a private helper function, `New-RunspaceCleanUpJob` to cleanup runspaces when using `Show-GuiCalendar`. Thanks to @oising for leading me down the right path. [Issue #12](https://github.com/jdhitsolutions/PSCalendar/issues/12)
+ Modified `Get-Calendar` and `Show-Calendar` to display better under different cultures. [Issue #11](https://github.com/jdhitsolutions/PSCalendar/issues/11)
+ Updated Pester tests

## v1.8.0

+ Modified commands to begin on the correct day of the week. [Issue #10](https://github.com/jdhitsolutions/PSCalendar/issues/10)
+ Switched to using .NET culture classes directly instead of `Get-Culture` for better international results
+ Corrected license file for GitHub
+ Code cleanup to replace `Out-Null` with `[void]`
+ Updated `Show-GuiCalendar` to fix a bug that prevented dates in the past from being properly displayed.
+ Updated help with online `bit.ly` links

## v1.7.0

+ More changes to better handle culture in `Get-Calendar` [Issue #9](https://github.com/jdhitsolutions/PSCalendar/issues/9)
+ Added more verbose messages to `Get-Calendar`
+ Added missing `gcal` alias for `Show-GuiCalendar`
+ Revised Pester tests
+ Updated `README.md`

## v1.6.0

+ Fixing date parsing bug for different cultures [Issue #9](https://github.com/jdhitsolutions/PSCalendar/issues/9)
+ Manifest updates to better accommodate PowerShell Core and Windows PowerShell
+ Updated `README.md`

## v1.5.1

+ Modified `Show-Calendar` to use a different highlight color for today.
+ Updated help
+ Updated `README.md`

## v1.5.0

+ Modified `Show-Calendar` to allow you to specify a position in the console.
+ Help updates
+ Updated `README.md`
+ Minor changes to the Pester test

## v1.4.0

+ Added parameters to `Show-Calendar` to let the user specify colors. [Issue #4](https://github.com/jdhitsolutions/PSCalendar/issues/4)
+ Fixed highlight display bug in `Get-Calendar` [Issue #8](https://github.com/jdhitsolutions/PSCalendar/issues/8)
+ Fixed DisplayMode bug in `Show-GuiCalendar`
+ Modified `Show-GuiCalendar` to not display in the taskbar
+ Added Pester tests to the module
+ Updated documentation

## v1.3.1

+ Help documentation updates for clarity [Issue #5](https://github.com/jdhitsolutions/PSCalendar/issues/5)
+ Fixed HighLightDay parsing bug [Issue #6](https://github.com/jdhitsolutions/PSCalendar/issues/6)

## v1.3.0

+ Added WPF calendar function `Show-GuiCalendar` [Issue #3](https://github.com/jdhitsolutions/PSCalendar/issues/3)
+ Added alias `gcal` for `Show-GuiCalendar`
+ Added parameter validation to `-End` to make sure it is after `-Start`
+ Updated `README.md`

## v1.2.0

+ Added validation for `-Month` [Issue #1](https://github.com/jdhitsolutions/PSCalendar/issues/1)
+ Made `-Year` a positional parameter in the 2nd position
+ some minor code cleanup
+ Added a private helper function to enumerate month names [Issue #2](https://github.com/jdhitsolutions/PSCalendar/issues/2)

## v1.1.0

+ Fixed dot sourcing of calendar functions script.
+ Updated `README.md`
+ Verified functionality on PowerShell Core
+ Published to the PowerShell Gallery

## v1.0.0

+ Initial module code
