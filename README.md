# FlixBooster

A simple PowerShell script that helps you remove unwanted bloatware and tweak system settings on Windows computers. It provides a graphical user interface (GUI) to select which applications to remove and apply various system optimizations.

## Features

- **Remove Bloatware**: Uninstall unwanted apps and software from your system.
- **System Tweaks**: Apply useful system optimizations for better performance.
- **GUI Interface**: A simple user interface built with PowerShell and Windows Forms.
  
## Requirements

- **Windows 10/11** (Tested on Windows 10)
- **PowerShell** (Comes pre-installed with Windows)
- **Administrator Privileges**: You need to run the script as an Administrator to remove system apps or make changes.

## How to Use

1. **Run PowerShell as Administrator**:
   - Right-click on the **PowerShell** icon and select **Run as Administrator**.
   
3. **Execute the Script**:
   - In PowerShell, tupe this script:
     ```powershell
     irm "https://github.com/FlixStudioss/FlixBooster/raw/main/FlixBooster.ps1" | iex
     ```
     
4. **Use the GUI**:
   - Once the script is running, the GUI will appear with two main options:
     - **About**: Displays information about the script.
     - **Software Categories**: Allows you to choose between **Installed Apps** and **System Apps** to remove or list.
   
   - You can select apps for removal by clicking on the appropriate buttons.

5. **Confirm Actions**:
   - When removing apps, you'll need to confirm your actions in the PowerShell window or GUI.

## How It Works

- **Get Installed Apps**: Uses `Get-WmiObject` to list installed software from the system.
- **Remove System Apps**: Utilizes `Get-AppxPackage` to list and remove system apps installed via the Windows Store.
- **Tweaks**: Applies basic system optimizations to improve performance.

## Example

### Running the Script:

Once executed, the GUI will display:

- **About**: Click to learn more about the script.
- **Software Categories**: Choose to list either **Installed Apps** or **System Apps** for removal.

## Contribution

Feel free to fork this repository and submit pull requests. Any improvements or feature suggestions are welcome!

## License

This project is open-source under the **MIT License**. You are free to modify and distribute the script as needed.

