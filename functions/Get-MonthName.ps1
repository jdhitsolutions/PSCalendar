Function Get-MonthName {
    [cmdletbinding()]
    [OutputType("string")]
    [Alias("mon")]
    Param(
        [Parameter(HelpMessage = "Get short month names")]
        [switch]$Short
    )

    #display the module version defined in the psm1 file
    Write-Verbose "Starting: $($MyInvocation.MyCommand) [v$modVer]"
    Write-Verbose "Using PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Verbose "Running in PowerShell host: $($host.name)"
    #Call .NET for better results when testing this command in different cultures
    $currCulture = [System.Globalization.CultureInfo]::CurrentCulture
    Write-Verbose "Using culture: $($currCulture.DisplayName) [$($currCulture.name)]"

    #.NET may append a blank entry so filter that out
    if ($short) {
        Write-Verbose "Getting short month names"
        [System.Globalization.CultureInfo]::CurrentCulture.DateTimeFormat.AbbreviatedMonthNames | Where-Object { $_ }
    }
    else {
        [System.Globalization.CultureInfo]::CurrentCulture.DateTimeFormat.MonthNames | Where-Object { $_ }
    }

    Write-Verbose "Ending: $($MyInvocation.MyCommand)"
}
