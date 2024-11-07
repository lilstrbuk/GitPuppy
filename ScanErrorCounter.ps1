param (
    [string]$date_format,
    [string]$PlantName
)

$errorFolders = Get-ChildItem -Path 'C:\OmniSharp\Runtime Data\BAD KNIFE SCANS' -Directory

$output = @()

foreach ($folder in $errorFolders) {
    $errorCode = $folder.Name
    $zipFiles = Get-ChildItem -Path $folder.FullName -Filter '*.zip'
    
    foreach ($zipFile in $zipFiles) {
        $creationTime = (Get-Item $zipFile.FullName).CreationTime
        $primaryOrSecondary = $zipFile.Name.Substring(0, 1)

        $output += [PSCustomObject]@{
            "Error Code"          = $errorCode
            "Pri or Sec" = if ($primaryOrSecondary -eq 'P') { 'Primary' } elseif ($primaryOrSecondary -eq 'S') { 'Secondary' } else { 'Unknown' }
            "Zip File"       = $zipFile.Name
            "Creation Time"       = $creationTime
        }
    }
}

# Output the results
$output | Sort-Object ErrorCode, CreationTime | Format-Table -AutoSize

# Optional: Export results to CSV
$output | Sort-Object ErrorCode, CreationTime | Export-Csv -Path "C:\OmniSharp\Runtime Data\$date_format $PlantName BSR.csv" -NoTypeInformation
