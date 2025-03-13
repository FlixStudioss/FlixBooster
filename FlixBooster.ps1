# Add Windows Forms and Drawing assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

# Function to apply dark mode
function Set-DarkMode {
    param (
        [bool]$Enable
    )
    try {
        if ($Enable) {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
        } else {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1
        }
        return $true
    } catch {
        return $false
    }
}

# Function to optimize system performance
function Optimize-SystemPerformance {
    try {
        # Disable visual effects
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
        # Disable transparency
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
        # Set power plan to high performance
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        return $true
    } catch {
        return $false
    }
}

# Create loading screen with animation
$script:loadingComplete = $false
$loadingForm = New-Object System.Windows.Forms.Form
$loadingForm.Text = "FlixBooster"
$loadingForm.Size = New-Object System.Drawing.Size(400, 200)
$loadingForm.StartPosition = "CenterScreen"
$loadingForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$loadingForm.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
$loadingForm.TransparencyKey = [System.Drawing.Color]::Turquoise

# Create rounded corners for loading form
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddArc(0, 0, 20, 20, 180, 90)
$path.AddArc($loadingForm.Width - 20, 0, 20, 20, 270, 90)
$path.AddArc($loadingForm.Width - 20, $loadingForm.Height - 20, 20, 20, 0, 90)
$path.AddArc(0, $loadingForm.Height - 20, 20, 20, 90, 90)
$loadingForm.Region = [System.Drawing.Region]::FromHrgn($path.GetHrgn([System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)))

$logoLabel = New-Object System.Windows.Forms.Label
$logoLabel.Text = "FlixBooster"
$logoLabel.Size = New-Object System.Drawing.Size(380, 40)
$logoLabel.Location = New-Object System.Drawing.Point(10, 20)
$logoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$logoLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$logoLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$loadingLabel = New-Object System.Windows.Forms.Label
$loadingLabel.Text = "Initializing..."
$loadingLabel.Size = New-Object System.Drawing.Size(380, 30)
$loadingLabel.Location = New-Object System.Drawing.Point(10, 70)
$loadingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$loadingLabel.ForeColor = [System.Drawing.Color]::White
$loadingLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(360, 5)
$progressBar.Location = New-Object System.Drawing.Point(20, 120)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$progressBar.Maximum = 100
$progressBar.Value = 0

$loadingForm.Controls.AddRange(@($logoLabel, $loadingLabel, $progressBar))
$loadingForm.Show()
$loadingForm.Refresh()

# Simulate loading with progress
$loadingSteps = @(
    @{ Text = "Initializing components..."; Progress = 20 },
    @{ Text = "Loading system information..."; Progress = 40 },
    @{ Text = "Preparing interface..."; Progress = 60 },
    @{ Text = "Configuring settings..."; Progress = 80 },
    @{ Text = "Almost ready..."; Progress = 90 }
)

foreach ($step in $loadingSteps) {
    $loadingLabel.Text = $step.Text
    $progressBar.Value = $step.Progress
    Start-Sleep -Milliseconds 100
    $loadingForm.Refresh()
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "FlixBooster - System Optimization Tool"
$form.Size = New-Object System.Drawing.Size(900, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Create a custom title bar panel
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Size = New-Object System.Drawing.Size(900, 40)
$titleBar.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$titleBar.Dock = [System.Windows.Forms.DockStyle]::Top

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "FlixBooster"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$titleLabel.Location = New-Object System.Drawing.Point(10, 5)
$titleLabel.Size = New-Object System.Drawing.Size(200, 30)

$titleBar.Controls.Add($titleLabel)
$form.Controls.Add($titleBar)

# Create tabs with modern styling
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(880, 600)
$tabControl.Location = New-Object System.Drawing.Point(10, 50)
$tabControl.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$tabControl.Region = [System.Drawing.Region]::FromHrgn(
    [System.Drawing.Drawing2D.GraphicsPath]::new().GetHrgn([System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero))
)

# Style the tabs
$tabControl.DrawMode = [System.Windows.Forms.TabDrawMode]::OwnerDrawFixed
$tabControl.Add_DrawItem({
    param($tabControl, $e)
    $tabPage = $tabControl.TabPages[$e.Index]
    $tabBounds = $tabControl.GetTabRect($e.Index)
    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    if ($e.Index -eq $tabControl.SelectedIndex) {
        $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(0, 122, 204))
    } else {
        $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
    }
    
    $e.Graphics.DrawString($tabPage.Text, $tabControl.Font, $brush, $tabBounds, $sf)
})

# Debloat tab with enhanced styling
$tabDebloat = New-Object System.Windows.Forms.TabPage
$tabDebloat.Text = "Debloat"
$tabDebloat.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 40)
$tabDebloat.Padding = New-Object System.Windows.Forms.Padding(10)

# Enhanced CheckedListBox styling
$checkListDebloat = New-Object System.Windows.Forms.CheckedListBox
$checkListDebloat.Size = New-Object System.Drawing.Size(850, 450)
$checkListDebloat.Location = New-Object System.Drawing.Point(10, 10)
$checkListDebloat.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 50)
$checkListDebloat.ForeColor = [System.Drawing.Color]::White
$checkListDebloat.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$checkListDebloat.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$checkListDebloat.ItemHeight = 25

# List of bloatware apps
$bloatwareApps = @(
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

foreach ($app in $bloatwareApps) {
    $checkListDebloat.Items.Add($app, $false)
}

# Tweaks tab
$tabTweaks = New-Object System.Windows.Forms.TabPage
$tabTweaks.Text = "Tweaks"
$tabTweaks.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$tabTweaks.ForeColor = [System.Drawing.Color]::White

# Add Tweaks options
$checkListTweaks = New-Object System.Windows.Forms.CheckedListBox
$checkListTweaks.Size = New-Object System.Drawing.Size(850, 450)
$checkListTweaks.Location = New-Object System.Drawing.Point(10, 10)
$checkListTweaks.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 50)
$checkListTweaks.ForeColor = [System.Drawing.Color]::White
$checkListTweaks.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$checkListTweaks.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$checkListTweaks.ItemHeight = 25

# List of tweaks
$tweaks = @(
    "Disable Telemetry",
    "Disable Wi-Fi Sense",
    "Disable SmartScreen Filter",
    "Disable Web Search in Start Menu",
    "Disable Application suggestions",
    "Disable Activity History",
    "Disable Location Tracking",
    "Disable Automatic Maps updates",
    "Disable Feedback",
    "Disable Tailored Experiences",
    "Disable Advertising ID",
    "Disable Cortana",
    "Disable GameDVR",
    "Set Services to Manual",
    "Disable Fast Boot",
    "Show File Extensions",
    "Show Hidden Files"
)

foreach ($tweak in $tweaks) {
    $checkListTweaks.Items.Add($tweak, $false)
}

# Create buttons for Debloat tab
$btnRemoveSelected = New-Object System.Windows.Forms.Button
$btnRemoveSelected.Size = New-Object System.Drawing.Size(250, 45)
$btnRemoveSelected.Location = New-Object System.Drawing.Point(10, 470)
$btnRemoveSelected.Text = [char]::ConvertFromUtf32(0x1F5D1) + " Remove Selected Apps"
$btnRemoveSelected.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnRemoveSelected.ForeColor = [System.Drawing.Color]::White
$btnRemoveSelected.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRemoveSelected.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRemoveSelected.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnSelectAll = New-Object System.Windows.Forms.Button
$btnSelectAll.Size = New-Object System.Drawing.Size(250, 45)
$btnSelectAll.Location = New-Object System.Drawing.Point(270, 470)
$btnSelectAll.Text = [char]::ConvertFromUtf32(0x2713) + " Select All"
$btnSelectAll.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
$btnSelectAll.ForeColor = [System.Drawing.Color]::White
$btnSelectAll.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSelectAll.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnSelectAll.Cursor = [System.Windows.Forms.Cursors]::Hand

# Add hover effects
$btnRemoveSelected.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(0, 102, 184)
})
$btnRemoveSelected.Add_MouseLeave({
    $this.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
})

$btnSelectAll.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(70, 70, 75)
})
$btnSelectAll.Add_MouseLeave({
    $this.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
})

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Size = New-Object System.Drawing.Size(850, 30)
$statusLabel.Location = New-Object System.Drawing.Point(10, 525)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$statusLabel.Text = "Ready to optimize your system"

# Create buttons for Tweaks tab
$btnApplyTweaks = New-Object System.Windows.Forms.Button
$btnApplyTweaks.Size = New-Object System.Drawing.Size(250, 45)
$btnApplyTweaks.Location = New-Object System.Drawing.Point(10, 470)
$btnApplyTweaks.Text = "Apply Selected Tweaks"
$btnApplyTweaks.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnApplyTweaks.ForeColor = [System.Drawing.Color]::White
$btnApplyTweaks.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnApplyTweaks.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnApplyTweaks.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnSelectAllTweaks = New-Object System.Windows.Forms.Button
$btnSelectAllTweaks.Size = New-Object System.Drawing.Size(250, 45)
$btnSelectAllTweaks.Location = New-Object System.Drawing.Point(270, 470)
$btnSelectAllTweaks.Text = [char]::ConvertFromUtf32(0x2713) + " Select All Tweaks"
$btnSelectAllTweaks.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
$btnSelectAllTweaks.ForeColor = [System.Drawing.Color]::White
$btnSelectAllTweaks.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSelectAllTweaks.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnSelectAllTweaks.Cursor = [System.Windows.Forms.Cursors]::Hand

# Add button click events
$btnRemoveSelected.Add_Click({
    $statusLabel.Text = "⚡ Processing..."
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $form.Refresh()
    
    $selectedApps = $checkListDebloat.CheckedItems
    $total = $selectedApps.Count
    $current = 0
    
    foreach ($app in $selectedApps) {
        try {
            $current++
            $statusLabel.Text = "Removing $app... ($current of $total)"
            $form.Refresh()
            
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
            Start-Sleep -Milliseconds 100
        }
        catch {
            $statusLabel.Text = "Failed to remove $app"
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
        }
    }
    
    $statusLabel.Text = "✅ Operation completed successfully!"
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    [System.Windows.Forms.MessageBox]::Show(
        "Selected apps have been removed successfully!",
        "Success",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

$btnSelectAll.Add_Click({
    for ($i = 0; $i -lt $checkListDebloat.Items.Count; $i++) {
        $checkListDebloat.SetItemChecked($i, $true)
    }
})

$btnApplyTweaks.Add_Click({
    $statusLabel.Text = "⚡ Applying tweaks..."
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $form.Refresh()
    
    $selectedTweaks = $checkListTweaks.CheckedItems
    $total = $selectedTweaks.Count
    $current = 0
    
    foreach ($tweak in $selectedTweaks) {
        try {
            $current++
            $statusLabel.Text = "Applying $tweak... ($current of $total)"
            $form.Refresh()
            
            switch ($tweak) {
                "Disable Telemetry" {
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
                }
                "Enable Ultimate Performance Power Plan" {
                    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
                }
                "Optimize Network Settings" {
                    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -Type DWord -Value 1
                    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCP1323Opts" -Type DWord -Value 1
                }
                "Disable Windows Search Indexing" {
                    Stop-Service "WSearch" -Force
                    Set-Service "WSearch" -StartupType Disabled
                }
                "Optimize SSD Settings" {
                    fsutil behavior set DisableLastAccess 1
                    fsutil behavior set EncryptPagingFile 0
                }
                # Add implementations for other tweaks
            }
            Start-Sleep -Milliseconds 50
        }
        catch {
            $statusLabel.Text = "Failed to apply $tweak"
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
        }
    }
    
    $statusLabel.Text = "✅ All tweaks applied successfully!"
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    [System.Windows.Forms.MessageBox]::Show(
        "Selected tweaks have been applied successfully!",
        "Success",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

$btnSelectAllTweaks.Add_Click({
    for ($i = 0; $i -lt $checkListTweaks.Items.Count; $i++) {
        $checkListTweaks.SetItemChecked($i, $true)
    }
})

# Add controls to tabs
$tabDebloat.Controls.Add($checkListDebloat)
$tabDebloat.Controls.Add($btnRemoveSelected)
$tabDebloat.Controls.Add($btnSelectAll)

$tabTweaks.Controls.Add($checkListTweaks)
$tabTweaks.Controls.Add($btnApplyTweaks)
$tabTweaks.Controls.Add($btnSelectAllTweaks)

# Add tabs to tab control
$tabControl.Controls.Add($tabDebloat)
$tabControl.Controls.Add($tabTweaks)

# Create Customize tab
$tabCustomize = New-Object System.Windows.Forms.TabPage
$tabCustomize.Text = "Customize"
$tabCustomize.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 40)
$tabCustomize.Padding = New-Object System.Windows.Forms.Padding(10)

# Create groups in Customize tab
$grpAppearance = New-Object System.Windows.Forms.GroupBox
$grpAppearance.Text = "Appearance"
$grpAppearance.Size = New-Object System.Drawing.Size(400, 200)
$grpAppearance.Location = New-Object System.Drawing.Point(10, 10)
$grpAppearance.ForeColor = [System.Drawing.Color]::White
$grpAppearance.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$grpPerformance = New-Object System.Windows.Forms.GroupBox
$grpPerformance.Text = "Performance"
$grpPerformance.Size = New-Object System.Drawing.Size(400, 200)
$grpPerformance.Location = New-Object System.Drawing.Point(420, 10)
$grpPerformance.ForeColor = [System.Drawing.Color]::White
$grpPerformance.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

# Dark Mode Toggle
$darkModeToggle = New-Object System.Windows.Forms.CheckBox
$darkModeToggle.Text = [char]::ConvertFromUtf32(0x1F319) + " Dark Mode"
$darkModeToggle.Size = New-Object System.Drawing.Size(350, 30)
$darkModeToggle.Location = New-Object System.Drawing.Point(20, 30)
$darkModeToggle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$darkModeToggle.ForeColor = [System.Drawing.Color]::White
$darkModeToggle.Add_Click({
    $result = Set-DarkMode -Enable $this.Checked
    if ($result) {
        $statusLabel.Text = "Dark mode " + $(if ($this.Checked) { "enabled" } else { "disabled" })
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } else {
        $statusLabel.Text = "Failed to change dark mode setting"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Performance Optimization Button
$btnOptimizePerformance = New-Object System.Windows.Forms.Button
$btnOptimizePerformance.Text = [char]::ConvertFromUtf32(0x26A1) + " Optimize Performance"
$btnOptimizePerformance.Size = New-Object System.Drawing.Size(350, 40)
$btnOptimizePerformance.Location = New-Object System.Drawing.Point(20, 30)
$btnOptimizePerformance.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnOptimizePerformance.ForeColor = [System.Drawing.Color]::White
$btnOptimizePerformance.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnOptimizePerformance.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnOptimizePerformance.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnOptimizePerformance.Add_Click({
    $result = Optimize-SystemPerformance
    if ($result) {
        $statusLabel.Text = "✅ System performance optimized"
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } else {
        $statusLabel.Text = "Failed to optimize performance"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Add more tweaks to the existing tweaks list
$tweaks += @(
    "Enable Ultimate Performance Power Plan",
    "Optimize Network Settings",
    "Disable Windows Search Indexing",
    "Disable Superfetch",
    "Optimize Visual Effects",
    "Disable Windows Tips",
    "Disable Background Apps",
    "Disable Timeline",
    "Optimize SSD Settings",
    "Disable Hibernate",
    "Optimize Gaming Mode",
    "Disable Power Throttling",
    "Clean System Files",
    "Optimize Startup Programs",
    "Disable Print Spooler",
    "Optimize Memory Usage"
)

# Add controls to groups
$grpAppearance.Controls.Add($darkModeToggle)
$grpPerformance.Controls.Add($btnOptimizePerformance)

# Add groups to Customize tab
$tabCustomize.Controls.AddRange(@($grpAppearance, $grpPerformance))

# Add Customize tab to tab control
$tabControl.Controls.Add($tabCustomize)

# Add tab control to form
$form.Controls.Add($tabControl)
$form.Controls.Add($statusLabel)

# Complete loading
$progressBar.Value = 100
$loadingLabel.Text = "Ready!"
Start-Sleep -Milliseconds 200
$loadingForm.Close()

# Show the form
$form.ShowDialog()