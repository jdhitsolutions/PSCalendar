
#functions in this module are based on code from Lee Holmes
# http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

#dot source the calendar functions
Get-ChildItem $PSScriptRoot\functions\*.ps1 -Exclude dev*.ps1 |
ForEach-Object {
    . $_.FullName
}

#define a hashtable of ANSI escapes to use in the calendar
if ($IsCoreCLR) {
    $esc = "`e"
}
else {
    $esc = [Char]27
}

#define the path to the configuration file
$configPrefPath = Join-Path $env:USERPROFILE '.pscalendarConfiguration.json'
If (Test-Path -Path $configPrefPath) {
    $in = Get-Content $configPrefPath | ConvertFrom-Json
    $PSCalendarConfiguration = @{
        Title     = $in.Title
        DayOfWeek = $in.DayOfWeek
        Today     = $in.Today
        Highlight = $in.Highlight
    }
}
else {
    $PSCalendarConfiguration = @{
        Title     = "$esc[38;5;3m"
        DayOfWeek = "$esc[1;4;36m"
        Today     = "$esc[91m"
        Highlight = "$esc[92m"
    }
}

#define an auto completer for the Month parameter
Register-ArgumentCompleter -CommandName Get-Calendar, Show-Calendar, Get-NCalendar -ParameterName Month -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #get month names, filtering out blanks
    [System.Globalization.CultureInfo]::CurrentCulture.DateTimeFormat.MonthNames |
    Where-Object { $_ -match '\w+' -and $_ -Like "$WordToComplete*" } |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.Trim(), $_.Trim(), 'ParameterValue', $_)
    }
}

#define an auto completer for the Year parameter
Register-ArgumentCompleter -CommandName Get-Calendar, Show-Calendar, Get-NCalendar -ParameterName Year -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $first = (Get-Date).Year
    $last = (Get-Date).AddYears(5).Year
    $first..$last |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

#Export appropriate module members based on whether the user is running Windows or not.
If ($IsWindows -OR ($PSEdition -eq 'Desktop')) {
    #define an AutoCompleter for background color
    Register-ArgumentCompleter -CommandName Show-GuiCalendar -ParameterName BackgroundColor -ScriptBlock {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

        Try {
            Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
            Add-Type -AssemblyName PresentationCore -ErrorAction Stop

            [System.Windows.Media.Brushes].GetProperties().Name |
            ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
        Catch {
            #if assemblies can't be loaded don't do anything
        }
    }
}


#use the version value in module functions' verbose output
$modName = Split-Path -Leaf $PSScriptRoot
$modVer = (Test-ModuleManifest $PSScriptRoot\$modName.psd1).Version