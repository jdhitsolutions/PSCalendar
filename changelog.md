# Change Log for PSCalendar

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
