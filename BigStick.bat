@echo off
setlocal enabledelayedexpansion

:: Change to the desired directory
cd /d C:\Puppy

:: Get the current date and time
for /f "tokens=2 delims==." %%A in ('wmic os get localdatetime /value') do set datetime=%%A

:: Extract components
set yy=!datetime:~2,2!
set mm=!datetime:~4,2!
set dd=!datetime:~6,2!
set hh=!datetime:~8,2!
set mn=!datetime:~10,2!

:: Create log folder if it doesn't exist
if not exist "logs" (
    mkdir logs
)

:: Create log file name
set logfilename=logs\!mm!!dd!!yy!_!hh!!mn!_puppy_log.txt

:: End delayed expansion so the variable is fixed
endlocal & set logfilename=%logfilename%

:: Run your batch commands and log the output using fixed variable
PlayFetch.bat > %logfilename% 2>&1

exit