# Module manifest for module 'PSCalendar'

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = 'PSCalendar.psm1'

    # Version number of this module.
    ModuleVersion        = '2.4.0'

    # Supported PSEditions
    CompatiblePSEditions = @("Desktop", "Core")

    # ID used to uniquely identify this module
    GUID                 = '222beda0-cdb5-464d-bf49-7ab701da86c9'

    # Author of this module
    Author               = 'Jeff Hicks'

    # Company or vendor of this module
    CompanyName          = 'JDH Information Technology Solutions, Inc.'

    # Copyright statement for this module
    Copyright            = '(c) 2018-2021 JDH Information Technology Solutions, Inc. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'A PowerShell module to display a calendar in the console.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @("ThreadJob")

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @('formats\pscalendarconfiguration.format.ps1xml')

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = if ($PSEdition -eq 'Desktop') {
        "Get-Calendar","Show-Calendar","Get-NCalendar","Show-GuiCalendar","Show-PSCalendarHelp"
    }
    else {
        "Get-Calendar","Show-Calendar","Get-NCalendar","Show-PSCalendarHelp"
    }

    # Variables to export from this module
    VariablesToExport    = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = @('ncal','cal','gcal','scal')

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

