<#
.SYNOPSIS
    Build the service.
	If you failure from NuGet about not getting dependencies, try rebuilding
#>
Param
(
    [String]$OutputPath="Publish"
)
Write-Host "Publish: Publishing svc to location: " $OutputPath

dotnet publish MikeService -r win-x64 -c Release -o .\Published\win-x64

Write-Host "Publish: Complete!"