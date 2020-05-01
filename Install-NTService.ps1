<#
.SYNOPSIS
    Deploy an NT service exe.

.PARAMETER $SourcePath
    The source path of the server build.
	
.PARAMETER $InstallationPath
    The destination path where the server build will be installed.
	Optional: if none provided, source path will double as the installation directory.
	
.PARAMETER $ServiceName
    The name of the exe (no file extension).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [String]$SourcePath,
    [String]$InstallationPath,
    [Parameter(Mandatory=$true)]
    [String]$ServiceName
)

if ([System.String]::IsNullOrWhiteSpace($SourcePath))
{
    $SourcePath = $PSScriptRoot
}

# if no installation path provided, do 'inplace' with source path (not copy files)
$CopyFiles = -not [System.String]::IsNullOrWhiteSpace($InstallationPath)
if( -not $CopyFiles)
{
    $InstallationPath = $SourcePath
}

Write-Host "$ServiceName : Installing $ServiceName service on local machine."
Write-Host "$ServiceName : Installation Path:" $InstallationPath
Write-Host "$ServiceName : Source Path:" $SourcePath

# Delete any prior service.
Write-Host "$ServiceName : Stopping previous service..."
$result = sc.exe stop $ServiceName
$result = sc.exe delete $ServiceName

if ($CopyFiles)
{
    if ([System.IO.Directory]::Exists($InstallationPath))
    {
        Write-Host "$ServiceName : Removing previous installation..."
        Get-ChildItem -Path $InstallationPath -Recurse | Remove-Item -Recurse
    }
    else
    {
        [System.IO.Directory]::CreateDirectory($InstallationPath)
    }

    # Copy over service.
    Write-Host "$ServiceName : Installing files..."
    Copy-Item "$SourcePath\*" $InstallationPath -Recurse
}

# Install service.
Write-Host "$ServiceName : Creating service $ServiceName..."
$result = sc.exe create $ServiceName binpath=$InstallationPath\$ServiceName.exe
 	Write-Host "binpath: $InstallationPath\$ServiceName.exe"
	
if ($result -match "fail")
 {
    Write-Error "$ServiceName : Failed with $result"
    exit 1
}

# Configure service.
Write-Host "$ServiceName : Configuring service..."
$result = sc.exe failure $ServiceName reset= 60 reboot= 'This NT service has failed and will restart' actions= restart/5000/restart/10000
$result = sc.exe config $ServiceName start=auto

# Start service.
Write-Host "$ServiceName : Starting service..."
$result = sc.exe start $ServiceName
if ($result -match "fail")
 {
    Write-Error "$ServiceName : Failed with $result"
    exit 1
}

Write-Host "$ServiceName : Installation of $ServiceName complete!"