Function Get-NCalendar {
    [cmdletbinding()]
    [alias("ncal")]
    [Outputtype("String")]

    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the full month name. The default is the current month."
            )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
            #sometimes this returns an extra and blank entry
            $m = [system.globalization.cultureinfo]::CurrentCulture.DateTimeFormat.MonthNames | Where-Object { $_ }
            if ( $m -contains $_) {
                $True
            }
            Else {
                Throw "You must enter one of these values: $($m -join ',')"
                $False
            }
        })]
        [string]$Month = (Get-Date -Format MMMM),
        [Parameter(
            Position = 1,
            ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the 4 digit year. The default is the current year."
            )]
        [ValidatePattern("\d{4}")]
        [ValidateRange(1000, 9999)]
        [int]$Year = (Get-Date).Year,
        [Parameter(HelpMessage = "Don't highlight the current date.")]
        [Switch]$HideHighlight,
        [Parameter(HelpMessage = "Start the week on Monday")]
        [Switch]$Monday
    )

    Begin {
        #display the module version defined in the psm1 file
        Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
        Write-Verbose "Using PowerShell version $($psversiontable.PSVersion)"
        #Call .NET for better results when testing this command in different cultures
        $currCulture = [system.globalization.cultureinfo]::CurrentCulture

        #enforce NoAnsi if running in the PowerShell ISE [Issue #30]
        if ($host.name -Match "ISE Host") {
            Write-Verbose "PowerShell ISE detected. Turning off highlighting."
            $HideHighlight = $True
        }
    } #begin

    Process {
        Write-Verbose "Using month $month and year $year"
        $today = (Get-Date).Date
        Write-Verbose "Today is $today"
        #get month number
        Write-Verbose "Parsing $month to number"
        [int]$monthint = [datetime]::parse("1 $month $year").month
        Write-Verbose "Returned month number $monthint"
        if ( ($monthint -eq $today.month) -AND ($year -eq $today.year)) {
            Write-Verbose "In the current month"
            $IsCurrentMonth = $True
        }
        $startd = [datetime]::new($year, $monthint, 1)

        $max = $currCulture.DateTimeFormat.Calendar.GetDaysInMonth($year, $monthint)
        Write-Verbose "Max days in month is $max."

        $daynames = $currCulture.DateTimeFormat.AbbreviatedDayNames
        $daylist = [System.Collections.Generic.list[string]]::new()

        if ($Monday) {
            Write-Verbose "Using a Monday-based week"
            ($daynames[1..6]).Foreach( { $daylist.add($_) })
            $daylist.Add($daynames[0])
        }
        else {
            $daylist.AddRange($daynames)
        }

        $daylist | ForEach-Object -Begin {
            $dayHash = [ordered]@{}
        } -Process {
            $dayHash.Add($_, @())
        }


        for ($i = 0; $i -lt $max; $i++) {
            $day = $startd.AddDays($i).date
            $dayname = "{0:ddd}" -f $day
            $dom = $day.day
            $dayhash[$dayname] += $dom
        }

        $dayhash | Out-String | Write-Verbose
        #make sure month is in title case
        $head = "$($currculture.TextInfo.toTitleCase($Month)) $Year"
        $maxDayLength = $dayhash.keys.length | Sort-Object | Select-Object -Last 1
        Write-Verbose "Building day hashtable"
        $out = $dayhash.GetEnumerator() |
        ForEach-Object {
            Write-Verbose $_.name
            #build a value string
            $vstring = $_.value.Foreach({ "{0,2}" -f $_.toString()})

            Write-Verbose "Using days $($vstring -join ' ')"

            $row = "{0}{1}" -f $_.name.Padright(4), $($vstring -join " ").padleft(14)
            if ($isCurrentMonth -AND ($row -match "\b$($Today.day)\b") -AND (-Not $HideHighlight)) {
                Write-Verbose "Highlighting current day in $row"
                $row = $row -replace "\b$($Today.day)\b","$($PSCalendarConfiguration.Today)$($today.day)$([char]27)[0m"
            }
            write-Verbose "Using row $row"
            $row

        }
        Write-Verbose "display length = $($out[0].length)"
        #write-Verbose "head length = $($head.length)"
        $pad = (($out[0].length - $head.length) / 2) + $head.length + 1
        #Write-Verbose "padding $pad"
        if ($HideHighlight) {
            $head.padleft($pad)
        }
        else {
            "$($pscalendarConfiguration.Title)$($head.padleft($pad))$([char]27)[0m"
        }
        $out
        #insert a blank line
        "`r"
    }
    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}