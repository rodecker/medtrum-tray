# Medtrum Tray

These scripts display glucose status from [Medtrum](https://www.medtrum.com/) sensors in the OSX menu bar or Windows system tray.

## Setup

### Prerequisites

A Medtrum account cannot be logged in on multiple devices at the same time. You will need a separate account to run these scripts.

* Create a new [Medtrum Easy View](https://easyview.medtrum.eu/v3/#/login/login) account
* Add a Connection to the Username/Email of your existing Medtrum user account
* Accept the follower request from the new user in the EasyPatch app

### OSX

* Set up [Homebrew](https://brew.sh/)
* Install jq: `brew install jq`
* Install [xbar](https://xbarapp.com/dl)
* Download `sugar.sh` and configure your credentials
* Copy the script to the xbar plugin folder
* Configure xbar:
  * Select _Start at Login_
  * In the plugin Browser, enable `sugar.sh` and select _Refresh every 1 minutes_

### Windows

* Download `sugar.ps1` and configure your credentials
* Download the [jq](https://github.com/jqlang/jq/releases/) windows executable and place it in the same directory, renamed to `jq.exe`
* Open the Windows Task Scheduler (taskschd.msc) and create a Task (not a Basic Task)
  * Program: `powershell.exe`
  * Arguments: `-WindowStyle hidden -ExecutionPolicy Bypass -File "C:\path\to\sugar.ps1"`
  * Select _Run only when user is logged on_
  * Deselect _Start the task only if the computer is on AC power_ and _Stop if the computer switches to battery power_

## Acknowledgements

Medtrum API endpoints provided by the [GlucoDataHandler (GDH)](https://github.com/pachi81/GlucoDataHandler) project.
