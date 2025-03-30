Function Get-PSCalendarConfiguration {
    [cmdletbinding()]
    [OutputType("PSCalendarConfiguration")]
    Param()

    Write-Verbose "Starting: $($MyInvocation.MyCommand) [v$modVer]"
    if ($MyInvocation.CommandOrigin -eq 'Runspace') {
        #Hide this metadata when the command is called from another command
        Write-Verbose "Using PowerShell version: $($PSVersionTable.PSVersion)"
        Write-Verbose "Running in PowerShell host: $($host.name)"
    }

    if ($IsCoreCLR) {
        $e = '`e'
    }
    else {
        $e = '$([Char]0x1b)'
    }

    [PSCustomObject]@{
        PSTypeName = "PSCalendarConfiguration"
        Title      = "$($pscalendarConfiguration.title){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Title.ToCharArray() | Select-Object -Skip 1 ) -join "")
        DayOfWeek  = "$($pscalendarConfiguration.DayOfWeek){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.DayOfWeek.ToCharArray() | Select-Object -Skip 1 ) -join "")
        Today      = "$($pscalendarConfiguration.Today){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Today.ToCharArray() | Select-Object -Skip 1 ) -join "")
        Highlight  = "$($pscalendarConfiguration.highlight){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Highlight.ToCharArray() | Select-Object -Skip 1 ) -join "")
    }
    Write-Verbose "Ending: $($MyInvocation.MyCommand)"
}
