# Change Log for PSCalendar

## [Unreleased]

## [2.10.1] - 2025-03-30

### Fixed

- Fixed bug in root module detecting the module name.

## [2.10.0] - 2025-03-30

### Added

- Added command `Export-PSCalendarConfiguration` with an alias of `Save-PSCalendarConfiguration` to allow the user to export and save calendar configuration values to a JSON file (`C:\Users\Jeff\.pscalendarConfiguration.json`). If this file is found during module import, the settings will be imported.
- Added parameter validation to `Set-PSCalendarConfiguration` to ensure parameter values are valid ANSI escape sequences.
- Added alias `mon` for `Get-MonthName`.
- Additional verbose messaging to functions.

### Changed

- Changed Verbose output in private functions to Debug.
- Modified `Get-Calendar` and `Show-Calendar` to display calendar quarters for a given year.
- Updated Pester tests to v5.
- Modified manifest to load all commands. Commands like `Show-GuiCalendar` that don't work on Linux or Mac will be handled on a per-command basis.
- Code cleanup.
- Help updates.
- Updated `README` and refreshed screenshots.
- Replaced references of the `ThreadJob` module tto `Microsoft.PowerShell.Threadjob`.
- Converted Changelog to new format.
- Moved git primary branch from `master` to `main`.

### Fixed

- Updated argument completers to be more specific.

## [v2.9.0] - 2022-12-19

- Updated `Get-Calendar` and `Show-Calendar` to fix empty trailing day when specifying a different first day of the week. [Issue #32](https://github.com/jdhitsolutions/PSCalendar/issues/32). Thanks again to [Matthew Gray](https://github.com/scriptingstudio) for code suggestion.
- Updated `_getCalendar` to use a generic list for the days instead of an array. This provides a slight performance benefit.
- Added a parameter called `CalendarYear` to display a full year calendar for `Get-Calendar` and `Show-Calendar`. [Issue #31](https://github.com/jdhitsolutions/PSCalendar/issues/31)
- Help updates.

## [v2.8.0] - 2022-03-01

- Updated `Get-Calendar` and `Show-Calendar` with a new parameter `MonthOnly` to only show days from the specified month. This will remove leading and trailing days from other months. [Issue #29](https://github.com/jdhitsolutions/PSCalendar/issues/29). Much thanks to [Matthew Gray](https://github.com/scriptingstudio) for the suggestions and code snippet.
- Updated `Get-Calendar`, `Show-Calendar`, and `Get-NCalendar` to suppress all ANSI formatting when running in the PowerShell ISE.  [Issue #30](https://github.com/jdhitsolutions/PSCalendar/issues/30)
- Moved `Show-PSCalendarHelp` to a separate file under Functions.
- Documentation updates.
- Updated `README.md`.
- Help updates.

## [v2.7.0] - 2021-12-02

- Updates to `Get-NCalendar` [Issue #25](https://github.com/jdhitsolutions/PSCalendar/issues/25). Much thanks to [atkinsroy](https://github.com/atkinsroy) for excellent suggestions and code examples.
- Restructured module layout.
- Updated Pester tests.
- Help updates.

## [v2.6.0] - 2021-11-17

- Updates to `Get-NCalendar` [Issue #25](https://github.com/jdhitsolutions/PSCalendar/issues/25).
- Exported `Get-MonthName` in the module manifest.
- Added missing online help links.
- Help updates.

## [v2.5.0] - 2021-11-10

- Updated commands to work in PowerShell 7.2. [Issue #28](https://github.com/jdhitsolutions/PSCalendar/issues/28).
- Updated online help link for `Show-PSCalendarHelp`.
- Help updates
- Module manifest clean up.
- Updated `README.md`.

## [v2.4.0] - 2021-11-03

- Add error handling to `Show-GUICalendar` to not run in PowerShell 7 since the underlying .NET display classes are not supported. Restructured module to not export this command if running in PowerShell 7. [Issue #27](https://github.com/jdhitsolutions/PSCalendar/issues/27)
- Updated `Show-PSCalendarHelp` to use a new PDF which includes `README.md` and the command help.
- Help updates
- Updated `README.md`.

## [v2.3.2] - 2021-11-02

- Updated `Get-Calendar` to allow start date and end date to be equal. [Issue #26](https://github.com/jdhitsolutions/PSCalendar/issues/26)

## [v2.3.1] - 2021-11-01

- Fixed alignment problem when first day of a row is highlighted in `Get-NCalendar`. [Issue #25](https://github.com/jdhitsolutions/PSCalendar/issues/25).
- Updated `Get-Calendar` to fix validation bug when the end date is less than the start date. [Issue #26](https://github.com/jdhitsolutions/PSCalendar/issues/26)

## [v2.3.0] - 2021-07-30

- Added `Get-PNCalendar` and its alias `ncal`. [Issue #16](https://github.com/jdhitsolutions/PSCalendar/issues/16).
- Added `Get-MonthName` function.
- Updated Pester tests.
- Updated help documentation.
- Updated `README.md`.

## [v2.2.0] - 2021-07-13

- Revised commands to let the user specify the first day of the week. There appears to be a bug in .NET Core that doesn't always return the correct first day of the week. Commands will default to this value, but I want to give a user an option to specify an alternate value if necessary. This is a continuation of work to resolve [Issue #21](https://github.com/jdhitsolutions/PSCalendar/issues/21).
- Modified `Show-GuiCalendar` to default to first day of current month. [Issue #23](https://github.com/jdhitsolutions/PSCalendar/issues/23).
- Updated `Show-GuiCalendar` to let the user specify a background image or color. [Issue #14](https://github.com/jdhitsolutions/PSCalendar/issues/14).
- Modified `Show-GuiCalendar` to let the user pass a hashtable of highlight date information so that a summary can be displayed as a tooltip. [Issue #7](https://github.com/jdhitsolutions/PSCalendar/issues/7).
- Modified `Get-Calendar` to support a no ANSI parameter. [Issue #24](https://github.com/jdhitsolutions/PSCalendar/issues/24).
- Added an argument completer for the `BackgroundColor` parameter of `Show-GuiCalendar` for Windows systems.
- Added `Show-PSCalendarHelp` which will open a local PDF version of the `README.md` file.
- Removed development code.
- Updated help files.
- Updated `README.md`.

## [v2.1.0] - 2021-07-10

- Updated license.txt
- Updated module commands to better handle DateTime values when running under different cultures. Many parameters are now being treated as strings so they can be properly converted. [Issue #22](https://github.com/jdhitsolutions/PSCalendar/issues/22).
- Updated private function that generates function to display enough weeks to complete a month. [Issue #21](https://github.com/jdhitsolutions/PSCalendar/issues/21).
- Updated help files.
- Updated `README.md`.

## [v2.0.0] - 2020-09-02

This is a major update of the module with many __breaking changes__

- Complete re-write of `Get-Calendar` that now uses to ANSI escape sequences for coloring and highlighting. [Issue #17](https://github.com/jdhitsolutions/PSCalendar/issues/17).
- Fixed issue with double-highlighting of the current day when it was found twice. (Issue #20)
- Removed obsolete parameters from `Show-Calendar`.
- Module reorganization to better handle non-Windows platforms. Platform-specific commands and aliases are exported in `PSCalendar.psm1`.(Issue #18)
- Added the option to change ANSI formatting via a module-scoped hashtable. `Get-PSCalendarConfiguration` will show the current settings. `Set-PSCalendarConfiguration` will let the user modify them.
- Created a format file, `pscalendarconfiguration.format.ps1xml`, to display the formatting values as a list.
- Updated `README.md`.

## [v1.11.0] - 2020-05-11

- Add `ThreadJob` as a required module. [Issue #19](https://github.com/jdhitsolutions/PSCalendar/issues/19)

## [v1.10.0] - 2020-01-30

- Fixed cursor positioning in `Show-Calendar`
- Refreshed some of the help examples
- Updated `README.md`

## [v1.9.0] - 2019-11-08

- Modified manifest to export all public functions and aliases
- Modified `Show-GuiCalendar` to attempt to load WPF libraries and display a warning if it can't. [Issue #13](https://github.com/jdhitsolutions/PSCalendar/issues/13)
- Added a private helper function, `New-RunspaceCleanUpJob` to cleanup runspaces when using `Show-GuiCalendar`. Thanks to @oising for leading me down the right path. [Issue #12](https://github.com/jdhitsolutions/PSCalendar/issues/12)
- Modified `Get-Calendar` and `Show-Calendar` to display better under different cultures. [Issue #11](https://github.com/jdhitsolutions/PSCalendar/issues/11)
- Updated Pester tests

## [v1.8.0] - 2019-08-21

- Modified commands to begin on the correct day of the week. [Issue #10](https://github.com/jdhitsolutions/PSCalendar/issues/10)
- Switched to using .NET culture classes directly instead of `Get-Culture` for better international results
- Corrected license file for GitHub
- Code cleanup to replace `Out-Null` with `[void]`
- Updated `Show-GuiCalendar` to fix a bug that prevented dates in the past from being properly displayed.
- Updated help with online `bit.ly` links

## [v1.7.0] - 2019-06-27

- More changes to better handle culture in `Get-Calendar` [Issue #9](https://github.com/jdhitsolutions/PSCalendar/issues/9)
- Added more verbose messages to `Get-Calendar`
- Added missing `gcal` alias for `Show-GuiCalendar`
- Revised Pester tests
- Updated `README.md`

## [v1.6.0] - 2019-03-15

- Fixing date parsing bug for different cultures [Issue #9](https://github.com/jdhitsolutions/PSCalendar/issues/9)
- Manifest updates to better accommodate PowerShell Core and Windows PowerShell
- Updated `README.md`

## [v1.5.1] - 2019-01-30

- Modified `Show-Calendar` to use a different highlight color for today.
- Updated help
- Updated `README.md`

## [v1.5.0] - 2019-01-10

- Modified `Show-Calendar` to allow you to specify a position in the console.
- Help updates
- Updated `README.md`
- Minor changes to the Pester test

## [v1.4.0] - 2018-10-23

- Added parameters to `Show-Calendar` to let the user specify colors. [Issue #4](https://github.com/jdhitsolutions/PSCalendar/issues/4)
- Fixed highlight display bug in `Get-Calendar` [Issue #8](https://github.com/jdhitsolutions/PSCalendar/issues/8)
- Fixed DisplayMode bug in `Show-GuiCalendar`
- Modified `Show-GuiCalendar` to not display in the taskbar
- Added Pester tests to the module
- Updated documentation

## [v1.3.1] - 2018-10-01

- Help documentation updates for clarity [Issue #5](https://github.com/jdhitsolutions/PSCalendar/issues/5)
- Fixed HighLightDay parsing bug [Issue #6](https://github.com/jdhitsolutions/PSCalendar/issues/6)

## [v1.3.0] - 2018-10-01

- Added WPF calendar function `Show-GuiCalendar` [Issue #3](https://github.com/jdhitsolutions/PSCalendar/issues/3)
- Added alias `gcal` for `Show-GuiCalendar`
- Added parameter validation to `-End` to make sure it is after `-Start`
- Updated `README.md`

## [v1.2.0] - 2018-09-28

- Added validation for `-Month` [Issue #1](https://github.com/jdhitsolutions/PSCalendar/issues/1)
- Made `-Year` a positional parameter in the 2nd position
- some minor code cleanup
- Added a private helper function to enumerate month names [Issue #2](https://github.com/jdhitsolutions/PSCalendar/issues/2)

## [v1.1.0] - 2018-09-28

- Fixed dot sourcing of calendar functions script.
- Updated `README.md`
- Verified functionality on PowerShell Core
- Published to the PowerShell Gallery

## v1.0.0

- Initial module code

[Unreleased]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.10.1..HEAD
[2.10.1]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.10.0..v2.10.1
[2.10.0]: https://github.com/jdhitsolutions/PSCalendar/compare/vv2.9.0..v2.10.0
[v2.9.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.8.0..v2.9.0
[v2.8.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.7.0..v2.8.0
[v2.7.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.6.0..v2.7.0
[v2.6.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.5.0..v2.6.0
[v2.5.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.4.0..v2.5.0
[v2.4.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.3.2..v2.4.0
[v2.3.2]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.3.1..v2.3.2
[v2.3.1]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.3.0..v2.3.1
[v2.3.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.2.0..v2.3.0
[v2.2.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.1.0..v2.2.0
[v2.1.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v2.0.0..v2.1.0
[v2.0.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.11.0..v2.0.0
[v1.11.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.10.0..v1.11.0
[v1.10.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.9.0..v1.10.0
[v1.9.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.8.0..v1.9.0
[v1.8.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.7.0..v1.8.0
[v1.7.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.6.0..v1.7.0
[v1.6.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.5.1..v1.6.0
[v1.5.1]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.5.0..v1.5.1
[v1.5.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.4.0..v1.5.0
[v1.4.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.3.1..v1.4.0
[v1.3.1]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.3.0..v1.3.1
[v1.3.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.2.0..v1.3.0
[v1.2.0]: https://github.com/jdhitsolutions/PSCalendar/compare/v1.1.0..v1.2.0