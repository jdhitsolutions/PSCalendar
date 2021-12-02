Function Get-MonthName {
    [cmdletbinding()]
    [outputtype("string")]
    Param(
        [Parameter(HelpMessage = "Get short month names")]
        [switch]$Short
    )

    #display the module version defined in the psm1 file
    Write-Verbose "Starting $($myinvocation.MyCommand) [v$modver]"
    Write-Verbose "Using PowerShell version $($psversiontable.PSVersion)"
    #Call .NET for better results when testing this command in different cultures
    $currCulture = [system.globalization.cultureinfo]::CurrentCulture
    Write-Verbose "Using culture $($currCulture.name)"

    #.NET may append a blank entry so filter that out
    if ($short) {
        Write-Verbose "Getting short month names"
        [system.globalization.cultureinfo]::CurrentCulture.DateTimeFormat.AbbreviatedMonthNames | Where-Object { $_ }
    }
    else {
        [system.globalization.cultureinfo]::CurrentCulture.DateTimeFormat.MonthNames | Where-Object { $_ }
    }

    Write-Verbose "Ending $($myinvocation.MyCommand)"
}
