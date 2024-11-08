# Puppy Backup Script Suite

## Overview

This suite of scripts is used to automate the backup process of the Puppy system data. It is designed to create a local backup, optionally perform "Big" backups on certain days, and subsequently upload the data to SharePoint.

### Files in the Suite

1. **PlayFetch.bat**: Main backup script that orchestrates the backup and upload process.
2. **Litter.bat**: Script to handle copying the most recent configuration and calibration files.
3. **RoboPuppy.bat**: Script to retrieve calibration data from robot controllers.
4. **SharingIsCaring.ps1**: PowerShell script for uploading backup folders to SharePoint.
5. **CopyRecentFiles.ps1**: PowerShell script that copies the most recent files from a source folder to a specified destination.
6. **PreflightCheck.bat**: Script to verify prerequisites before proceeding with the backup.
7. **CreateConfig.bat**: Script to create a configuration file if it doesn't already exist.
8. **InstallerPuppy.bat**: Installs the Puppy system by moving files to the appropriate directory and setting up a daily scheduled task for backup.
9. **BigStick.bat**: Handles logging and executes **PlayFetch.bat** to create and save logs of the process.

## Files Retrieved by Backup Process

### Normal Backup

- **knife\_counts.olog** from `C:\OmniSharp\Runtime Data\LOGS`
- **knivesperhour.csv** from `C:\OmniSharp\Runtime Data`
- **Grind\_Everything.txt** from `C:\OmniSharp`
- **users.ouf** from `C:\OmniSharp`

### Big Backup (Tuesday and Saturday)

- **Config Backups** (most recent 10 files) from `C:\OmniSharp\Config Backups`
- **Gripper Cal Force Data\Fail** (most recent 10 files) from `C:\OmniSharp\DATA\Gripper Cal Force Data\Fail`
- **Gripper Cal Force Data\Pass** (most recent 10 files) from `C:\OmniSharp\DATA\Gripper Cal Force Data\Pass`
- **NNET** (all contents) from `C:\OmniSharp\DATA\NNET`
- **Vision Templates** (all contents) from `C:\OmniSharp\DATA\Vision Templates`
- **cal\_bases\_and\_tools.src** and **cal\_bases\_and\_tools.dat** from `Z:\Program\Machine Specific` (primary controller)
- **cal\_bases\_and\_tools.src** and **cal\_bases\_and\_tools.dat** from `Y:\Program\Machine Specific` (secondary controller)

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

1. **PlayFetch.bat** It handles the following tasks:
   - Calls **PreflightCheck.bat** to ensure system readiness.
   - Checks for the existence of the `doggo.yaml` configuration file, and creates it using **CreateConfig.bat** if it's missing.
   - Reads values from `doggo.yaml` to set up SharePoint details.
   - Generates a unique folder for the current backup.
   - Copies various log and configuration files into the newly created backup folder.
   - If it's Tuesday or Saturday, calls **Litter.bat** and **RoboPuppy.bat** for additional files.
   - Uploads the backup to SharePoint using **SharingIsCaring.ps1**.

### Running the Installer

**InstallerPuppy.bat** can be used to install the Puppy system. It performs the following tasks:

- Moves all necessary files to the `C:\Puppy` directory.
- Prompts the user to enter the **PlantName**, which is then added to the `doggo.yaml` configuration file.
- Calls **PreflightCheck.bat** to verify prerequisites.
- Schedules a daily backup task named **Puppy Backup** to run **BigStick.bat** at 2:33 AM and terminate after 8 hours.

### Logging with BigStick.bat

**BigStick.bat** handles the logging of the backup process:

- Creates a log file in the `logs` directory with the current date and time in the filename.
- Executes **PlayFetch.bat**, logging all output to the log file for future reference.

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

To automate the backups, use Windows Task Scheduler to schedule **PlayFetch.bat**:

- **Daily Backups**: Schedule for non-Tuesday and non-Saturday days to perform regular backups.
- **Big Backups**: Schedule for Tuesday and Saturday to collect more data and run additional scripts.

## Troubleshooting

- If **PreflightCheck.bat** fails, verify that all system requirements are met.
- Ensure proper network connectivity for mapping drives to robot controllers.
- If **doggo.yaml** is missing, run **CreateConfig.bat** to generate the configuration.
- Make sure PowerShell scripts have appropriate permissions.

## Example

Here is how to run the backup script manually:

```sh
PlayFetch.bat
```

Make sure to adjust configurations as needed and have network access to all required systems before running.


## Author

**Luke Starbuck**

For any queries or support, feel free to reach out.

