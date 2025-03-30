#these tests are acceptance tests and validate that the module has the
#settings I intend and that the commands work as expected.

BeforeDiscovery {
    #remove any existing versions of the module

    $script:ModuleName = (Get-Item -path $PSScriptRoot).Parent.Name
    $ModuleManifestName = "$script:ModuleName.psd1"
    $script:ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

    If (Get-Module $script:ModuleName) {
        Remove-Module $script:ModuleName
    }

    Add-Type -AssemblyName PresentationFramework -ErrorAction Stop
    Add-Type -AssemblyName PresentationCore -ErrorAction Stop

    Write-host "Importing $script:ModuleManifestPath" -ForegroundColor cyan
    Import-Module $script:ModuleManifestPath -Force
    $script:myModule = Test-ModuleManifest -Path $script:ModuleManifestPath
}

Describe "$script:ModuleName v$($script:myModule.Version) [$($script:myModule.ModuleType)]" {

   Context Manifest {
    BeforeAll {
        $script:ModuleName = (Get-Item -path $PSScriptRoot).Parent.Name
        $ModuleManifestName = "$script:ModuleName.psd1"
        $script:ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"
        $script:myModule = Test-ModuleManifest -Path $script:ModuleManifestPath
        $exported = Get-Command -Module $script:ModuleName -CommandType Function
        #$exported | out-string | write-host -ForegroundColor cyan
    }
        It "$($script:ModuleName) passes Test-ModuleManifest" {
            $script:myModule | Should -Not -BeNullOrEmpty
        }
        It "Should have a root module" {
            $script:myModule.RootModule | Should -Not -BeNullOrEmpty
        }
        It "Contains exported commands" {
            $script:myModule.ExportedCommands | Should -Not -BeNullOrEmpty
        }
        It "Should have a module description" {
            $script:myModule.Description | Should -Not -BeNullOrEmpty
        }
        It "Should have a company" {
            $script:myModule.Description | Should -Not -BeNullOrEmpty
        }
        It "Should have an author of 'Jeff Hicks'" {
            $script:myModule.Author | Should -Be 'Jeff Hicks'
        }
        It "Should have tags" {
            $script:myModule.Tags | Should -Not -BeNullOrEmpty
        }
        It "Should have a license URI" {
            $script:myModule.LicenseUri | Should -Not -BeNullOrEmpty
        }
        It "Should have a project URI" {
            $script:myModule.ProjectUri | Should -Not -BeNullOrEmpty
        }
    }
    Context Exports {
        BeforeAll {
            $script:ModuleName = (Get-Item -path $PSScriptRoot).Parent.Name
            $exported = Get-Command -Module $script:ModuleName -CommandType Function
        }
        It "Should have an exported command of <Name>" -TestCases @(
         @{Name = 'Get-Calendar'},
         @{Name = 'Show-Calendar'},
         @{Name = 'Show-GuiCalendar'},
         @{Name = 'Get-NCalendar'},
         @{Name = 'Get-MonthName'},
         @{Name = 'Show-PSCalendarHelp'},
         @{Name = 'Get-PSCalendarConfiguration'},
         @{Name = 'Set-PSCalendarConfiguration'},
         @{Name = 'Export-PSCalendarConfiguration'}

        ) {
            param($Name)
            $exported.name | Should -Contain $Name
        }

        It "Should have an alias of <Name>" -TestCases @(
            @{Name='cal';Resolved="Get-Calendar"},
            @{Name='mon';Resolved="Get-MonthName"},
            @{Name='ncal';Resolved="Get-NCalendar"},
            @{Name='scal';Resolved="Show-Calendar"},
            @{Name='gcal';Resolved="Show-GuiCalendar"},
            @{Name = 'Save-PSCalendarConfiguration';Resolved="Export-PSCalendarConfiguration"}
        ) {
            Param($Name,$Resolved)
            (Get-Alias -Name $Name).ResolvedCommandName | Should -Be $Resolved
        }
 }
    Context Structure {
        It "Should have a Docs folder" {
            Get-Item $PSScriptRoot\..\docs | Should -Be $True
        }
        foreach ($cmd in $exported.name) {
            It "Should have a markdown help file for $cmd" {
                Get-Item $PSScriptRoot\..\docs\$cmd.md | Should -Be $True
            }
        }
        It "Should have an external help file" {
            Get-Item $PSScriptRoot\..\en-us\*.xml | Should -Be $True
        }
        It "Should have a license file" {
            Get-Item $PSScriptRoot\..\license.* | Should -Be $True
        }
        It "Should have a changelog file" {
            Get-Item $PSScriptRoot\..\changelog* | Should -Be $True
        }
        It "Should have a README.md file" {
            Get-Item $PSScriptRoot\..\README.md | Should -Be $True
        }
    }
} -Tag module

InModuleScope $script:ModuleName {
    Describe Get-Calendar {
        It "Should run without error with defaults" {
            {Get-Calendar} | Should -Not -Throw
        }
        It "Should -Throw an exception with a bad month" {
            {Get-Calendar -month foo} | Should -Throw
        }
        It "Should write a STRING to the pipeline" {
            $c = Get-Calendar
            $c | Should -BeOfType String
        }
        It "Should display the month and year" {
            #use the current month
            $c = Get-Calendar -month January -year 2020
            $c -match "January 2020" | Should -Be $True
        }
        It "Should fail with a year unless using 4 digits" {
            {Get-Calendar -year 2022 } | Should -Not -Throw
            {Get-Calendar -year 20} | Should -Throw
            {Get-Calendar -year 20200} | Should -Throw
        }
        It "Should let you highlight a date" {
            $c = Get-Calendar -month January -Year 2022 -HighLightDate 1/1/2022
            $c -match "$([char]27)\[92m\s+\d+" | Should -Be $True
        }
        It "Should let you specify a start month and end month" {
            $c = Get-Calendar -Start "1/1/2022" -end "2/1/2022"
            $c.length | Should -Be 16
            $c -match "January 2022" | Should -Be $true
            $c -match "February 2022" | Should -Be $true
        }
    } -tag command

    Describe "Show-Calendar" {
        #TODO - revise this test
        It "Should run without error." {
            {Show-Calendar} | Should -Not -Throw
        } -skip
           } -tag command

    Describe Show-GuiCalendar {
        It "Should run without error." {
            {Show-GuiCalendar} | Should -Not -Throw
        } -skip
        It "Should let you customize the layout" {
            Show-GuiCalendar -end (Get-Date).AddMonths(2) -font "Century Gothic" -FontStyle Italic -FontWeight demibold
        } -skip
        It "Should fail with a bad month" {
            {Show-GuiCalendar -start "99/1/2020" } | Should -Throw
        }
        It "Should display a warning when specifying more than 3 months" {
            Show-GuiCalendar -start 1/1/2020 -end 6/1/2020 -WarningAction SilentlyContinue -WarningVariable w
            $w | Should -Not -BeNullOrEmpty
        }
    } -tag command

    Describe Get-NCalendar {
        It "Should run without error." {
            {Get-NCalendar} | Should -Not -Throw
        }
        It "Should fail with an invalid month" {
            {Get-NCalendar -month FOO} |Should -Throw
        }
        It "Should fail with an invalid year" {
            {Get-NCalendar -year 20} | Should -Throw
        }
    } -tag command

    Describe Get-MonthName {
        It "Should run without error." {
            {Get-MonthName} | Should -Not -Throw
        }
        It "Should return short month names" {
            (Get-MonthName -Short).count |Should -Be 12
        }
        It "Should return 12 items" {
            (Get-MonthName).count | Should -Be 12
        }
    } -tag command

    Describe Export-PSCalendarConfiguration {
        It "Should run without error" {

        } -pending
        It "Should create a JSON file" {

        } -pending
    }
}

#Write-Host "`n"
#Write-Warning "You will need to manually kill any graphical calendars that were spawned from the test. You may also see errors if running this test under a non-North American culture with differing DateTime formats."