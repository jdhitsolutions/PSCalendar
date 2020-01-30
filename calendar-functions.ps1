
# http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

Function Get-Calendar {

    [cmdletbinding(DefaultParameterSetName = "month")]
    [OutputType([System.String])]
    [Alias("cal")]

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
        [string]$Month = (Get-Date -format MMMM),

        [Parameter(Position = 2, ParameterSetName = "month")]
        [ValidatePattern('^\d{4}$')]
        [int]$Year = (Get-Date).Year,

        [Parameter(Mandatory, HelpMessage = "Enter the start of a month like 1/1/2019", ParameterSetName = "span")]
        [ValidateNotNullOrEmpty()]
        [DateTime]$Start,

        [Parameter(Mandatory, HelpMessage = "Enter an ending date for the month like 2/1/2019", ParameterSetName = "span")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ($_ -ge $Start) {
                    $True
                }
                else {
                    Throw "The end date ($_) must be later than the start date ($start)"
                    $False
                }
            })]
        [DateTime]$End,

        [ValidateNotNullorEmpty()]
        [string[]]$HighlightDate = (Get-Date).date.toString()
    )

    Begin {
        Write-Verbose "Starting $($myinvocation.MyCommand)"
        Write-Verbose "Using PowerShell version $($psversiontable.PSVersion)"
        #Call .NET for better results when testing this command in different cultures
        $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    }
    Process {
        Write-Verbose "Using parameter set: $($pscmdlet.ParameterSetName)"
        Write-Verbose "Using culture $($currCulture.name)"
        Write-Verbose "Using PSBoundParameters"
        Write-Verbose ($PSBoundParameters | Out-String).trim()

        if ($pscmdlet.ParameterSetName -eq "month") {
            Write-Verbose "Using month $month and year $year"
            Write-Verbose "Getting start date using pattern $($currCulture.DateTimeFormat.ShortDatePattern)"

            #get month number
            $monthint = [datetime]::parse("1 $month $year").month
            $start = [datetime]::new($year, $monthint, 1)

            $end = $start.date
        }
        else {
            #Figure out the first day of the start and end months
            $start = [datetime]::new($start.year, $start.Month, 1)

            $end = [datetime]::new($end.year, $end.month, 1)

        }
        Write-Verbose "Starting at $start"
        Write-Verbose "Ending at $End"

        #Convert the highlight dates into real dates
        #using the .NET Class to parse because this works better for culture-specific datetime strings
        [DateTime[]]$highlightDates = @()
        foreach ($item in $highlightDate) {
            Write-Verbose "Parsing $(($item | Out-String).trim()) to [datetime]"
            $item | Out-String | Write-Verbose
            $highlightDates += $item -as [datetime]
        }

        #re-add today if not one of the highlighted dates
        if ($highlightDates -notcontains ([datetime]::now).date) {
            Write-Verbose "Re-adding today to highlighted dates"
            $highlightDates += ([datetime]::now).date
        }
        Write-Verbose "Highlighting: $($highlightDates -join ',')"
        #Retrieve the DateTimeFormat information so that we can manipulate the calendar
        $dateTimeFormat = $currCulture.DateTimeFormat
        $firstDayOfWeek = $dateTimeFormat.FirstDayOfWeek

        Write-Verbose "First day of the week is $firstDayofWeek"

        $currentDay = $start

        Write-Verbose "Go through the requested months"
        while ($start -le $end) {
            #We may need to backpedal a bit if the first day of the month
            #falls in the middle of the week
            while ($currentDay.DayOfWeek -ne $dateTimeFormat.FirstDayOfWeek) {
                $currentDay = $currentDay.AddDays(-1)
            }

            #Prepare to store information about this date range
            Write-Verbose "Initializing currentweek"
            $currentWeek = New-Object -typename PsObject
            $dayNames = @()
            $weeks = @()

            Write-Verbose "Go until we've hit the end of the month."
            #Even once we've done that, continue until we fill up the week
            #with days from the next month.
            while (($currentDay -lt $start.AddMonths(1)) -or
                ($currentDay.DayOfWeek -ne $dateTimeFormat.FirstDayOfWeek)) {
                #Figure out the day names we'll be using to label the columns
                $dowlen = $dateTimeFormat.FirstDayOfWeek.length + 3
                $dayName = ("{0:ddd}" -f $currentDay).padleft($dowlen, ' ')
                if ($dayNames -notcontains $dayName) {
                    Write-Verbose "Adding $dayname"
                    $dayNames += $dayName
                }

                #Pad the day number for display, highlighting if necessary
                #get the length of the abbreviated weekday to know how much to pad
                $daypad = $daynames[0].length

                Write-Verbose "Padding $daypad"
                $displayDay = "{0,$daypad} " -f $currentDay.Day

                #See if we should highlight a specific date
                if ($highlightDates) {
                    $compareDate = New-Object DateTime $currentDay.Year, $currentDay.Month, $currentDay.Day
                    if ($highlightDates -contains $compareDate) {
                        $displayDay = "*" + ("{0,$($daypad-1)}" -f $currentDay.Day) + "*"
                    }
                }

                #Add in the day of week and day number as note properties.
                $currentWeek | Add-Member NoteProperty $dayName $displayDay

                #  Write-Verbose "Move to the next day in the month"
                $currentDay = $currentDay.AddDays(1)

                #If we've reached the next week, store the current week
                #in the week list and continue on.
                if ($currentDay.DayOfWeek -eq $dateTimeFormat.FirstDayOfWeek) {
                    $weeks += $currentWeek
                    $currentWeek = New-Object -typename PsObject
                }
            }

            Write-Verbose "Format our weeks into a table"
            Write-Verbose ($weeks | Out-String)
            $calendar = $weeks | Format-Table -property $dayNames | Out-String

            Write-Verbose "Add a centered header"
            $width = ($calendar.Split("`n") | Measure-Object -Max Length).Maximum
            $header = "{0:MMMM yyyy}" -f $start
            Write-Verbose $header
            $padding = " " * (($width - $header.Length) / 2)
            #use this line to insert a blank line before the calendar
            Write-Verbose "Adding calendar"
            Write-Verbose $calendar
            $displayCalendar = " `n" + $padding + $header + "`n " + $calendar

            #use this line to not insert a blank line before the calendar
            #$displayCalendar = $padding + $header + "`n " + $calendar
            $displayCalendar.TrimEnd()

            #And now move onto the next month
            $start = $start.AddMonths(1)
        }
    } #process

    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
} #end Get-Calendar


#display a colorized calendar in the console

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
        [string]$Month = (Get-Date -format MMMM),

        [Parameter(Position = 2, ParameterSetName = "month")]
        [ValidatePattern('^\d{4}$')]
        [int]$Year = (Get-Date).Year,

        [string[]]$HighlightDate = (Get-Date).date.toString(),

        [Parameter(HelpMessage = "Specify a color for the highlighted days.")]
        [ValidateNotNullOrEmpty()]
        [consolecolor]$HighlightColor = "Green",

        [Parameter(HelpMessage = "Specify a color for the days of the month heading.")]
        [ValidateNotNullOrEmpty()]
        [consolecolor]$TitleColor = "Yellow",

        [Parameter(HelpMessage = "Specify a color for the days of the week heading.")]
        [ValidateNotNullOrEmpty()]
        [consolecolor]$DayColor = "Cyan",

        [Parameter(HelpMessage = "Specify a color to mark today")]
        [ValidateNotNullOrEmpty()]
        [consolecolor]$TodayColor = "Red",
        [System.Management.Automation.Host.Coordinates]$Position
    )

    Write-Verbose "Starting $($myinvocation.mycommand)"

    #get culture to see how long the first day of week is
    $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    if ($position) {
        #save current cursor location
        $here = $host.ui.RawUI.CursorPosition
       # New-WPFMessageBox $here
        [void]$PSBoundParameters.remove("Position")
    }

    #add default values if not bound
    $params = "Month", "Year", "HighlightDate"
    foreach ($param in $params) {
        if (-not $PSBoundParameters.ContainsKey($param)) {
            $PSBoundParameters.Add($param, $((Get-Variable -Name $param).value))
        }
    }

    #remove color parameters if specified
    "HighlightColor", "TitleColor", "DayColor", "TodayColor" | ForEach-Object {
        if ($PSBoundParameters.Containskey($_)) {
            [void]$PSBoundParameters.Remove($_)
        }
    } #foreach color parameter

    $cal = Get-Calendar @PSBoundParameters

    #turn the calendar into an array of strings
    $calarray = $cal.split("`n")

    # a regular expression pattern to match on highlighted days
    [regex]$m = "(\*)?[\s|\*]\d{1,2}(\*)?"

    #go through each line and write it back to the console using Write-Host
    foreach ($line in $calarray) {
        if ($line -match "\d{4}") {
            #write the line with the month and year
            if ($position) {
                $host.ui.RawUI.CursorPosition = $Position
            }
            Write-Host $line -ForegroundColor $TitleColor
        }
        elseif ($line -match "[a-zA-z]{2,3}| -") {
            #write the day names and underlines
            if ($Position) {
                $Position.y++
                $host.ui.RawUI.CursorPosition = $Position
            }
            Write-Host $line -ForegroundColor $DayColor
        }
        elseif ($line -match "\*") {
            #break apart lines with asterisks
            $week = $line
            if ($position) {
                $Position.y++
                $host.ui.RawUI.CursorPosition = $Position
            }
            $m.Matches($week).Value | ForEach-Object {

                $day = "$_"
                #pad based on the length of the day of week string
                $l = $currCulture.DateTimeFormat.AbbreviatedDayNames[0].length

                $spacer = "  "
                if ($l -eq 2) {
                    $l += 2
                }
                elseif ($l -eq 3) {
                    $l++
                }

                if ($day.replace('*', '').trim() -eq (Get-Date).day) {

                    Write-Host "$($day.replace('*','').padleft($l," "))$spacer" -NoNewline -ForegroundColor $TodayColor

                }
                elseif ($day -match "\*") {

                    Write-Host "$($day.replace('*','').padleft($l," "))$spacer" -NoNewline -ForegroundColor $HighlightColor

                }
                else {
                    Write-Host "$(($day).PadLeft($l," "))$spacer" -nonewline
                }
            }

            Write-Host ""
        }
        else {
            if ($Position) {
                $Position.y++
                $host.ui.RawUI.CursorPosition = $Position
            }
            Write-Host $line
        }
    } #foreach line in calarray

    if ($Position) {
        #set cursor position back
        $host.ui.RawUI.CursorPosition = $here
    }

    Write-Verbose "Ending $($myinvocation.mycommand)"

} #end Show-Calendar

#create a WPF-based calendar
Function Show-GuiCalendar {
    [cmdletbinding()]
    [OutputType("None")]
    [Alias("gcal")]

    Param(
        [Parameter(Position = 1, HelpMessage = "Enter the first month to display by date, like 1/1/2019.")]
        [ValidateNotNullOrEmpty()]
        [datetime]$Start = [datetime]::new([datetime]::now.year, [datetime]::now.month, 1),

        [Parameter(Position = 2, HelpMessage = "Enter the last month to display by date, like 3/1/2019. You cannot display more than 3 months.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ($_ -ge $Start) {
                    $True
                }
                else {
                    Throw "The end date ($_) must be later than the start date ($start)"
                    $False
                }
            })]
        [datetime]$End = [datetime]::new([datetime]::now.year, [datetime]::now.month, 1),

        [Parameter(HelpMessage = "Enter an array of dates to highlight like 12/25/2019.")]
        [datetime[]]$HighlightDate,

        [Parameter(HelpMessage = "Select a font family for your calendar" )]
        [ValidateSet("Segoi UI", "QuickType", "Tahoma", "Lucida Console", "Century Gothic")]
        [string]$Font = "Segoi UI",

        [Parameter(HelpMessage = "Select a font style for your calendar." )]
        [ValidateSet("Normal", "Italic", "Oblique")]
        [string]$FontStyle = "Normal",

        [Parameter(HelpMessage = "Select a font weight for your calendar." )]
        [ValidateSet("Normal", "DemiBold", "Light", "Bold")]
        [string]$FontWeight = "Normal"
    )

    Write-Verbose "Starting $($myinvocation.mycommand)"

    #add the necessary type library and bail out if there are errors which means the
    #platform lacks support for WPF

    Try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
        Add-Type –AssemblyName PresentationCore -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to load a required type library. Your version of PowerShell and or platform may not support WPF. $($_.exception.message)"
        #bail out of the command
        Return
    }

    $months = do {
        $start
        $start = $start.AddMonths(1)
    } while ($start -le $end)

    if ($months.count -gt 3) {
        Write-Warning "You can't display more than 3 months at a time with this command."
        #bail out
        Return
    }

    #the title won't normally be seen but is set for development and test purposes
    $myParams = @{
        Months        = $months
        Height        = (200 * $months.count)
        Title         = "My Calendar"
        HighlightDate = $HighlightDate
        Font          = $Font
        FontStyle     = $FontStyle
        FontWeight    = $FontWeight
    }

    Write-Verbose "Using these parameters"
    $myparams | Out-String | Write-Verbose

    $newRunspace = [RunspaceFactory]::CreateRunspace()
    if ($newRunspace.ApartmentState) {
        $newRunspace.ApartmentState = "STA"
    }
    else {
        #This command probably won't run if the ApartmentState can't be set to STA
        #clean up
        $newRunspace.dispose()

        Write-Warning "Incompatible runspace detected. This command will most likely fail on this platform with this version of PowerShell."
        #bail out of the command
        return
    }
    $newRunspace.ThreadOptions = "ReuseThread"
    $newRunspace.Open()

    Write-Verbose "Defining runspace script"

    $psCmd = [PowerShell]::Create().AddScript( {

            Param (
                [datetime[]]$HighlightDate,
                [string]$Font,
                [string]$FontStyle,
                [string]$FontWeight,
                [int]$Height,
                [string]$Title,
                [datetime[]]$Months
            )

            #create a window form.
            $form = New-Object System.Windows.Window

            $form.AllowsTransparency = $True
            $form.WindowStyle = "none"
            #the title won't be shown when window style is set to none
            $form.Title = $Title
            $form.Height = $height
            $form.Width = 200

            $bg = New-Object System.Windows.Media.SolidColorBrush

            $form.Background = $bg
            #color is set for development purposes. It won't be seen normally.
            # $form.Background.Color = "green"
            # $form.background.Opacity = 0
            $form.ShowInTaskbar = $False
            $form.Add_Loaded( {
                    $form.Topmost = $True
                    $form.Activate()
                })

            $form.Add_MouseLeftButtonDown( { $form.DragMove() })

            #add event handlers to adjust opacity by using the +/- keys
            $form.add_KeyDown( {
                    switch ($_.key) {
                        { 'Add', 'OemPlus' -contains $_ } {
                            foreach ($cal in $myCals) {
                                If ($cal.Opacity -lt 1) {
                                    $cal.Opacity = $cal.opacity + .1
                                    $cal.UpdateLayout()
                                }
                            }
                        }
                        { 'Subtract', 'OemMinus' -contains $_ } {
                            foreach ($cal in $myCals) {
                                If ($cal.Opacity -gt .2) {
                                    $cal.Opacity = $cal.Opacity - .1
                                    $cal.UpdateLayout()
                                }
                            }
                        }
                    }
                })

            $stack = $stack = New-Object System.Windows.Controls.StackPanel
            $stack.Width = $form.Width
            $stack.Height = $form.Height
            $stack.HorizontalAlignment = "center"
            $stack.VerticalAlignment = "top"

            #create an array to store calendars so that opacity can be
            #set for multiple calendars in unison
            $myCals = @()
            foreach ($month in $months) {
                $cal = New-Object System.Windows.Controls.Calendar

                $cal.DisplayMode = "Month"

                <#
                notes for future development
                $calbg = new-object System.Windows.Media.ImageBrush
                $calbg.Opacity = "0.3"
                $calbg.ImageSource = "c:\scripts\zazu.gif"
                $cal.Background = $calbg

                $calbg = [System.Windows.Media.Brushes]::Aquamarine
                $cal.Background =$calbg

                #>
                $cal.Opacity = 1
                $cal.FontFamily = $font
                $cal.FontSize = 24
                $cal.FontWeight = $FontWeight
                $cal.FontStyle = $fontStyle

                $cal.DisplayDateStart = $month
                #added to allow display of past months
                $totaldays = [datetime]::DaysInMonth($month.year, $month.Month)
                $cal.DisplayDateEnd = $month.AddDays($totaldays - 1)

                $cal.HorizontalAlignment = "center"
                $cal.VerticalAlignment = "top"

                $cal.SelectionMode = "multipleRange"
                if ($highlightdate) {
                    foreach ($d in $HighlightDate) {
                        if ($d.month -eq $month.Month) {
                            $cal.SelectedDates.add($d)
                        }
                    }
                }

                $cal.add_DisplayDateChanged( {
                        # add the selected days for the currently displayed month
                        [datetime]$month = $cal.Displaydate
                        if ($highlightdate) {
                            foreach ($d in $HighlightDate) {
                                if ($d.month -eq $month.Month) {
                                    $cal.SelectedDates.add($d)

                                }
                            }
                        }
                        $cal.UpdateLayout()
                    })

                $stack.addchild($cal)
                $myCals += $cal
            } #foreach month

            $btn = New-Object System.Windows.Controls.Button
            $btn.Content = "_Close"
            $btn.Width = 75
            $btn.VerticalAlignment = "Bottom"
            $btn.HorizontalAlignment = "Center"
            $btn.Opacity = 1
            $btn.Add_click( {
                    $form.close()
                })

            $stack.AddChild($btn)

            $form.AddChild($stack)
            [void]$form.ShowDialog()
        }) #addScript

    [void]$psCmd.AddParameters($myparams)
    $psCmd.Runspace = $newRunspace
    Write-Verbose "Invoking calendar runspace"
    $handle = $psCmd.BeginInvoke()

    Write-Verbose "Creating ThreadJob"
    #calling a private, helper function which will clean up the runspace after the calendar is closed.
    $job = New-RunspaceCleanupJob -Handle $handle -PowerShell $pscmd -SleepInterval 30 -Passthru
    Write-Verbose "...Job Id $($job.id)"
    Write-Verbose "Ending $($myinvocation.mycommand)"

} #close Show-GuiCalendar

#region private functions

#a helper function to retrieve names
function _getMonthsByCulture {
    [cmdletbinding()]
    Param([string]$Culture = ([system.threading.thread]::currentThread).CurrentCulture)
    Write-Verbose "Getting months for culture $Culture"
    [cultureinfo]::GetCultureInfo($culture).DateTimeFormat.Monthnames
}

function _getMonthNumber {
    [cmdletbinding()]
    Param([string]$MonthName)

    _getMonthsByCulture | ForEach-Object -begin { $i = 0 } -process { $i++; if ($_ -eq $MonthName) { return $i } }
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
        Write-Host ($ps.runspace | Select-Object -property * | Out-String)
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

#endregion