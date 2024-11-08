@echo off
setlocal
set current_dir=%~dp0
set batch_name=%~nx0

:: Create the main folder if it doesn't exist
if not exist "C:\Puppy" (
    mkdir "C:\Puppy"
)

:: Move all files and folders except the batch file
for %%I in ("%current_dir%\*") do (
    if /I not "%%~nxI"=="%batch_name%" (
        move "%%I" "C:\Puppy\"
    )
)

:: Ask the user for input
set /p PlantName=Please enter the Plant Name: 

:: Define a temporary file
set temp_file="%TEMP%\doggoyaml.tmp"

:: Check if doggo.yaml exists, and update or add the PlantName
if exist "C:\Puppy\doggo.yaml" (
    for /f "usebackq tokens=*" %%A in ("C:\Puppy\doggo.yaml") do (
        echo %%A | findstr /b /c:"PlantName:" >nul
        if errorlevel 1 (
            echo %%A>>%temp_file%
        ) else (
            echo PlantName: %PlantName%>>%temp_file%
        )
    )
    move /y %temp_file% "C:\Puppy\doggo.yaml"
) else (
    echo PlantName:%PlantName% > "C:\Puppy\doggo.yaml"
)

:: Call PreflightCheck.bat and check for errors
call "C:\Puppy\PreflightCheck.bat"

:: Create Small Backup task to run everyday and terminate after 8 hours
schtasks /create /tn "\Puppy\Puppy Backup" /tr "cmd.exe /c cd /d C:\Puppy && C:\Puppy\BigStick.bat" /sc daily /st 02:30 /du 08:00 /ri 0 /f /rl LIMITED /it

endlocal