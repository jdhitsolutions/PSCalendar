Function Show-PSCalendarHelp {
    [cmdletbinding()]
    param()
    Write-Verbose "Opening $(Resolve-Path $PSScriptRoot\..\PSCalendarManual.pdf)"
    Start-Process $PSScriptRoot\..\PSCalendarManual.pdf
}
