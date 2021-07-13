function _getCalendar {
    [cmdletbinding()]
    Param(
        [datetime]$start = (Get-Date),
        [System.DayOfWeek]$FirstDay = "Sunday",
        [string[]]$highlightDates,
        [switch]$NoANSI
    )

    # https://fmoralesdev.com/2019/03/21/c-datetime-examples/

    $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    Write-Verbose "Building calendar for $($currCulture.Name)"

    #Need to rebuild HighlightDate to respect culture?
    if ($HighlightDates) {
        $highlightdates = foreach ($item in $HighlightDates) {
            Write-Verbose "Casting $item as [datetime]"
            $item -as [datetime]
        }
        write-Verbose "Detected $($highlightdates.count) highlight dates"
        $highlightDates | ForEach-Object { Write-Verbose $_.ToString()}
    }

    $mo = $start.month
    $yr = $start.year
    $max = $currCulture.DateTimeFormat.Calendar.GetDaysInMonth($yr, $mo)
    Write-Verbose "Totals days in $mo/$yr is $max"
    $end = Get-Date -Year $yr -Month $mo -Day $max
    Write-Verbose "Ending $end"

    #$dateTimeFormat = $currCulture.DateTimeFormat

    $fd = $FirstDay.value__
    #$dateTimeFormat.FirstDayOfWeek.value__

    Write-Verbose "First day of the week is $FirstDay [$fd]"
    $currentDay = $start

    $day0 = @()
    $day1 = @()
    $day2 = @()
    $day3 = @()
    $day4 = @()
    $day5 = @()
    $day6 = @()

    #adjust for the beginning of the month
    while ($currentDay.DayOfWeek.value__ -ne $fd) {
        $currentDay = $currentDay.AddDays(-1)
    }

    While ($currentDay.date -le $end.date) {
        [datetime]$aDay = $currentDay
        Switch ($aDay.DayOfWeek.value__) {
            0 { $day0 += $aday }
            1 { $day1 += $aday }
            2 { $day2 += $aday }
            3 { $day3 += $aday }
            4 { $day4 += $aday }
            5 { $day5 += $aday }
            6 { $day6 += $aday }
        }
        $currentDay = $currentDay.AddDays(1)
    }

    #add enough days to finish the week
    While ($currentDay.DayOfWeek.value__ -ne 0) {
        [datetime]$aDay = $currentDay
        #Write-Verbose "adding $aDay"
        Switch ($aDay.DayOfWeek.value__) {
            0 { $day0 += $aday }
            1 { $day1 += $aday }
            2 { $day2 += $aday }
            3 { $day3 += $aday }
            4 { $day4 += $aday }
            5 { $day5 += $aday }
            6 { $day6 += $aday }
        }
        $Currentday = $currentDay.AddDays(1)
    }

    if ($fd -eq 0) {
        $mo = [pscustomobject]@{
            PSTypeName = "PSCalendarMonth"
            Month      = "{0:MMMM}" -f $start
            Year       = $start.year
            D0         = $day0
            D1         = $day1
            D2         = $day2
            D3         = $day3
            D4         = $day4
            D5         = $day5
            D6         = $day6
        }
    }
    else {
        $mo = [pscustomobject]@{
            PSTypeName = "PSCalendarMonth"
            Month      = "{0:MMMM}" -f $start
            Year       = $start.year
            D1         = $day1
            D2         = $day2
            D3         = $day3
            D4         = $day4
            D5         = $day5
            D6         = $day6
            D0         = $day0
        }
    }

    $dow = $mo.psobject.Properties.name | Where-Object { $_ -notmatch "Month|Year" }

    #Build an array of short day names
    $abbreviated = $currCulture.DateTimeFormat.AbbreviatedDayNames

    $days = @()

    if ($fd -eq 0 ) {
        for ($n = 0; $n -lt $abbreviated.count; $n++) {
            $d = $abbreviated[$n].padleft(4, " ")
            if ($NoANSI) {
                $days += $d
            }
            else {
                $days += "{0}{1}{2}" -f $PScalendarConfiguration.DayofWeek, $d, "$esc[0m"
            }
        }
    }
    else {
        for ($n = 1; $n -lt $abbreviated.count; $n++) {
            $d = $abbreviated[$n].padleft(4, " ")
            if ($NoANSI) {
                $days += $d
            }
            else {
                $days += "{0}{1}{2}" -f $PScalendarConfiguration.DayofWeek, $d, "$esc[0m"
            }

        }
        $d = $abbreviated[0].padleft(4, " ")
        if ($NoANSI) {
            $days += $d
        }
        else {
            $days += "{0}{1}{2}" -f $PScalendarConfiguration.DayofWeek, $d, "$esc[0m"
        }

    }

    $plainHead = "$($mo.Month) $($mo.Year)"
    if ($NoANSI) {
        $head = $plainHead
    }
    else {
        $head = "{0}{1}{2}" -f $pscalendarConfiguration.title, $plainhead, "$esc[0m"
    }

    $dayhead = $days -join '  '
    Write-Verbose "Using day heading $dayhead"
    $month = for ($i = 0; $i -lt 6; $i++) {
        $wk = for ($k = 0; $k -lt $dow.count; $k++) {

            $theDay = ($mo.$($dow[$k])[$i]) -as [datetime]
            #Write-Verbose "Adding $theDay"
            if ($theDay) {
                $d = $theDay.day
                $value = $d.tostring().padleft(4, ' ')
                if ( ($theDay.date -eq (Get-Date).date) -AND (-Not $NoANSI)) {
                    "{0}{1}{2}" -f $PScalendarConfiguration.Today, $value, "$esc[0m"

                }
                elseif ( ($highlightDates -contains $theDay.date) -AND (-Not $NoANSI)) {
                    "{0}{1}{2}" -f $PScalendarConfiguration.Highlight, $value, "$esc[0m"
                }
                else {
                    $value
                }
            }
        }
        Write-Verbose "Adding week $wk"
        $wk -join '  '
    }

    #writing a single string object
    Function makemonth {
        #this is a hack function to write all the strings to the pipeline
        #separately
        [int]$pad = (40 - $plainhead.Length) / 2 + 1
        $p = " " * $pad
        "`n$p$head`n"
        $dayhead
        $month
    }

    #join all the strings into a single string
    makemonth | Out-String

}
function _getMonthsByCulture {
    [cmdletbinding()]
    Param([string]$Culture = ([system.threading.thread]::currentThread).CurrentCulture)
    Write-Verbose "Getting months for culture $Culture"
    [cultureinfo]::GetCultureInfo($culture).DateTimeFormat.Monthnames
}

function _getMonthNumber {
    [cmdletbinding()]
    Param([string]$MonthName)

    _getMonthsByCulture | ForEach-Object -Begin { $i = 0 } -Process { $i++; if ($_ -eq $MonthName) { return $i } }
}

Function New-RunspaceCleanupJob {
    <#
    You use this function like this:
    $newrunspace = <code>
    $pscmd = [powershell]::create()

    add commands to $pscmd
    $pscmd.runspace = $newrunspace
    $handle = $pscmd.beginInvoke()

    Start a thread job to test if runspace is being used and close it if it is finished
    New-RunspaceCleanUpJob -handle $handle -powershell $pscmd -sleepinterval 30
    #>
    [cmdletbinding()]
    [OutputType("None", "ThreadJob")]
    Param(
        [Parameter(Mandatory, HelpMessage = "This should be the System.Management.Automation.Runspaces.AsyncResult object from the BeginInvoke() method.")]
        [ValidateNotNullorEmpty()]
        [object]$Handle,
        [Parameter(Mandatory)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PowerShell]$PowerShell,
        [Parameter(HelpMessage = "Specify a sleep interval in seconds")]
        [ValidateRange(5, 600)]
        [int32]$SleepInterval = 10,
        [Parameter(HelpMessage = "Pass the thread job object to the pipeline")]
        [switch]$Passthru
    )

    $job = Start-ThreadJob -ScriptBlock {
        param($handle, $ps, $sleep)
        #the Write-Host lines are so that if you look at the results of  the thread job
        #you'll see something you can use for debugging or troubleshooting.
        Write-Host "[$(Get-Date)] Sleeping in $sleep second loops"
        Write-Host "Watching this runspace"
        Write-Host ($ps.runspace | Select-Object -Property * | Out-String)
        #loop until the handle shows as completed, sleeping the the specified
        #number of seconds
        do {
            Start-Sleep -Seconds $sleep
        } Until ($handle.IsCompleted)
        Write-Host "[$(Get-Date)] Closing runspace"

        $ps.runspace.close()
        Write-Host "[$(Get-Date)] Disposing runspace"
        $ps.runspace.Dispose()
        Write-Host "[$(Get-Date)] Disposing PowerShell"
        $ps.dispose()
        Write-Host "[$(Get-Date)] Ending job"
    } -ArgumentList $Handle, $PowerShell, $SleepInterval

    if ($passthru) {
        #Write the ThreadJob object to the pipeline
        $job
    }
}