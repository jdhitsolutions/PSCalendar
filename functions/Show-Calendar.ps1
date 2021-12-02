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

        [System.Management.Automation.Host.Coordinates]$Position
    )

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"

    #get culture to see how long the first day of week is
    #$currCulture = [system.globalization.cultureinfo]::CurrentCulture
    if ($position) {
        #save current cursor location
        $here = $host.ui.RawUI.CursorPosition
        [void]$PSBoundParameters.remove("Position")
    }

    #add default values if not bound
    $params = "Month", "Year", "FirstDay"
    foreach ($param in $params) {
        if (-not $PSBoundParameters.ContainsKey($param)) {
            $PSBoundParameters.Add($param, $((Get-Variable -Name $param).value))
        }
    }

    $cal = Get-Calendar @PSBoundParameters

    if ($Position) {
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
