function Set-PSCalendarConfiguration {
    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None")]
    param (
        [ValidatePattern('\e\[((?:[0-4]|[39]|[49]|3[0-9]|4[0-9]|38;5;\d+|48;5;\d+);?)+m')]
        [string]$Title,
        [ValidatePattern('\e\[((?:[0-4]|[39]|[49]|3[0-9]|4[0-9]|38;5;\d+|48;5;\d+);?)+m')]
        [string]$DayOfWeek,
        [ValidatePattern('\e\[((?:[0-4]|[39]|[49]|3[0-9]|4[0-9]|38;5;\d+|48;5;\d+);?)+m')]
        [string]$Today,
        [ValidatePattern('\e\[((?:[0-4]|[39]|[49]|3[0-9]|4[0-9]|38;5;\d+|48;5;\d+);?)+m')]
        [string]$Highlight
    )

    Write-Verbose "Starting: $($MyInvocation.MyCommand) [v$modVer]"
    Write-Verbose "Using PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Verbose "Running in PowerShell host: $($host.name)"

    $Settings = "Title", "DayOfWeek", "Today", "Highlight"
    foreach ($setting in $Settings) {
        if ($PSBoundParameters.ContainsKey($setting) -AND $PSCmdlet.ShouldProcess($($Setting))) {
            Write-Verbose "Configuring $Setting"
            $PSCalendarConfiguration.$Setting = $PSBoundParameters[$Setting]
        } #if setting and should process

    } #foreach
    Write-Verbose "Ending: $($MyInvocation.MyCommand)"
}
