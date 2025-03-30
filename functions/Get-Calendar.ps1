Function Get-Calendar {
    [cmdletbinding(DefaultParameterSetName = "month")]
    [OutputType([System.String])]
    [Alias("cal")]

    Param(
        [Parameter(Position = 0, ParameterSetName = "month")]
        [ValidateNotNullOrEmpty()]
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

        [Parameter(
            Mandatory,
            Position = 0,
            ParameterSetName = "quarter",
            HelpMessage = "Specify a calendar year quarter to display."
        )]
        [ValidateRange(1,4)]
        [int]$Quarter,

        [Parameter(Position = 1,ParameterSetName = "month")]
        [Parameter(Position = 1,ParameterSetName = "quarter")]
        [ValidatePattern('^\d{4}$')]
        [int]$Year = (Get-Date).Year,

        [Parameter(
            Mandatory,
            HelpMessage = "Enter the start of a month like 1/1/2020 that is correct for your culture.",
            ParameterSetName = "span"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Start,

        [Parameter(
            Mandatory,
            HelpMessage = "Enter an ending date for the month like 3/1/2020 that is correct for your culture.",
            ParameterSetName = "span"
            )]
        [ValidateNotNullOrEmpty()]
        [string]$End,

        [Parameter(HelpMessage = "Specify a collection of dates to highlight in the calendar display.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$HighLightDate,

        [Parameter(HelpMessage = "Specify the first day of the week.")]
        [ValidateNotNullOrEmpty()]
        [System.DayOfWeek]$FirstDay = ([System.Globalization.CultureInfo]::CurrentCulture).DateTimeFormat.FirstDayOfWeek,

        [Parameter(HelpMessage = "Do not use any ANSI formatting.")]
        [switch]$NoANSI,

        [Parameter(HelpMessage = "Do not show any leading or trailing days.")]
        [switch]$MonthOnly,

        [Parameter(
            Mandatory,
            HelpMessage = "Enter a year between 1000 and 3000 to display in calendar view.",
            ParameterSetName = "calyear"
        )]
        [ValidateRange(1000,3000)]
        [int]$CalendarYear
    )

    Begin {
        #display the module version defined in the psm1 file
        Write-Verbose "Starting: $($MyInvocation.MyCommand) [v$modVer]"
        Write-Verbose "Using PowerShell version: $($PSVersionTable.PSVersion)"
        Write-Verbose "Running in PowerShell host: $($host.name)"
        #Call .NET for better results when testing this command in different cultures
        $currCulture = [System.Globalization.CultureInfo]::CurrentCulture
        Write-Verbose "Using culture: $($currCulture.DisplayName) [$($currCulture.name)]"
    }
    Process {
        Write-Verbose "Using parameter set: $($PSCmdlet.ParameterSetName)"
        Write-Verbose "Getting start date using pattern $($currCulture.DateTimeFormat.ShortDatePattern)"

        #validate $End Issue #26
        if ($PSCmdlet.ParameterSetName -eq 'span') {
            if ( [DateTime]$end -lt [DateTime]$Start) {
                Write-Verbose "Validating End ($end) compared to Start ($Start)"
                Throw "[Validation Error] The end date ($end) must be later than the start date ($start)"
            }
        }

        Write-Debug "Using PSBoundParameters:"
        Write-Debug ($PSBoundParameters | Out-String).trim()

        Switch ($PSCmdlet.ParameterSetName) {
            "month" {
                Write-Verbose "Using month $month and year $year"

                #get month number
                Write-Verbose "Parsing $month to number"
                $monthInt = [DateTime]::parse("1 $month $year").month
                Write-Verbose "Returned month number $monthInt"
                $startD = [DateTime]::new($year, $monthInt, 1)
                $endD = $startD.date
            }
            "span"  {
                #Figure out the first day of the start and end months
                # Write-Verbose "Calculating start from month $($start.month) year $($start.year)"
                # $start = [DateTime]::new($start.year, $start.Month, 1)
                Write-Verbose "Treating $start as [DateTime]"
                $startD = $start -as [DateTime]
                # Write-Verbose "Calculating end from month $($end.month) year $($end.year)"
                # $end = [DateTime]::new($end.year, $end.month, 1)
                Write-Verbose "Treating $end as [DateTime]"
                $endD = $end -as [DateTime]
            }
            "calyear" {
                Write-Verbose "Getting calendar for $CalendarYear"
                $startD = [DateTime]::new($year, 1, 1)
                $endD = [DateTime]::new($year, 12, 1)
            }
            "quarter" {
                Write-Verbose "Getting calendar for Q$Quarter $Year"
                switch ($Quarter) {
                    1 { $startD = [DateTime]::new($year, 1, 1); $endD = [DateTime]::new($year, 3, 1) }
                    2 { $startD = [DateTime]::new($year, 4, 1); $endD = [DateTime]::new($year, 6, 1) }
                    3 { $startD = [DateTime]::new($year, 7, 1); $endD = [DateTime]::new($year, 9, 1) }
                    4 { $startD = [DateTime]::new($year, 10, 1); $endD = [DateTime]::new($year,12, 1) }
                }
            }
            default {
                #this should never get called, but if it does, something is coded wrong
                Write-Warning "Detected parameter set $($PSCmdlet.ParameterSetName) and I don't know what to do!"
            }
        }

        Write-Verbose "Starting at $($startD.toString())"
        Write-Verbose "Ending at $($endD.toString())"
        Write-Verbose "Highlighting: $($HighLightDate-join ',')"
        Write-Verbose "Go through the requested months."
        while ($startD -le $endD) {
            Write-Debug "Looping from $($startD.DateTime)"
            $paramHash = @{
                start          = $startD
                HighLightDates = $HighLightDate
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
            $startD = $startD.AddMonths(1)
        }
    } #process

    End {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
}
