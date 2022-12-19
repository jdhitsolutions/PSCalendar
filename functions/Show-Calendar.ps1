Function Show-Calendar {
    [cmdletbinding()]
    [Alias("scal")]
    [OutputType("None")]

    Param(
        [Parameter(Position = 1, ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [ValidateScript( {
                $names = _getMonthsByCulture
                if ($names -contains $_) {
                    $True
                }
                else {
                    Throw "You entered an invalid month. Valid choices are $($names -join ',')"
                    $False
                }
            })]
        [string]$Month = (Get-Date -Format MMMM),

        [Parameter(Position = 2, ParameterSetName = "month")]
        [ValidatePattern('^\d{4}$')]
        [int]$Year = (Get-Date).Year,

        [string[]]$HighlightDate,

        [Parameter(HelpMessage = "Specify the first day of the week.")]
        [ValidateNotNullOrEmpty()]
        [System.DayOfWeek]$FirstDay = ([System.Globalization.CultureInfo]::CurrentCulture).DateTimeFormat.FirstDayOfWeek,

        [Parameter(HelpMessage = "Specify a host position. This only works with a single month.",ParameterSetName = "month")]
        [System.Management.Automation.Host.Coordinates]$Position,

        [Parameter(HelpMessage = "Do not show any leading or trailing days.")]
        [switch]$MonthOnly,

        [Parameter(Mandatory, HelpMessage = "Enter a year between 1000 and 3000 to display in calendar view.", ParameterSetName = "calyear")]
        [ValidateRange(1000,3000)]
        [int]$CalendarYear
    )

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    Write-Verbose "Detected parameter set $($pscmdlet.ParameterSetName)"
    #get culture to see how long the first day of week is
    #$currCulture = [system.globalization.cultureinfo]::CurrentCulture
    if ($position) {
        Write-Verbose "Using position $position"
        $here = $host.ui.RawUI.CursorPosition
        Write-Verbose "Saving current cursor location $here"
        [void]$PSBoundParameters.remove("Position")
    }

    if ($pscmdlet.ParameterSetName -ne "calyear") {
        #add default values if not bound
        $params = "Month", "Year", "FirstDay"
        foreach ($param in $params) {
            if (-not $PSBoundParameters.ContainsKey($param)) {
                Write-Verbose "Adding parameter $param"
                $PSBoundParameters.Add($param, $((Get-Variable -Name $param).value))
            }
        }
    }

    if ($host.name -Match "ISE Host") {
        #enforce NoAnsi when running in the PowerShell ISE. Issue #30
        Write-Verbose "ISE detected. Enforcing NoAnsi."
        $PSBoundParameters.Add("NoAnsi",$True)
    }
    $cal = Get-Calendar @PSBoundParameters

    if ($Position) {
        Write-Verbose "Displaying calendar at position $position"
        #turn the calendar into an array of lines
        $calArray = $cal.split("`n")
        foreach ($line in $calArray) {
            $host.ui.RawUI.CursorPosition = $Position
            Write-Host $line
            $position.y++
        }
        #set cursor position back
        $host.ui.RawUI.CursorPosition = $here
    }
    else {
        $cal
    }

    Write-Verbose "Ending $($myinvocation.mycommand)"

}
