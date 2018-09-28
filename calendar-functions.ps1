
# http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

Function Get-Calendar {

    [cmdletbinding(DefaultParameterSetName = "month")]
    [OutputType([System.String])]
    [Alias("cal")]

    Param(
        [Parameter(Position = 0, ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [string]$Month = (get-date -format MMMM),

        [Parameter(ParameterSetName = "month")]
        [ValidatePattern('^\d{4}$')]
        [int]$Year = (Get-Date).Year,

        [Parameter(Mandatory, HelpMessage = "Enter the start of a month like 1/1/2019", ParameterSetName = "span")]
        [ValidateNotNullOrEmpty()]
        [DateTime]$Start,

        [Parameter(Mandatory, HelpMessage = "Enter an ending date for the month like 2/1/2019", ParameterSetName = "span")]
        [ValidateNotNullOrEmpty()]
        [DateTime]$End,

        [string[]]$HighlightDate = (Get-Date).date.toString()
    )

    Begin {
        Write-verbose "Starting $($myinvocation.MyCommand)"
    }
    Process {
        Write-Verbose "Using parameter set $($pscmdlet.ParameterSetName)"

        if ($pscmdlet.ParameterSetName -eq "month") {
            [datetime]$start = Get-Date "1 $month,$year"
            [datetime]$end = $start.date #.Adddays(30)
        }
        else {
            #Figure out the first day of the start and end months
            $start = New-Object DateTime $start.Year, $start.Month, 1
            $end = New-Object DateTime $end.Year, $end.Month, 1
        }
        Write-Verbose "Starting at $start"
        Write-Verbose "Ending at $End"
        #Convert the highlight dates into real dates
        [DateTime[]]$highlightDate = [DateTime[]]$highlightDate

        #Retrieve the DateTimeFormat information so that we can  manipulate the calendar
        $dateTimeFormat = (Get-Culture).DateTimeFormat
        $firstDayOfWeek = $dateTimeFormat.FirstDayOfWeek

        Write-Verbose "First day of the week is $firstDayofWeek"

        $currentDay = $start

        Write-Verbose "Go through the requested months"
        while ($start -le $end) {
            #We may need to back-pedal a bit if the first day of the month
            #falls in the middle of the week
            while ($currentDay.DayOfWeek -ne $dateTimeFormat.FirstDayOfWeek) {
                $currentDay = $currentDay.AddDays(-1)
            }

            #Prepare to store information about this date range
            $currentWeek = New-Object PsObject
            $dayNames = @()
            $weeks = @()

            Write-Verbose "Go until we've hit the end of the month."
            #Even once we've done that, continue until we fill up the week
            #with days from the next month.
            while (($currentDay -lt $start.AddMonths(1)) -or
                ($currentDay.DayOfWeek -ne $dateTimeFormat.FirstDayOfWeek)) {
                #Figure out the day names we'll be using to label the columns
                $dayName = "{0:ddd}" -f $currentDay
                if ($dayNames -notcontains $dayName) {
                    $dayNames += $dayName
                }

                #Pad the day number for display, highlighting if necessary
                $displayDay = " {0,2} " -f $currentDay.Day

                #See if we should highlight a specific date
                if ($highlightDate) {
                    $compareDate = New-Object DateTime $currentDay.Year,
                    $currentDay.Month, $currentDay.Day
                    if ($highlightDate -contains $compareDate) {
                        $displayDay = "*" + ("{0,2}" -f $currentDay.Day) + "*"
                    }
                }
                <#
#Otherwise, highlight as part of a date range
if ($highlightDay -and ($highlightDay[0] -eq $currentDay.Day)) {
    $displayDay = "[" + ("{0,2}" -f $currentDay.Day) + "]"
    $null, $highlightDay = $highlightDay
}
#>

                #Add in the day of week and day number as note properties.
                $currentWeek | Add-Member NoteProperty $dayName $displayDay

                Write-Verbose "Move to the next day in the month"
                $currentDay = $currentDay.AddDays(1)

                #If we've reached the next week, store the current week
                #in the week list and continue on.
                if ($currentDay.DayOfWeek -eq $dateTimeFormat.FirstDayOfWeek) {
                    $weeks += $currentWeek
                    $currentWeek = New-Object PsObject
                }
            }

            Write-Verbose "Format our weeks into a table"
            $calendar = $weeks | Format-Table $dayNames -auto | Out-String

            Write-Verbose "Add a centered header"
            $width = ($calendar.Split("`n") | Measure-Object -Max Length).Maximum
            $header = "{0:MMMM yyyy}" -f $start
            $padding = " " * (($width - $header.Length) / 2)
            #use this line to insert a blank line before the calendar
            $displayCalendar = " `n" + $padding + $header + "`n " + $calendar

            #use this line to not insert a blank line before the calendar
            #$displayCalendar = $padding + $header + "`n " + $calendar
            $displayCalendar.TrimEnd()

            #And now move onto the next month
            $start = $start.AddMonths(1)
        }
    } #process

    End {
        Write-verbose "Ending $($myinvocation.MyCommand)"
    }
} #end function


#display a colorized calendar in the console

Function Show-Calendar {

    [cmdletbinding()]
    [Alias("scal")]
    Param(

        [Parameter(Position = 0, ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [string]$Month = (get-date -format MMMM),

        [Parameter(ParameterSetName = "month")]
        [ValidatePattern('^\d{4}$')]
        [int]$Year = (Get-Date).Year,

        [string[]]$HighlightDate = (Get-Date).date.toString(),

        [ValidateNotNullOrEmpty()]
        [consolecolor]$HighlightColor = "Green"
    )

    #add default values if not bound
    $params = "Month", "Year", "HighlightDate"
    foreach ($param in $params) {
        if (-not $PSBoundParameters.ContainsKey($param)) {
            $PSBoundParameters.Add($param, $( (get-variable -Name $param).value))
        }
    }

    #remove color parameter if specified
    if ($PSBoundParameters.Containskey("HighlightColor")) {
        $PSBoundParameters.Remove("HighlightColor")
    }
    $cal = Get-Calendar @PSBoundParameters

    #turn the calendar into an array of strings
    $calarray = $cal.split("`n")

    # a regular expression pattern to match on highlighted days

    [regex]$m = "(\*)?[\s|\*]\d{1,2}(\*)?"
    foreach ($line in $calarray) {

        if ($line -match "\d{4}") {
            write-Host $line -ForegroundColor Yellow
        }
        elseif ($line -match "\w{3}|-{3}") {
            Write-Host $line -ForegroundColor cyan
        }
        elseif ($line -match "\*") {
            #write-host $line -foregroundcolor Magenta
            $week = $line
            #write-host "x" -NoNewline
            $m.Matches($week).Value| foreach-object {

                $day = "$_"

                if ($day -match "\*") {
                    write-host "$($day.replace('*','').padleft(3," "))  " -NoNewline -ForegroundColor $HighlightColor
                }
                else {
                    write-host "$($day.PadLeft(3," "))  " -nonewline
                }
            }
            write-host ""
        }
        else {
            Write-host $line
        }
    }
}

