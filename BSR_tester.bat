set mainFolder=C:\Puppy
set "yamlFile=doggo.yaml"

:: Read and parse the YAML file
for /f "usebackq tokens=1* delims=:" %%A in (%yamlFile%) do (
    set "key=%%A"
    set "value=%%B"
    set "key=!key: =!"
    set "value=!value:~1!"

    :: Handle values that may contain colons (e.g., URLs)
    if "!value:~0,8!" == "https://" (
        set "value=https://!value:~8!"
    )

    set "!key!=!value!"
)

:: Verify all entries are found and create an array
set varNames=PlantName SharePointSiteURL SharePointFolderPath

:: Loop through each variable name and check if it's defined
for %%v in (%varNames%) do (
    if defined %%v (
        echo %%v found: !%%v!
    ) else (
        echo %%v not found
    )
)
set "PlantName=This Name"

:: Get the date in MMDDYY format and set subfolder name 
for /f "tokens=2 delims==." %%i in ('wmic os get localdatetime /value') do set "datetime=%%i"
set "date_format=%datetime:~4,2%%datetime:~6,2%%datetime:~2,2%"

"C:\Puppy\PowerShell-7\pwsh.exe" -ExecutionPolicy Bypass -File "C:\Puppy\ScanErrorCounter.ps1" "%date_format%" "%PlantName%"
