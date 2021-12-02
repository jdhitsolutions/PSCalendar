Function Show-PSCalendarHelp {
    [cmdletbinding()]
    param()

    Start-process $PSScriptRoot\PSCalendarManual.pdf
}
