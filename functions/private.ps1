function _getCalendar {
    [cmdletbinding()]
    Param(
        [DateTime]$start = (Get-Date),
        [System.DayOfWeek]$FirstDay = "Sunday",
        [string[]]$HighLightDates,
        [switch]$NoANSI,
        [switch]$MonthOnly
    )
    $global:mm=@()

    # https://fmoralesdev.com/2019/03/21/c-DateTime-examples/

    $currCulture = [System.Globalization.CultureInfo]::CurrentCulture
    Write-Debug "Building calendar for $($currCulture.Name)"

    #Need to rebuild HighLightDate to respect culture?
    if ($HighLightDates) {
        $HighLightDates = foreach ($item in $HighLightDates) {
            Write-Debug "Casting $item as [DateTime]"
            $item -as [DateTime]
        }
        Write-Debug "Detected $($HighLightDates.count) highlight dates"
        $HighLightDates | ForEach-Object { Write-Debug $_.toString()}
    }

    $mo = $start.month
    $yr = $start.year
    $max = $currCulture.DateTimeFormat.Calendar.GetDaysInMonth($yr, $mo)
    Write-Debug "Totals days in $mo/$yr is $max"
    $end = Get-Date -Year $yr -Month $mo -Day $max
    Write-Debug "Ending $end"

    #$DateTimeFormat = $currCulture.DateTimeFormat

    $fd = $FirstDay.value__
    #$DateTimeFormat.FirstDayOfWeek.value__

    Write-Debug "First day of the week is $FirstDay [$fd]"
   $CurrentDay = $start

    $day0 = @()
    $day1 = @()
    $day2 = @()
    $day3 = @()
    $day4 = @()
    $day5 = @()
    $day6 = @()

    #adjust for the beginning of the month
    while ($currentDay.DayOfWeek.value__ -ne $fd) {
       $CurrentDay =$CurrentDay.AddDays(-1)
    }

    While ($currentDay.date -le $end.date) {
        [DateTime]$aDay =$CurrentDay
        Switch ($aDay.DayOfWeek.value__) {
            0 { $day0 += $aDay }
            1 { $day1 += $aDay }
            2 { $day2 += $aDay }
            3 { $day3 += $aDay }
            4 { $day4 += $aDay }
            5 { $day5 += $aDay }
            6 { $day6 += $aDay }
        }
       $CurrentDay =$CurrentDay.AddDays(1)
    }

    #add enough days to finish the week
    While ($currentDay.DayOfWeek.value__ -ne 0) {
        [DateTime]$aDay =$CurrentDay
        #Write-Debug "adding $aDay"
        Switch ($aDay.DayOfWeek.value__) {
            0 { $day0 += $aDay }
            1 { $day1 += $aDay }
            2 { $day2 += $aDay }
            3 { $day3 += $aDay }
            4 { $day4 += $aDay }
            5 { $day5 += $aDay }
            6 { $day6 += $aDay }
        }
       $CurrentDay =$CurrentDay.AddDays(1)
    }

    #fix for issue #32
    if ($fd) {
        $day0 += [DateTime]$currentDay
    }

    if ($fd -eq 0) {
        $mo = [PSCustomObject]@{
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
        $mo = [PSCustomObject]@{
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

    $dow = $mo.PSObject.Properties.name | Where-Object { $_ -notmatch "Month|Year" }

    #Build an array of short day names
    $abbreviated = $currCulture.DateTimeFormat.AbbreviatedDayNames
    #code suggestion from @scriptingstudio Issue #32
    $days = [System.Collections.Generic.list[string]]::new()

    $underline = 4
    $addDay = {
        $d = $abbreviated[$args[0]].PadLeft($underline, " ")
        if ($NoANSI) {
            $days.add($d)
        } else {
            $days.add(("{0}{1}{2}" -f $PScalendarConfiguration.DayOfWeek, $d, "$esc[0m"))
        }
    }
    $n = if ($fd -eq 0) {0} else {1}
    for ($n; $n -lt $abbreviated.count; $n++) {. $addDay $n}
    if ($fd) {. $addDay 0}

    $plainHead = "$($mo.Month) $($mo.Year)"
    if ($NoANSI) {
        $head = $plainHead
    }
    else {
        $head = "{0}{1}{2}" -f $pscalendarConfiguration.title, $plainHead, "$esc[0m"
    }

    $dayHead = $days -join '  '
    Write-Debug "Using day heading $dayHead"
    $month = for ($i = 0; $i -lt 6; $i++) {
        $wk = for ($k = 0; $k -lt $dow.count; $k++) {

            $theDay = ($mo.$($dow[$k])[$i]) -as [DateTime]

            #Write-Debug "Adding $theDay"
            if ($theDay) {

                if (($start.month -ne $theDay.month) -AND $MonthOnly) {
                    $theDay = $null
                    $d = ' '
                }
                else {
                    $d = $theDay.day
                }

                $value = $d.toString().PadLeft($underline, ' ')
                #$value = $d.toString().PadLeft(4, ' ')
                if (($theDay.date -eq (Get-Date).date) -AND (-Not $NoANSI)) {
                    "{0}{1}{2}" -f $PScalendarConfiguration.Today, $value, "$esc[0m"

                }
                elseif ( ($HighLightDates -contains $theDay.date) -AND (-Not $NoANSI)) {
                    "{0}{1}{2}" -f $PScalendarConfiguration.Highlight, $value, "$esc[0m"
                }
                else {
                    $value
                }
            }
        }
        Write-Debug "Adding week $wk"
        $wk -join '  '
    }

    #writing a single string object
    Function makemonth {
        #this is a hack function to write all the strings to the pipeline
        #separately
        #code suggestion from @scriptingstudio Issue #32
        [int]$pad = (10*$underline - $plainHead.Length) / 2 + 1
        #[int]$pad = (40 - $plainHead.Length) / 2 + 1
        $p = " " * $pad
        "`n$p$head`n"
        $dayHead
        $month
    }

    #join all the strings into a single string
    makemonth #| Out-String
    $global:mm += makemonth
} #_getCalendar
function _getMonthsByCulture {
    [cmdletbinding()]
    Param([string]$Culture = ([system.threading.thread]::currentThread).CurrentCulture)
    Write-Debug "Getting months for culture $Culture"
    [CultureInfo]::GetCultureInfo($culture).DateTimeFormat.MonthNames
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
        [ValidateNotNullOrEmpty()]
        [object]$Handle,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
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