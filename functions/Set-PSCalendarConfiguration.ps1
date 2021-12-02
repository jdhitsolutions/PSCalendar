function Set-PSCalendarConfiguration {
    [cmdletbinding(SupportsShouldProcess)]
    [outputType("None")]
    param (
        [string]$Title,
        [string]$DayOfWeek,
        [string]$Today,
        [string]$Highlight
    )

    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    $Settings = "Title", "DayofWeek", "Today", "Highlight"
    foreach ($setting in $Settings) {
        if ($PSBoundParameters.ContainsKey($setting) -AND $PSCmdlet.ShouldProcess($($Setting))) {
            Write-Verbose "Configuring $Setting"
            $PSCalendarConfiguration.$Setting = $PSBoundParameters[$Setting]
        } #if setting and should process

    } #foreach
    Write-Verbose "Ending $($myinvocation.mycommand)"
}
