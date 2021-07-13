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
Add-Type –AssemblyName PresentationCore -ErrorAction Stop

Import-Module $ModuleManifestPath -Force

Describe $ModuleName {
    $myModule = Test-ModuleManifest -Path $ModuleManifestPath
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

        It "Should have an exported command of Get-Calendar" {
            $exported.name | Should Contain "Get-Calendar"
        }
        It "Should have an exported command of Show-Calendar" {
            $exported.name | Should Contain "Show-Calendar"
        }
        It "Should have an exported command of Show-GuiCalendar" {
            $exported.name | Should Contain "Show-GuiCalendar"
        }
        It "Should have an alias of cal" {
            (Get-Alias -Name cal).ResolvedCommandName | Should be "Get-Calendar"
        }
        It "Should have an alias of scal" {
            (Get-Alias -Name scal).ResolvedCommandName | Should be "Show-Calendar"
        }
        It "Should have an alias of gcal" {
            (Get-Alias -Name gcal).ResolvedCommandName | Should be "Show-GuiCalendar"
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
            get-item $PSScriptRoot\..\en-us\*.xml | Should Be $True
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
            {get-Calendar -year 2020 } | Should Not Throw
            {Get-Calendar -year 20} | Should Throw
            {Get-Calendar -year 20200} | Should Throw
        }
        It "Should let you highlight a date" {
            $c = Get-Calendar -month January -Year 2020 -HighlightDate 1/1/2020
            $c -match "\*  1\*" | Should Be $True
        } -skip
        It "Should let you specify a start month and end month" {
            $c = Get-Calendar -Start "1/1/2020" -end "2/1/2020"
            $c.length | Should be 2
            $c -match "January 2020" | Should be $true
            $c -match "February 2020" | Should be $true
        }
    } -tag command

    Describe "Show-Calendar" {
        #TODO - revise this test
           } -tag command

    Describe Show-GuiCalendar {
        It "Should run without error." {
            {Show-GuiCalendar} | Should Not Throw
        }
        It "Should let you customize the layout" {
            Show-GuiCalendar -end (Get-Date).AddMonths(2) -font "Century Gothic" -FontStyle Italic -FontWeight demibold
        }
        It "Should fail with a bad month" {
            {Show-GuiCalendar -start "99/1/2020" } | Should Throw
        }
        It "Should display a warning when specifying more than 3 months" {
            Show-GuiCalendar -start 1/1/2020 -end 6/1/2020 -WarningAction SilentlyContinue -WarningVariable w
            $w | Should Not BeNullOrEmpty
        }
    } -tag command
}

Write-Host "`n"
Write-Warning "You will need to manually kill any graphical calendars that were spawned from the test. You may also see errors if running this test under a non-North American culture with differing datetime formats."