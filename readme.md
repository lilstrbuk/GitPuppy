# Puppy Backup Script Suite

## Overview

This suite of scripts is used to automate the backup process of the Omnisharp KSM. It is designed to create a local backup, optionally perform "Big" backups on certain days, and subsequently upload the data to SharePoint.

### Files in the Suite

1. **BackupScript.bat**: Main backup script that orchestrates the backup and upload process.
2. **Litter.bat**: Script to handle copying the most recent configuration and calibration files.
3. **RoboPuppy.bat**: Script to retrieve calibration data from robot controllers.
4. **SharingIsCaring.ps1**: PowerShell script for uploading backup folders to SharePoint.
5. **CopyRecentFiles.ps1**: PowerShell script that copies the most recent files from a source folder to a specified destination.
6. **PreflightCheck.bat**: Script to verify prerequisites before proceeding with the backup.
7. **CreateConfig.bat**: Script to create a configuration file if it doesn't already exist.

## Usage

### Prerequisites

- Windows OS with PowerShell installed.
- PowerShell 7 (`pwsh.exe`) is required to run some PowerShell scripts.
- Proper network access to robot controllers.
- Access credentials for network drives and SharePoint.
- The following folders should exist before running the script:
  - `C:\Puppy`
  - `C:\OmniSharp`

### Running the Backup Process

1. **BackupScript.bat** is the main script that should be run to initiate the backup process. It handles the following tasks:
   - Calls **PreflightCheck.bat** to ensure system readiness.
   - Checks for the existence of the `doggo.yaml` configuration file, and creates it using **CreateConfig.bat** if it's missing.
   - Reads values from `doggo.yaml` to set up SharePoint details.
   - Generates a unique folder for the current backup.
   - Copies various log and configuration files into the newly created backup folder.
   - If it's Tuesday or Saturday, calls **Litter.bat** and **RoboPuppy.bat** for additional files.
   - Uploads the backup to SharePoint using **SharingIsCaring.ps1**.

### Script Details

#### 1. BackupScript.bat

- Calls **PreflightCheck.bat** to verify system prerequisites.
- Verifies if the `doggo.yaml` configuration file exists. If not, exits with an error.
- Reads and parses `doggo.yaml` to get configuration values.
- Sets up backup subfolders based on the day of the week:
  - **Big Backups**: Done on Tuesday and Saturday.
- Copies specific log files and datasets.
- Calls **Litter.bat** and **RoboPuppy.bat** if a "Big" backup is needed.
- Uploads the backup folder to SharePoint using **SharingIsCaring.ps1**.

#### 2. Litter.bat

- Copies the most recent 10 files from specific directories to the backup folder.
- Uses **CopyRecentFiles.ps1** to perform the copying of recent files from directories like `Config Backups` and `Gripper Cal Force Data`.
- Copies all contents of the `NNET` and `Vision Templates` directories to the backup folder.

#### 3. RoboPuppy.bat

- Maps network drives to primary and secondary robot controllers using credentials.
- Copies calibration files from the robot controllers to the backup folder.
- Unmaps the network drives after copying is complete.

### Configuration File (doggo.yaml)

The configuration file `doggo.yaml` is used to provide key settings for the backup process. It must contain the following keys:

- **PlantName**: The name of the plant to include in folder names.
- **SharePointSiteURL**: The URL of the SharePoint site for uploading backups.
- **SharePointFolderPath**: The folder path on SharePoint where backups will be uploaded.

### Network Drive Mapping

- **RoboPuppy.bat** maps network drives to the KUKA robot controllers.
- The network drive paths and credentials are defined as variables within **RoboPuppy.bat**.
- The drives are mapped up to 2 times before the process aborts if unsuccessful.

### Uploading to SharePoint

- The **SharingIsCaring.ps1** script is responsible for uploading the backup folder to the SharePoint server.
- It accepts parameters like the plant name, SharePoint site URL, folder path, and the local folder to be uploaded.

## Scheduling Backups

To automate the backups, use Windows Task Scheduler to schedule **BackupScript.bat**:

- **Daily Backups**: Schedule for non-Tuesday and non-Saturday days to perform regular backups.
- **Big Backups**: Schedule for Tuesday and Saturday to collect more data and run additional scripts.

## Troubleshooting

- If **PreflightCheck.bat** fails, verify that all Puppy files are present.
- Ensure proper network connectivity for mapping drives to robot controllers.
- If **doggo.yaml** is missing, run **CreateConfig.bat** to generate the configuration.

## Example

Here is how to run the backup script manually:

```sh
PlayFetch.bat
```

Make sure to adjust configurations as needed and have network access to all required systems before running.

## Author

**Luke Starbuck**

For any queries or support, feel free to reach out.

