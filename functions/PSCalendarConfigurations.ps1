Function Export-PSCalendarConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('None', 'System.Io.FileInfo')]
    [Alias('Save-PSCalendarConfiguration')]
    Param(
        [switch]$Passthru
    )

    Write-Verbose "Starting: $($MyInvocation.MyCommand) [v$modVer]"

    #Hide this metadata when the command is called from another command
    Write-Verbose "Using PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Verbose "Running in PowerShell host: $($host.name)"

    Write-Verbose "Exporting configuration to $configPrefPath"
    #$PSCalendarConfiguration and  $configPath are module scoped variables defined in the root module
    $PSCalendarConfiguration | ConvertTo-Json |
    Out-File -FilePath $configPrefPath -Force -Encoding UTF8
    if ($Passthru -AND (-Not $WhatIfPreference)) {
        Get-Item $ConfigPrefPath
    }
    Write-Verbose "Ending: $($MyInvocation.MyCommand)"
}
