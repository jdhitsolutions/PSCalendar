#these tests are acceptance tests and validate that the module has the
#settings I intend and that the commands work as expected.

#remove any existing versions of the module
$moduleName = (Get-Item -path $PSScriptRoot).Parent.Name
$ModuleManifestName = "$modulename.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

If (Get-Module $moduleName) {
    Remove-Module $moduleName
}

Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
Add-Type -AssemblyName PresentationCore -ErrorAction Stop
write-host "Importing $ModuleManifestpath" -ForegroundColor cyan
Import-Module $ModuleManifestPath -Force

$myModule = Test-ModuleManifest -Path $ModuleManifestPath
Describe "$ModuleName v$($myModule.Version)" {
    $exported = Get-Command -Module $ModuleName -CommandType Function
    Context Manifest {
        It "Passes Test-ModuleManifest" {
            $myModule | Should Not BeNullOrEmpty
        }
        It "Should have a root module" {
            $myModule.RootModule | Should Not BeNullOrEmpty
        }
        It "Contains exported commands" {
            $myModule.ExportedCommands | Should Not BeNullOrEmpty
        }
        It "Should have a module description" {
            $myModule.Description | Should Not BeNullOrEmpty
        }
        It "Should have a company" {
            $myModule.Description | Should Not BeNullOrEmpty
        }
        It "Should have an author of 'Jeff Hicks'" {
            $mymodule.Author | Should Be 'Jeff Hicks'
        }
        It "Should have tags" {
            $mymodule.Tags | Should Not BeNullOrEmpty
        }
        It "Should have a license URI" {
            $mymodule.LicenseUri | should Not BeNullOrEmpty
        }
        It "Should have a project URI" {
            $mymodule.ProjectUri | Should Not BeNullOrEmpty
        }
    }
    Context Exports {

        It "Should have an exported command of $Name" -TestCases @(
         @{Name = 'Get-Calendar'},
         @{Name = 'Show-Calendar'},
         @{Name = 'Show-GuiCalendar'},
         @{Name = 'Get-NCalendar'},
         @{Name = 'Get-MonthName'},
         @{Name= 'Show-PSCalendarHelp'},
         @{Name = 'Get-PSCalendarConfiguration'},
         @{Name = 'Set-PSCalendarConfiguration'}

        ) {
            param($Name)
            $exported.name | Should Contain $Name
        }

        It "Should have an alias of $Name" -TestCases @(
            @{Name='cal';Resolved="Get-Calendar"},
            @{Name='scal';Resolved="Show-Calendar"},
            @{Name='gcal';Resolved="Show-GuiCalendar"},
            @{Name='ncal';Resolved="Get-NCalendar"}
        ) {
            Param($Name,$Resolved)
            (Get-Alias -Name $Name).ResolvedCommandName | Should be $Resolved
        }
 }
    Context Structure {
        It "Should have a Docs folder" {
            Get-Item $PSScriptRoot\..\docs | Should Be $True
        }
        foreach ($cmd in $exported.name) {
            It "Should have a markdown help file for $cmd" {
                Get-Item $PSScriptRoot\..\docs\$cmd.md | Should be $True
            }
        }
        It "Should have an external help file" {
            Get-Item $PSScriptRoot\..\en-us\*.xml | Should Be $True
        }
        It "Should have a license file" {
            Get-Item $PSScriptRoot\..\license.* | Should be $True
        }
        It "Should have a changelog file" {
            Get-Item $PSScriptRoot\..\changelog* | Should be $True
        }
        It "Should have a README.md file" {
            Get-Item $PSScriptRoot\..\README.md | Should be $True
        }
    }
} -Tag module

InModuleScope $moduleName {
    Describe Get-Calendar {

        It "Should run without error with defaults" {
            {Get-Calendar} | Should Not Throw
        }
        It "Should throw an exception with a bad month" {
            {Get-Calendar -month foo} | Should Throw
        }
        It "Should write a STRING to the pipeline" {
            $c = Get-Calendar
            $c | Should beOfType String
        }
        It "Should display the month and year" {
            #use the current month
            $c = Get-Calendar -month January -year 2020
            $c -match "January 2020" | Should be $True
        }
        It "Should fail with a year unless using 4 digits" {
            {get-Calendar -year 2022 } | Should Not Throw
            {Get-Calendar -year 20} | Should Throw
            {Get-Calendar -year 20200} | Should Throw
        }
        It "Should let you highlight a date" {
            $c = Get-Calendar -month January -Year 2022 -HighlightDate 1/1/2022
            $c -match "$([char]27)\[92m\s+\d+" | Should Be $True
        }
        It "Should let you specify a start month and end month" {
            $c = Get-Calendar -Start "1/1/2022" -end "2/1/2022"
            $c.length | Should be 16
            $c -match "January 2022" | Should be $true
            $c -match "February 2022" | Should be $true
        }
    } -tag command

    Describe "Show-Calendar" {
        #TODO - revise this test
           } -tag command

    Describe Show-GuiCalendar {
        It "Should run without error." {
            {Show-GuiCalendar} | Should Not Throw
        } -skip
        It "Should let you customize the layout" {
            Show-GuiCalendar -end (Get-Date).AddMonths(2) -font "Century Gothic" -FontStyle Italic -FontWeight demibold
        } -skip
        It "Should fail with a bad month" {
            {Show-GuiCalendar -start "99/1/2020" } | Should Throw
        }
        It "Should display a warning when specifying more than 3 months" {
            Show-GuiCalendar -start 1/1/2020 -end 6/1/2020 -WarningAction SilentlyContinue -WarningVariable w
            $w | Should Not BeNullOrEmpty
        }
    } -tag command

    Describe Get-NCalendar {
        It "Should run without error." {
            {Get-NCalendar} | Should Not Throw
        }
        It "Should fail with an invalid month" {
            {Get-NCalendar -month FOO} |Should Throw
        }
        It "Should fail with an invalid year" {
            {Get-Ncalendar -year 20} | Should Throw
        }
    } -tag command

    Describe Get-MonthName {
        It "Should run without error." {
            {Get-MonthName} | Should Not Throw
        }
        It "Should return short month names" {
            (Get-MonthName -Short).count |Should Be 12
        }
        It "Should return 12 items" {
            (Get-MonthName).count |Should Be 12
        }
    } -tag command
}

#Write-Host "`n"
#Write-Warning "You will need to manually kill any graphical calendars that were spawned from the test. You may also see errors if running this test under a non-North American culture with differing datetime formats."