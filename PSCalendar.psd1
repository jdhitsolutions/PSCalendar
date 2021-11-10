# Module manifest for module 'PSCalendar'

@{


    RootModule           = 'PSCalendar.psm1'
    ModuleVersion        = '2.5.0'
    CompatiblePSEditions = @("Desktop", "Core")
    GUID                 = '222beda0-cdb5-464d-bf49-7ab701da86c9'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2018-2021 JDH Information Technology Solutions, Inc. All rights reserved.'
    Description          = 'A PowerShell module to display a calendar in the console.'
    PowerShellVersion    = '5.1'
    RequiredModules      = @("ThreadJob")

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    FormatsToProcess     = @('formats\pscalendarconfiguration.format.ps1xml')
    FunctionsToExport    = if ($PSEdition -eq 'Desktop') {
        "Get-Calendar", "Show-Calendar", "Get-NCalendar", "Show-GuiCalendar", "Show-PSCalendarHelp",
        "Get-PSCalendarConfiguration", "Set-PSCalendarConfiguration"
    }
    else {
        "Get-Calendar", "Show-Calendar", "Get-NCalendar", "Show-PSCalendarHelp",
        "Get-PSCalendarConfiguration", "Set-PSCalendarConfiguration"
    }
    VariablesToExport    = @()
    AliasesToExport      = @('ncal', 'cal', 'gcal', 'scal')

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('calendar', 'reminder', 'wpf')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/jdhitsolutions/PSCalendar/blob/master/license.txt'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/jdhitsolutions/PSCalendar'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/jdhitsolutions/PSCalendar/blob/master/README.md'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

