
# http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

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
        [switch]$NoANSI
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
            _getCalendar -start $Startd -highlightDates $highlightDate -firstday $FirstDay -noAnsi:$NoANSI

            #And now move onto the next month
            $startd = $startd.AddMonths(1)
        }
    } #process

    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
} #end Get-Calendar

#create a WPF-based calendar

Function Show-GuiCalendar {
    [cmdletbinding(DefaultParameterSetName = "basic")]
    [OutputType("None")]
    [Alias("gcal")]

    Param(
        [Parameter(Position = 1, HelpMessage = "Enter the first month to display by date, like 1/1/2019.")]
        [ValidateNotNullOrEmpty()]
        [string]$Start = (Get-Date -Year $([datetime]::now.year) -Month $([datetime]::now.month) -Day 1).ToShortDateString(),

        [Parameter(Position = 2, HelpMessage = "Enter the last month to display by date, like 3/1/2021. You cannot display more than 3 months.")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( ($_ -as [datetime]) -ge ($Start -as [datetime])) {
                    $True
                }
                else {
                    Throw "The end date ($_) must be later than the start date ($start)"
                    $False
                }
            })]
        [string]$End = (Get-Date -Year $([datetime]::now.year) -Month $([datetime]::now.month) -Day 1).ToShortDateString(),

        [Parameter(HelpMessage = "Enter an array of dates to highlight like 12/25/2021. Or a hashtable with the date as the key and a description for the value.")]
        [object[]]$HighlightDate,

        [Parameter(HelpMessage = "Select a font family for your calendar" )]
        [ValidateSet("Segoi UI", "QuickType", "Tahoma", "Lucida Console", "Century Gothic")]
        [string]$Font = "Segoi UI",

        [Parameter(HelpMessage = "Select a font style for your calendar." )]
        [ValidateSet("Normal", "Italic", "Oblique")]
        [string]$FontStyle = "Normal",

        [Parameter(HelpMessage = "Select a font weight for your calendar." )]
        [ValidateSet("Normal", "DemiBold", "Light", "Bold")]
        [string]$FontWeight = "Normal",

        [Parameter(ParameterSetName = "bgimage", HelpMessage = "Specify the path to an image to use as the background.")]
        [ValidateScript( { Test-Path $_ })]
        [string]$BackgroundImage,

        [Parameter(ParameterSetName = "bgimage", HelpMessage = "Specify image stretch setting.")]
        [ValidateSet("UniformToFill","Uniform","None","Fill")]
        [string]$Stretch = "UniformToFill",

        [Parameter(ParameterSetName = "bgcolor", HelpMessage = "Specify calendar background color.")]
        [string]$BackgroundColor,

        [Parameter(HelpMessage = "Specify the first day of the week.")]
        [ValidateNotNullOrEmpty()]
        [System.DayOfWeek]$FirstDay = ([System.Globalization.CultureInfo]::CurrentCulture).DateTimeFormat.FirstDayOfWeek
    )

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    #PowerShell 7 doesn't support the .NET classes necessary for this function
    #https://github.com/jdhitsolutions/PSCalendar/issues/27
    if ($PSEdition -eq 'Core') {
        Write-Warning "This command is not supported in this version of PowerShell."
        Return
    }
    else {
        Write-Verbose "Running in a supported version of PowerShell."
    }
    $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    Write-Verbose "Using culture: $($currculture.displayname) [$($currCulture.name)]"
    Write-Verbose "Using PSBoundParameters:"
    Write-Verbose ($PSBoundParameters | Out-String).trim()
    Write-Verbose "Getting start date using pattern $($currCulture.DateTimeFormat.ShortDatePattern)"

    #add the necessary type library and bail out if there are errors which means the
    #platform lacks support for WPF

    Write-Verbose "Treating $start as a datetime"
    $startd = $start -as [datetime]
    Write-Verbose "Treating $end as a datetime"
    $endd = $end -as [datetime]
    Write-Verbose "Using Start: $($startd.ToLongDateString())"
    Write-Verbose "Using End: $($endd.ToLongDateString())"
    $months = do {
        $startd
        $startd = $startd.AddMonths(1)
    } while ($startd -le $endd)

    Write-Verbose "Displaying $($months.count) months"
    if ($months.count -gt 3) {
        Write-Warning "You can't display more than 3 months at a time with this command."
        #bail out
        Return
    }

    Try {
        Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
        Add-Type -AssemblyName PresentationCore -ErrorAction Stop
    }
    Catch {
        Write-Warning "Failed to load a required type library. Your version of PowerShell and/or platform may not support WPF. $($_.exception.message)"
        #bail out of the command
        Return
    }

    #the title won't normally be seen but is set for development and test purposes
    $myParams = @{
        Months        = $months
        Height        = (200 * $months.count)
        Title         = "My Calendar"
        HighlightDate = $highlightDate
        Font          = $Font
        FontStyle     = $FontStyle
        FontWeight    = $FontWeight
        FirstDay      = $FirstDay
    }

    if ($PSCmdlet.ParameterSetName -eq 'bgImage') {
        $myParams.add("BackgroundImage", $BackgroundImage)
        $myParams.Add("Stretch", $Stretch)
    }
    elseif ($pscmdlet.ParameterSetName -eq 'bgColor') {
        $myParams.Add("BackgroundColor", $BackgroundColor)
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
                [object[]]$HighlightDate,
                [string]$Font,
                [string]$FontStyle,
                [string]$FontWeight,
                [int]$Height,
                [string]$Title,
                [datetime[]]$Months,
                [string]$BackgroundImage,
                [string]$Stretch,
                [string]$BackgroundColor,
                [string]$FirstDay
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
            #  $form.Background.Color = "green"
            # $form.background.Opacity = 50
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

            $stack = New-Object System.Windows.Controls.StackPanel
            $stack.Width = $form.Width
            $stack.Height = $form.Height
            $stack.HorizontalAlignment = "center"
            $stack.VerticalAlignment = "top"

            #create an array to store calendars so that opacity can be
            #set for multiple calendars in unison
            $myCals = @()
            foreach ($month in $months) {

                $cal = New-Object System.Windows.Controls.Calendar

                If ($HighlightDate[0] -is [hashtable]) {
                    [array]$hl = Foreach ($item in $HighlightDate[0].Keys) {
                        Write-Verbose "Treating $item as a datetime"
                        $item -as [datetime] | Where-Object { $_.month -eq $month.month }
                    }
                    if ($hl.count -gt 0) {
                        $thismonth = $highlightdate[0].GetEnumerator() | Where-Object { ($_.name -as [datetime]).month -eq $month.month }
                        $hltip = ($thismonth.GetEnumerator() | Sort-Object { $_.name -as [datetime] } | Format-Table -HideTableHeaders -AutoSize | Out-String).Trim()
                        if ($hltip -match "\w+") {
                            $cal.ToolTip = $hltip
                        }
                        else {
                            #do this when there is only one matching item
                            $cal.Tooltip = ($thismonth | Format-Table -HideTableHeaders -AutoSize | Out-String).Trim()
                        }
                    }
                    else {
                        #uncomment for dev and debugging
                        #$cal.tooltip = "no dates found for $($month.month)"
                    }
                }
                else {
                    [array]$hl = Foreach ($item in $HighlightDate) {
                        Write-Verbose "Treating $item as a datetime"
                        $item -as [datetime] | Where-Object { $_.month -eq $month.month }
                    }
                    #uncomment for dev and debugging
                    # $cal.tooltip = "array"
                }

                $cal.DisplayMode = "Month"
                $cal.FirstDayOfWeek = $FirstDay

                if ($BackgroundImage) {
                    $calbg = New-Object System.Windows.Media.ImageBrush -ArgumentList $BackgroundImage
                    $calbg.Stretch = $Stretch
                    $cal.Background = $calbg
                }
                elseif ($BackgroundColor) {
                    $cal.Background = $BackgroundColor
                }

                $cal.Opacity = 1.0
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
                if ($hl) {
                    foreach ($d in $hl) {
                        if ($d.month -eq $month.Month) {
                            $cal.SelectedDates.add($d)
                        }
                    }
                }

                $cal.add_DisplayDateChanged( {
                        # add the selected days for the currently displayed month
                        [datetime]$month = $cal.Displaydate
                        if ($hl) {
                            foreach ($d in $hl) {
                                if ($d.month -eq $month.Month) {
                                    $cal.SelectedDates.add($d)
                                }
                            }
                        }
                        $cal.UpdateLayout()
                    })

                $stack.addchild($cal)
                $myCals += $cal
                Remove-Variable hl, hltip -Force
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

#endregion

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

} #end Show-Calendar

Function Get-PSCalendarConfiguration {
    [cmdletbinding()]
    [outputType("PSCalendarConfiguration")]
    Param()

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    if ($IsCoreCLR) {
        $e = '`e'
    }
    else {
        $e = '$([Char]0x1b)'
    }

    [pscustomobject]@{
        PSTypeName = "PSCalendarConfiguration"
        Title      = "$($pscalendarConfiguration.title){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Title.ToCharArray() | Select-Object -Skip 1 ) -join "")
        DayofWeek  = "$($pscalendarConfiguration.DayOfWeek){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.DayOfWeek.ToCharArray() | Select-Object -Skip 1 ) -join "")
        Today      = "$($pscalendarConfiguration.Today){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Today.ToCharArray() | Select-Object -Skip 1 ) -join "")
        Highlight  = "$($pscalendarConfiguration.highlight){0}{1}$esc[0m" -f $e, $(($PSCalendarConfiguration.Highlight.ToCharArray() | Select-Object -Skip 1 ) -join "")
    }
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

function Set-PSCalendarConfiguration {
    [cmdletbinding(SupportsShouldProcess)]
    [outputType("None")]
    param (
        [string]$Title,
        [string]$DayOfWeek,
        [string]$Today,
        [string]$Highlight
    )

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    $Settings = "Title", "DayofWeek", "Today", "Highlight"
    foreach ($setting in $Settings) {
        if ($PSBoundParameters.ContainsKey($setting) -AND $PSCmdlet.ShouldProcess($($Setting))) {
            Write-Verbose "Configuring $Setting"
            $PSCalendarConfiguration.$Setting = $PSBoundParameters[$Setting]
        } #if setting and should process

    } #foreach
    Write-Verbose "Ending $($myinvocation.mycommand)"
}

Function Get-NCalendar {
    [cmdletbinding()]
    [alias("ncal")]
    [Outputtype("String")]

    Param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the full month name. The default is the current month.")]
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
        [Parameter(Position = 1, ValueFromPipelineByPropertyName,
            HelpMessage = "Enter the 4 digit year. The default is the current year.")]
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
    }

    Process {
        Write-Verbose "Using month $month and year $year"

        #get month number
        Write-Verbose "Parsing $month to number"
        $monthint = [datetime]::parse("1 $month $year").month
        Write-Verbose "Returned month number $monthint"
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

        $today = (Get-Date).Date
        for ($i = 0; $i -lt $max; $i++) {
            $day = $startd.AddDays($i).date
            $dayname = "{0:ddd}" -f $day
            if ((-NOT $HideHighlight) -AND ($day -eq $today)) {
                $dom = "$([char]27)[7m$($day.day)$([char]27)[0m"
                $dayLength = $day.day.ToString()
            }
            else {
                $dom = $day.day
            }
            $dayhash[$dayname] += $dom
        }

        #make sure month is in title case
        $head = "$($currculture.TextInfo.toTitleCase($Month)) $Year"
        $maxDayLength = $dayhash.keys.length | Sort-Object | Select-Object -Last 1
        Write-Verbose "Building day hashtable"
        $out = $dayhash.GetEnumerator() |
        ForEach-Object {
            "{0}{1}" -f $_.name.Padright(4), ($_.value.foreach( {
                        $str = $_.tostring()
                        if ($str -match [char]27) {
                            #add extra padding to account for ANSI escape sequence
                            Write-Verbose "Adjusting for ANSI sequence"
                            $ansipad = $str.length - $daylength  #8
                            Write-Verbose "Padding $ansipad"
                            $str = "     $str"
                        }
                        else {
                            $ansipad = 0
                        }
                        $str.padleft(2+$ansipad)
                    }) -join " ").padleft($maxDayLength + 12 + $ansipad)
        }
        Write-verbose "display length = $($out[0].length)"
        #write-Verbose "head length = $($head.length)"
        $pad = (($out[0].length - $head.length) / 2) + $head.length + 1
        #Write-Verbose "padding $pad"
        $head.padleft($pad)
        $out
        #insert a blank line
        "`r"
    }
    End {
        Write-Verbose "Ending $($myinvocation.MyCommand)"
    }
}

Function Get-MonthName {
    [cmdletbinding()]
    Param(
        [Parameter(HelpMessage = "Get short month names")]
        [switch]$Short
    )

    #display the module version defined in the psm1 file
    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    Write-Verbose "Using PowerShell version $($psversiontable.PSVersion)"
    #Call .NET for better results when testing this command in different cultures
    $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    Write-Verbose "Using culture $($currCulture.name)"

    #.NET may append a blank entry so filter that out
    if ($short) {
        Write-Verbose "Getting short month names"
        [system.globalization.cultureinfo]::CurrentCulture.DateTimeFormat.AbbreviatedMonthNames | Where-Object { $_ }
    }
    else {
        [system.globalization.cultureinfo]::CurrentCulture.DateTimeFormat.MonthNames | Where-Object { $_ }
    }

    Write-Verbose "Ending $($myinvocation.MyCommand)"
}