# Parameters
param (
    [string]$PlantName,
    [string]$SharePointSiteURL,
    [string]$SharePointFolderPath,
    [string]$FolderToUpload
)

# The PFX must be married to AzAppID in Azure
$AzAppID = 'e4601a05-7658-4b08-b30e-e76d3f7143d2'
$PathToPFX = 'C:\Puppy\puppyCert.pfx'

# Disable updates
$env:PNPPOWERSHELL_DISABLETELEMETRY=$true
$env:PNPPOWERSHELL_UPDATECHECK=$false

# Connect to SharePoint Online
Connect-PnPOnline -ClientId $AzAppID -CertificatePath $PathToPFX -Url $SharePointSiteURL -Tenant "omnisharp.onmicrosoft.com"
#  Connect-PnPOnline -ClientId fefe3735-738e-445c-acc6-8fd9d21befe1 -CertificatePath 'C:\Users\Luke Starbuck\TestApp.pfx' -Url https://omnisharp.sharepoint.com -Tenant "omnisharp.onmicrosoft.com"

# Function to create a folder in SharePoint
function Create-SharePointFolder {
    param (
        [string]$path
    )

    $folders = $path -split '/'
    $currentPath = ""

    foreach ($folder in $folders) {
        if ($folder -ne "") {
            $currentPath = "$currentPath/$folder"
            try {
                $existingFolder = Get-PnPFolder -Url $currentPath -ErrorAction Stop
                Write-Host "Folder already exists: $currentPath"
            } catch {
                Add-PnPFolder -Name $folder -Folder $currentPath.Substring(0, $currentPath.LastIndexOf('/'))
                Write-Host "Created folder: $currentPath"
            }
        }
    }
}

# Construct the full SharePoint path
$fullSharePointPath = "$SharePointFolderPath/$PlantName/$((Get-Item $FolderToUpload).Name)"

# Create the full SharePoint path
Create-SharePointFolder -path $fullSharePointPath

# Function to upload files and folders recursively
function Upload-Folder {
    param (
        [string]$localPath,
        [string]$sharePointPath
    )

    # Get all items (files and folders) in the current directory
    $items = Get-ChildItem -Path $localPath

    foreach ($item in $items) {
        $destinationPath = "$sharePointPath/$($item.Name)"
        
        if ($item.PSIsContainer) {
            # If the item is a directory, create it in SharePoint and upload its contents recursively
            try {
                $existingFolder = Get-PnPFolder -Url $destinationPath -ErrorAction Stop
                Write-Host "Folder already exists: $destinationPath"
            } catch {
                Add-PnPFolder -Name $item.Name -Folder $sharePointPath
                Write-Host "Created folder: $destinationPath"
            }
            Upload-Folder -localPath $item.FullName -sharePointPath $destinationPath
        } else {
            # If the item is a file, upload it to SharePoint
            Add-PnPFile -Path $item.FullName -Folder $sharePointPath
            Write-Host "Uploaded file: $($item.FullName) to $destinationPath"
        }
    }
}

# Start uploading the folder recursively
Upload-Folder -localPath $FolderToUpload -sharePointPath $fullSharePointPath

Write-Host "All files and folders uploaded successfully."
