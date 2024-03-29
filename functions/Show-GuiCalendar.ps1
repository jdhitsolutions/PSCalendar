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
        [ValidateSet("UniformToFill", "Uniform", "None", "Fill")]
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

}
