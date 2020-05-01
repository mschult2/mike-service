<#
.SYNOPSIS
    Builds the Device Announcer projects App and Service and publishes them to the Release folder.
    Note: if you see "failed to get information" from nuget site, rerunning several times may fix this.
#>
Param
(
    [String]$OutputPath="Publish"
)
Write-Host "Publish: Publishing svc to location: " $OutputPath

dotnet publish MikeService -r win-x64 -c Release -o .\Published\win-x64

Write-Host "Publish: Complete!"