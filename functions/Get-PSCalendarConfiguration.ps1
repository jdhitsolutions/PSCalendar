Function Get-PSCalendarConfiguration {
    [cmdletbinding()]
    [outputType("PSCalendarConfiguration")]
    Param()

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    if ($IsCoreCLR) {
        $e = '`e'
    }
    else {
        $e = '$([Char]0x1b)'
    }

    [pscustomobject]@{
        PSTypeName = "PSCalendarConfiguration"
        Title      = "$($pscalendarConfiguration.title){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Title.ToCharArray() | Select-Object -Skip 1 ) -join "")
        DayofWeek  = "$($pscalendarConfiguration.DayOfWeek){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.DayOfWeek.ToCharArray() | Select-Object -Skip 1 ) -join "")
        Today      = "$($pscalendarConfiguration.Today){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Today.ToCharArray() | Select-Object -Skip 1 ) -join "")
        Highlight  = "$($pscalendarConfiguration.highlight){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Highlight.ToCharArray() | Select-Object -Skip 1 ) -join "")
    }
    Write-Verbose "Ending $($myinvocation.mycommand)"
}
