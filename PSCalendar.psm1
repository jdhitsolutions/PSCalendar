#requires -version 5.1

#region main code

#dot source the calendar functions
. $PSScriptRoot\calendar-functions.ps1

#define an auto completer for the Month parameter
Register-ArgumentCompleter -CommandName Get-Calendar, Show-Calendar -ParameterName Month -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #get month names, filtering out blanks
    (Get-Culture).DateTimeFormat.MonthNames | Where-object {$_ -match "\w+" -and $_ -match "$WordToComplete"} |
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


#endregion

