<#
.SYNOPSIS
    Removes and uninstalls an NT service.

.PARAMETER $InstallationPath
    The target path where the installed service exists - files will be removed.
    Optional: If path is null or empty no files are removed.
#>
[CmdletBinding()]
param
(
    [Parameter(Mandatory=$true)]
    [String]$ServiceName,
    [String]$InstallationPath
)

# Check if the installation should be 'inplace' (not touch files)
$RemoveFiles = -not [System.String]::IsNullOrWhiteSpace($InstallationPath)

Write-Host "$ServiceName : Uninstalling service"
Write-Host "$ServiceName : Installation Path:" $InstallationPath

# Delete any prior service.
Write-Host "$ServiceName : Stopping previous service..."
$result = sc.exe stop $ServiceName
$result = sc.exe delete $ServiceName
if ($RemoveFiles)
{
    if ([System.IO.Directory]::Exists($InstallationPath))
    {
        Write-Host "$ServiceName : Removing previous installation..."
        Get-ChildItem -Path $InstallationPath -Recurse | Remove-Item -Recurse
        Remove-Item $InstallationPath
    }
}

Write-Host "$ServiceName : Uninstallation complete!"