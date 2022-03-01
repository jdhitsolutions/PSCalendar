Function Get-Calendar {
    [cmdletbinding(DefaultParameterSetName = "month")]
    [OutputType([System.String])]
    [Alias("cal")]

    Param(
        [Parameter(Position = 1, ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [ValidateScript({
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

        [Parameter(Mandatory, HelpMessage = "Enter the start of a month like 1/1/2020 that is correct for your culture.", ParameterSetName = "span")]
        [ValidateNotNullOrEmpty()]
        [string]$Start,

        [Parameter(Mandatory, HelpMessage = "Enter an ending date for the month like 3/1/2020 that is correct for your culture.", ParameterSetName = "span")]
        [ValidateNotNullOrEmpty()]
        [string]$End,

        [Parameter(HelpMessage = "Specify a collection of dates to highlight in the calendar display.")]
        [ValidateNotNullorEmpty()]
        [string[]]$HighlightDate,

        [Parameter(HelpMessage = "Specify the first day of the week.")]
        [ValidateNotNullOrEmpty()]
        [System.DayOfWeek]$FirstDay = ([System.Globalization.CultureInfo]::CurrentCulture).DateTimeFormat.FirstDayOfWeek,

        [Parameter(HelpMessage = "Do not use any ANSI formatting.")]
        [switch]$NoANSI,

        [Parameter(HelpMessage = "Do not show any leading or trailing days.")]
        [switch]$MonthOnly
    )

    Begin {
        #display the module version defined in the psm1 file
        Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
        Write-Verbose "Using PowerShell version $($psversiontable.PSVersion)"
        #Call .NET for better results when testing this command in different cultures
        $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    }
    Process {
        Write-Verbose "Using parameter set: $($pscmdlet.ParameterSetName)"

        #validate $End Issue #26
        if ($PSCmdlet.ParameterSetName -eq 'span') {
            if ( [datetime]$end -lt [datetime]$Start) {
                Write-Verbose "Validating End ($end) compared to Start ($Start)"
                Throw "[Validation Error] The end date ($end) must be later than the start date ($start)"
            }
        }
        Write-Verbose "Using culture: $($currculture.displayname) [$($currCulture.name)]"
        Write-Verbose "Using PSBoundParameters:"
        Write-Verbose ($PSBoundParameters | Out-String).trim()
        Write-Verbose "Getting start date using pattern $($currCulture.DateTimeFormat.ShortDatePattern)"

        if ($pscmdlet.ParameterSetName -eq "month") {
            Write-Verbose "Using month $month and year $year"

            #get month number
            Write-Verbose "Parsing $month to number"
            $monthint = [datetime]::parse("1 $month $year").month
            Write-Verbose "Returned month number $monthint"
            $startd = [datetime]::new($year, $monthint, 1)
            $endd = $startd.date
        }
        else {
            #Figure out the first day of the start and end months
            # Write-Verbose "Calculating start from month $($start.month) year $($start.year)"
            # $start = [datetime]::new($start.year, $start.Month, 1)
            Write-Verbose "Treating $start as [datetime]"
            $startd = $start -as [datetime]
            # Write-Verbose "Calculating end from month $($end.month) year $($end.year)"
            # $end = [datetime]::new($end.year, $end.month, 1)
            Write-Verbose "Treating $end as [datetime]"
            $endd = $end -as [datetime]
        }

        Write-Verbose "Starting at $($startd.toString())"
        Write-Verbose "Ending at $($Endd.ToString())"

        #$highstring = $HighlightDate.foreach({$_.ToString()})
        Write-Verbose "Highlighting: $($highlightdate-join ',')"

        Write-Verbose "Go through the requested months."
        while ($startd -le $endd) {
            Write-Verbose "Looping from $($startd.DateTime)"
            $paramHash = @{
                start          = $Startd
                highlightDates = $highlightDate
                firstday       = $FirstDay
                noAnsi         = $NoANSI
                monthOnly      = $monthOnly
            }

            #enforce NoAnsi if running in the PowerShell ISE [Issue #30]
            if ($host.name -Match "ISE Host") {
                $paramHash.NoAnsi = $True
            }
            _getCalendar @paramHash

            #And now move onto the next month
            $startd = $startd.AddMonths(1)
        }
    } #process

    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}
