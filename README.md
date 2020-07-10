# Build

Run Publish-NTService.ps1 to build. Can also build from Visual Studio project Publish Profile (preferable to select self-contained executable).

# Deploy

Run service with the following commands from cmd:

1. sc create SERVICE_NAME binpath=EXE_PATH
2. sc start SERVICE_NAME

You can configure it to autostart, too:

1. sc failure SERVICE_NAME reset= 60 reboot= 'This NT service has failed and will restart' actions= restart/5000/restart/10000
2. sc config SERVICE_NAME start=auto

Once done, you can uninstall it:

1. sc stop SERVICE_NAME
2. sc delete SERVICE_NAME