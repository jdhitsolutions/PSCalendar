# Change Log for PSCalendar

## v1.7.0

+ More changes to better handle culture in `Get-Calendar` (Issue #9)
+ Added more verbose messages to `Get-Calendar`
+ Added missing `gcal` alias for `Show-GuiCalendar`
+ Revised Pester tests
+ Updated `README.md`

## v1.6.0

+ Fixing date parsing bug for different cultures (Issue #9)
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

+ Added parameters to `Show-Calendar` to let user specify colors. (Issue #4)
+ Fixed highlight display bug in `Get-Calendar` (Issue #8)
+ Fixed DisplayMode bug in `Show-GuiCalendar`
+ Modified `Show-GuiCalendar` to not display in the taskbar
+ Added Pester tests to the module
+ Updated documentation

## v1.3.1

+ Help documentation updates for clarity (Issue #5)
+ Fixed HighLightDay parsing bug (Issue #6)

## v1.3.0

+ Added WPF calendar function `Show-GuiCalendar` (Issue #3)
+ Added alias `gcal` for `Show-GuiCalendar`
+ Added parameter validation to `-End` to make sure it is after `-Start`
+ Updated `README.md`

## v1.2.0

+ Added validation for `-Month` (Issue #1)
+ Made `-Year` a positional parameter in the 2nd position
+ some minor code cleanup
+ Added a private helper function to enumerate month names (Issue #2)

## v1.1.0

+ Fixed dot sourcing of calendar functions script.
+ Updated `README.md`
+ Verified functionality on PowerShell Core
+ Published to the PowerShell Gallery

## v1.0.0

+ Initial module code
