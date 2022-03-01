# Module manifest for module 'PSCalendar'

@{


    RootModule           = 'PSCalendar.psm1'
    ModuleVersion        = '2.8.0'
    CompatiblePSEditions = @("Desktop", "Core")
    GUID                 = '222beda0-cdb5-464d-bf49-7ab701da86c9'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2018-2022 JDH Information Technology Solutions, Inc. All rights reserved.'
    Description          = 'A PowerShell module to display a calendar in the console.'
    PowerShellVersion    = '5.1'
    RequiredModules      = @("ThreadJob")

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    FormatsToProcess     = @('formats\pscalendarconfiguration.format.ps1xml')
    FunctionsToExport    = if ($PSEdition -eq 'Desktop') {
        "Get-Calendar", "Show-Calendar", "Get-NCalendar", "Show-GuiCalendar", "Show-PSCalendarHelp",
        "Get-PSCalendarConfiguration", "Set-PSCalendarConfiguration","Get-MonthName"
    }
    else {
        "Get-Calendar", "Show-Calendar", "Get-NCalendar", "Show-PSCalendarHelp",
        "Get-PSCalendarConfiguration", "Set-PSCalendarConfiguration","Get-MonthName"
    }
    VariablesToExport    = @()
    AliasesToExport      = @('ncal', 'cal', 'gcal', 'scal')

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{
            Tags         = @('calendar', 'reminder', 'wpf', 'ncal')
            LicenseUri   = 'https://github.com/jdhitsolutions/PSCalendar/blob/master/license.txt'
            ProjectUri   = 'https://github.com/jdhitsolutions/PSCalendar'
            # IconUri = ''
            ReleaseNotes = 'https://github.com/jdhitsolutions/PSCalendar/blob/master/README.md'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

}

