Function Show-PSCalendarHelp {
    [cmdletbinding()]
    param(
        [Parameter(HelpMessage = 'Opens the PSCalendar README file in the Github repository.')]
        [switch]$Online
    )

    Write-Verbose "Starting: $($MyInvocation.MyCommand) [v$modVer]"
    Write-Verbose "Using PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Verbose "Running in PowerShell host: $($host.name)"

    Write-Verbose "Using culture: $($currCulture.DisplayName) [$($currCulture.name)]"

    if ($Online) {
        $helpPath = 'https://github.com/jdhitsolutions/PSCalendar/blob/main/README.md'
        Write-Verbose "Opening online help $helpPath"
    }
    else {
        $helpPath = $(Resolve-Path $PSScriptRoot\..\PSCalendarManual.pdf)
        Write-Verbose "Opening local file $helpPath"
    }
    Try {
        Start-Process $helpPath -ErrorAction Stop
    }
    Catch {
        Write-Error "Unable to open the PSCalendar manual. $($_.Exception.Message)"
    }
    Write-Verbose "Ending: $($MyInvocation.MyCommand)"
}
