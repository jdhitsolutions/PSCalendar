
#dot source the calendar functions
. $PSScriptRoot\functions\private.ps1
. $PSScriptRoot\functions\public.ps1

#define a hashtable of ANSI escapes to use in the calendar
if ($IsCoreCLR) {
    $esc = "`e"
}
else {
    $esc = [Char]0x1b
}

$PSCalendarConfiguration = @{
    Title     = "$esc[38;5;3m"
    DayOfWeek = "$esc[1;4;36m"
    Today     = "$esc[91m"
    Highlight = "$esc[92m"
}


#define an auto completer for the Month parameter
Register-ArgumentCompleter -CommandName Get-Calendar, Show-Calendar -ParameterName Month -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #get month names, filtering out blanks
    [system.globalization.cultureinfo]::CurrentCulture.dateTimeFormat.monthnames | Where-Object { $_ -match "\w+" -and $_ -match "$WordToComplete" } |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.Trim(), $_.Trim(), 'ParameterValue', $_)
    }
}

#define an auto completer for the Year parameter
Register-ArgumentCompleter -CommandName Get-Calendar, Show-Calendar -ParameterName Year -ScriptBlock {
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
    Export-ModuleMember -Function 'Get-Calendar', 'Show-Calendar', 'Show-GuiCalendar', 'Get-PSCalendarConfiguration', 'Set-PSCalendarConfiguration' -Alias 'cal', 'scal', 'gcal'
}
else {
    Export-ModuleMember -Function 'Get-Calendar', 'Show-Calendar', 'Get-PSCalendarConfiguration', 'Set-PSCalendarConfiguration' -Alias scal
}