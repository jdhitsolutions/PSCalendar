
# http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

Function Get-Calendar {

    [cmdletbinding(DefaultParameterSetName = "month")]
    [OutputType([System.String])]
    [Alias("cal")]

    Param(
        [Parameter(Position = 1, ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [ValidateScript( {
                $names = Get-MonthsByCulture
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
    }
    Process {
        Write-Verbose "Using parameter set: $($pscmdlet.ParameterSetName)"
        Write-Verbose "Using culture $((Get-Culture).name)"

        if ($pscmdlet.ParameterSetName -eq "month") {
            [datetime]$start = Get-Date "1 $month,$year"
            [datetime]$end = $start.date
        }
        else {
            #Figure out the first day of the start and end months
            $start = New-Object DateTime $start.Year, $start.Month, 1
            $end = New-Object DateTime $end.Year, $end.Month, 1
        }

        Write-Verbose "Starting at $start"
        Write-Verbose "Ending at $End"
        #Convert the highlight dates into real dates
        #using the .NET Class to parse because this works better for culture-specific datetime strings
        [DateTime[]]$highlightDates = foreach ($item in $highlightDate) {
            #parse datetime using current culture
            $cult = Get-Culture
            [datetime]::parse($item,$cult)
        }
        #Retrieve the DateTimeFormat information so that we can manipulate the calendar
        $dateTimeFormat = (Get-Culture).DateTimeFormat
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

                #highlight a specific date
                if ($highlightDates -ne (Get-Date).date.toString() ) {
                    $highlightDates += (Get-Date).date.toString()
                }

                $compareDate = New-Object DateTime $currentDay.Year,
                $currentDay.Month, $currentDay.Day
                if ($highlightDates -contains $compareDate) {
                    $displayDay = "*" + ("{0,2}" -f $currentDay.Day) + "*"
                }

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
} #end Get-Calendar


#display a colorized calendar in the console

Function Show-Calendar {

    [cmdletbinding()]
    [Alias("scal")]
    Param(
        [Parameter(Position = 1, ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [ValidateScript( {
                $names = Get-MonthsByCulture
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

    if ($position) {
        #save current cursor location
        $here = $host.ui.RawUI.CursorPosition
        $PSBoundParameters.remove("Position") | out-Null
    }

    #add default values if not bound
    $params = "Month", "Year", "HighlightDate"
    foreach ($param in $params) {
        if (-not $PSBoundParameters.ContainsKey($param)) {
            $PSBoundParameters.Add($param, $((get-variable -Name $param).value))
        }
    }

    #remove color parameters if specified
    "HighlightColor", "TitleColor", "DayColor","TodayColor" | foreach-object {
        if ($PSBoundParameters.Containskey($_)) {
            $PSBoundParameters.Remove($_) | Out-Null
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
        elseif ($line -match "\w{3}|-{3}") {
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
                if ($day -match "\*$((Get-Date).day)\*" ) {
                    Write-Host "$($day.replace('*','').padleft(3," "))  " -NoNewline -ForegroundColor $TodayColor
                }
                elseif ($day -match "\*") {
                    Write-Host "$($day.replace('*','').padleft(3," "))  " -NoNewline -ForegroundColor $HighlightColor
                }
                else {
                    Write-Host "$($day.PadLeft(3," "))  " -nonewline
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
        $here.y++
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

    if ($psedition -eq 'Core') {
        Write-Warning "This function requires Windows PowerShell."
        #bail out
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

    #add the necessary type library and bail out if there are errors

    Try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
        Add-Type –assemblyName PresentationCore -ErrorAction Stop
        Add-Type –assemblyName WindowsBase -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to load a required type library. $($_.exception.message)"
        #bail out
        Return
    }

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
    $newRunspace.ApartmentState = "STA"
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

            $bg = new-object System.Windows.Media.SolidColorBrush

            $form.Background = $bg
            #color is set for development purposes. It won't be seen normally.
            $form.Background.Color = "green"
            $form.background.Opacity = 0
            $form.ShowInTaskbar = $False
            $form.Add_Loaded( {
                    $form.Topmost = $True
                    $form.Activate()
                })

            $form.Add_MouseLeftButtonDown( {$form.DragMove()})

            #add event handlers to adjust opacity by using the +/- keys
            $form.add_KeyDown( {

                    switch ($_.key) {
                        {'Add', 'OemPlus' -contains $_} {
                            foreach ($cal in $myCals) {
                                If ($cal.Opacity -lt 1) {
                                    $cal.Opacity = $cal.opacity + .1
                                    $cal.UpdateLayout()
                                }
                            }
                        }
                        {'Subtract', 'OemMinus' -contains $_} {
                            foreach ($cal in $myCals) {
                                If ($cal.Opacity -gt .2) {
                                    $cal.Opacity = $cal.Opacity - .1
                                    $cal.UpdateLayout()
                                }
                            }
                        }
                    }
                })

            $stack = $stack = New-object System.Windows.Controls.StackPanel
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

                $cal.Opacity = 1
                $cal.FontFamily = $font
                $cal.FontSize = 24
                $cal.FontWeight = $FontWeight
                $cal.FontStyle = $fontStyle

                $cal.DisplayDateStart = $month

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
                        $cal | out-string | Write-Host
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
            }

            $btn = New-Object System.Windows.Controls.Button
            $btn.Content = "_Close"
            $btn.Width = 75
            $btn.VerticalAlignment = "Bottom"
            $btn.HorizontalAlignment = "Center"
            $btn.Opacity = 1
            $btn.Add_click( {$form.close()})

            $stack.AddChild($btn)

            $form.AddChild($stack)
            $form.ShowDialog() | out-null
        })


    $pscmd.AddParameters($myparams) | Out-Null
    $psCmd.Runspace = $newRunspace
    Write-Verbose "Invoking calendar runspace"
    $psCmd.BeginInvoke() | Out-Null

    Write-Verbose "Ending $($myinvocation.mycommand)"

} #close Show-GuiCalendar

#a helper function to retrieve names
function Get-MonthsbyCulture {
    [cmdletbinding()]
    Param([string]$Culture = ([system.threading.thread]::currentThread).CurrentCulture)
    Write-Verbose "Getting months for culture $Culture"
    [cultureinfo]::GetCultureInfo($culture).DateTimeFormat.Monthnames
}