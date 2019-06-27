
# http://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

Function Get-Calendar {

    [cmdletbinding(DefaultParameterSetName = "month")]
    [OutputType([System.String])]
    [Alias("cal")]

    Param(
        [Parameter(Position = 1,ParameterSetName = "month")]
        [ValidateNotNullorEmpty()]
        [ValidateScript( {
                $names = Get-MonthsByCulture
                # ((Get-Culture).DateTimeFormat.MonthNames).Where( {$_ -match "\w+"})
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
        [DateTime]$End,

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
        [DateTime[]]$highlightDates = [datetime]::parse($highlightDate)

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

                #See if we should highlight a specific date
                if ($highlightDates) {
                    $compareDate = New-Object DateTime $currentDay.Year,
                    $currentDay.Month, $currentDay.Day
                    if ($highlightDates -contains $compareDate) {
                        $displayDay = "*" + ("{0,2}" -f $currentDay.Day) + "*"
                    }
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
                #((Get-Culture).DateTimeFormat.MonthNames).Where( {$_ -match "\w+"})
                if ($names -contains $_) {
                    $True
                }
                else {
                    Throw "You entered an invalid month. Valid choices are $($names -join ',')"
                    $False
                }
            })]
        [string]$Month = (Get-Date -format MMMM),

        [Parameter(Position = 2,ParameterSetName = "month")]
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
            $PSBoundParameters.Add($param, $((get-variable -Name $param).value))
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

    #go through each line and write it back to the console using Write-Host
    foreach ($line in $calarray) {
        if ($line -match "\d{4}") {
            #write the line with the month and year
            write-Host $line -ForegroundColor Yellow
        }
        elseif ($line -match "\w{3}|-{3}") {
            #write the day names and underlines
            Write-Host $line -ForegroundColor cyan
        }
        elseif ($line -match "\*") {
            #break apart lines with asterisks
            $week = $line

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
    } #foreach line in calarray
} #end Show-Calendar

Function Show-GuiCalendar {
    [cmdletbinding()]
Param(
[ValidateNotNullOrEmpty()]
[datetime]$Start = [datetime]::new([datetime]::now.year,[datetime]::now.month,1),
[ValidateNotNullOrEmpty()]
[datetime]$End = $start,
[datetime[]]$HighlightDate,
[ValidateSet("Segoi UI","QuickType","Tahoma","Lucida Console","Century Gothic")]
[string]$Font = "Segoi UI",
[ValidateSet("Normal","Italic","Oblique")]
[string]$FontStyle = "Normal",
[ValidateSet("Normal","DemiBold","Light","Bold")]
[string]$FontWeight = "Normal"
)

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


(($myinvocation.MyCommand.ParameterSets).where({$_.name -eq $pscmdlet.ParameterSetName})).parameters |
Select-Object Name,@{Name="Value";Expression={$pscmdlet.GetVariableValue($_.name)}} |
Where-Object Value | foreach-object -begin {$myParams = @{}} -process {
  $myparams.Add($_.name,$_.value)
}

$myparams.add("Months",$months)
$myparams.Add("Height",(200 * $months.count))
$myparams.Add("Title","MyCalendar")

Write-Verbose "Using these parameters"
$myparams | Out-String | Write-Verbose

$newRunspace = [RunspaceFactory]::CreateRunspace()
$newRunspace.ApartmentState = "STA"
$newRunspace.ThreadOptions = "ReuseThread"
$newRunspace.Open()

$psCmd = [PowerShell]::Create().AddScript({

Param (
[datetime]$Start,
[datetime]$End,
[datetime[]]$HighlightDate,
[string]$Font,
[string]$FontStyle,
[string]$FontWeight,
[int]$Height,
[string]$Title,
[datetime[]]$Months
)

#add the necessary type library and bail out if there are errors
#which probably means you are running PowerShell Core
Try {


#create a window form. If this fails, bail out.
$form = New-Object System.Windows.Window

}
Catch {
    Write-Warning "Failed to load a required type library. $($_.exception.message)"
    #bail out
    Return
}

$form.AllowsTransparency = $True
$form.WindowStyle = "none"
#the title won't be shown when window style is set to none
$form.Title = $Title
$form.Height =  $height
$form.Width = 200

$bg = new-object System.Windows.Media.SolidColorBrush

$form.Background = $bg

$form.Background.Color = "green"
$form.background.Opacity = 0

$form.Add_MouseLeftButtonDown({$form.DragMove()})

$form.add_KeyDown({
$_.key | out-string | write-host
switch ($_.key) {
 {'Add','OemPlus' -contains $_} {
    If ($cal.Opacity -lt 1) {
        $cal.Opacity = $cal.opacity + .1
        $cal.UpdateLayout()
        }
    }
{'Subtract','OemMinus' -contains $_} {
    If ($cal.Opacity -gt .2) {
        $cal.Opacity = $cal.Opacity - .1
        $cal.UpdateLayout()
        }
        write-host $cal.Opacity
    }
}
})


$stack = $stack = New-object System.Windows.Controls.StackPanel
$stack.Width = $form.Width
$stack.Height = $form.Height
$stack.HorizontalAlignment = "center"
$stack.VerticalAlignment = "top"

foreach ($month in $months) {
$cal = New-Object System.Windows.Controls.Calendar
$cal.DisplayMode = "Calendar"

$cal.Opacity = 1
$cal.FontFamily = $font
$cal.FontSize = 24
$cal.FontWeight = $FontWeight
$cal.FontStyle= $fontStyle

$cal.DisplayDateStart = $month

$cal.HorizontalAlignment = "center"
$cal.VerticalAlignment = "top"

#$cal.SelectedDate = "9/13/2018"
$cal.SelectionMode = "multipleRange"
if ($highlightdate) {
  foreach ($d in $HighlightDate) {
    if ($d.month -eq $month.Month) {
        $cal.SelectedDates.add($d)

    }
  }
}

$cal.add_DisplayDateChanged({
# add the selected days for the currently displayed month
$cal | out-string | write-host
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
}


$btn = New-Object System.Windows.Controls.Button
$btn.Content = "_Close"
$btn.Width = 75
$btn.VerticalAlignment = "Bottom"
$btn.HorizontalAlignment = "Center"
$btn.Opacity = 1
$btn.Add_click({$form.close()})

$stack.AddChild($btn)

$form.AddChild($stack)
$form.ShowDialog() | out-null
})


$pscmd.AddParameters($myparams) | Out-Null
$psCmd.Runspace = $newRunspace
$psCmd.BeginInvoke() | Out-Null

}


#a helper function to retrieve names
function Get-MonthsbyCulture {
    [cmdletbinding()]
    Param([string]$Culture = ([system.threading.thread]::currentThread).CurrentCulture)
    Write-Verbose "Getting months for culture $Culture"
    [cultureinfo]::GetCultureInfo($culture).DateTimeFormat.Monthnames
}