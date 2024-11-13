@echo off
:: Enable error handling
setlocal enabledelayedexpansion

set "sub_folder=%~1"

:: Create the new subfolders
mkdir "%sub_folder%\robo\primary"
if errorlevel 0 (
    echo Subfolder created successfully: %sub_folder%\robo\primary
) else (
    echo Failed to create subfolder.
    exit /b 1
)

mkdir "%sub_folder%\robo\secondary"
if errorlevel 0 (
    echo Subfolder created successfully: %sub_folder%\robo\secondary
) else (
    echo Failed to create subfolder.
    exit /b 1
)

:: Define Kuka Paths and credentials
:definePaths
set share1=\\192.168.10.18\r1
set share2=\\192.168.10.28\r1
set username=kukauser
set password=68kuka1secpw59
set attempts=0

:: Function to find an available drive letter
:findAvailableDrive
setlocal
for %%D in (Z Y X W V U T S R Q P O N M L K J I H G F E D C B A) do (
    if not exist %%D:\ (
        endlocal & set availableDrive=%%D
        goto :eof
    )
)
echo Error: No available drive letters found.
exit /b 1

:: Map the network drives with credentials
:mapDrives
set /a attempts+=1
if %attempts% GTR 2 (
    echo Error: Exceeded maximum number of attempts to map network drives.
    goto afterKuka
)

:: Map primary drive (Z:)
if exist Z:\ (
    echo Z: drive is already in use. Finding an alternate drive letter...
    call :findAvailableDrive
    echo Mapping primary share to %availableDrive% instead of Z:
    net use %availableDrive%: %share1% /user:%username% %password% /persistent:no
    if errorlevel 1 (
        echo Error: Failed to map primary robot to %availableDrive%.
        goto kukaerrorHandler
    )
    set primaryDrive=%availableDrive%
) else (
    echo Mapping Z: Drive
    net use Z: %share1% /user:%username% %password% /persistent:no
    if errorlevel 1 (
        echo Error: Failed to map primary robot to Z:.
        goto kukaerrorHandler
    )
    set primaryDrive=Z
)

:: Map secondary drive (Y:)
if exist Y:\ (
    echo Y: drive is already in use. Finding an alternate drive letter...
    call :findAvailableDrive
    echo Mapping secondary share to %availableDrive% instead of Y:
    net use %availableDrive%: %share2% /user:%username% %password% /persistent:no
    if errorlevel 1 (
        echo Error: Failed to map secondary robot to %availableDrive%.
        goto kukaerrorHandler
    )
    set secondaryDrive=%availableDrive%
) else (
    echo Mapping Y: Drive
    net use Y: %share2% /user:%username% %password% /persistent:no
    if errorlevel 1 (
        echo Error: Failed to map secondary robot to Y:.
        goto kukaerrorHandler
    )
    set secondaryDrive=Y
)

goto afterKuka

:kukaerrorHandler
echo An error occurred while mapping network drives.
echo Attempting to delete the network drives...

:: Attempt to delete the network drives
net use %primaryDrive%: /delete
net use %secondaryDrive%: /delete

:: Retry mapping the network drives
goto mapDrives

:: Once controllers are connected copy files
:afterKuka
:: PRIMARY Copy robo cal files from controller to destination
copy "%primaryDrive%:\Program\Machine Specific\cal_bases_and_tools.src" "%sub_folder%\robo\primary\cal_bases_and_tools.src"
if errorlevel 0 (
    echo cal_bases_and_tools.src copied successfully from primary controller.
) else (
    echo Failed to copy cal_bases_and_tools.src from primary controller.
)

copy "%primaryDrive%:\Program\Machine Specific\cal_bases_and_tools.dat" "%sub_folder%\robo\primary\cal_bases_and_tools.dat"
if errorlevel 0 (
    echo cal_bases_and_tools.dat copied successfully from primary controller.
) else (
    echo Failed to copy cal_bases_and_tools.dat from primary controller.
)

:: SECONDARY Copy robo cal files from controller to destination
copy "%secondaryDrive%:\Program\Machine Specific\cal_bases_and_tools.src" "%sub_folder%\robo\secondary\cal_bases_and_tools.src"
if errorlevel 0 (
    echo cal_bases_and_tools.src copied successfully from secondary controller.
) else (
    echo Failed to copy cal_bases_and_tools.src from secondary controller.
)

copy "%secondaryDrive%:\Program\Machine Specific\cal_bases_and_tools.dat" "%sub_folder%\robo\secondary\cal_bases_and_tools.dat"
if errorlevel 0 (
    echo cal_bases_and_tools.dat copied successfully from secondary controller.
) else (
    echo Failed to copy cal_bases_and_tools.dat from secondary controller.
)

:: Disconnect the mapped network drives
net use %primaryDrive%: /delete
net use %secondaryDrive%: /delete

:end
exit /b 0
