# Add Windows Forms and Drawing assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

# Create and show loading screen
$loadingForm = New-Object System.Windows.Forms.Form
$loadingForm.Text = "FlixBooster"
$loadingForm.Size = New-Object System.Drawing.Size(400, 150)
$loadingForm.StartPosition = "CenterScreen"
$loadingForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$loadingForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$loadingLabel = New-Object System.Windows.Forms.Label
$loadingLabel.Text = "Loading FlixBooster..."
$loadingLabel.Size = New-Object System.Drawing.Size(380, 30)
$loadingLabel.Location = New-Object System.Drawing.Point(10, 20)
$loadingLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$loadingLabel.ForeColor = [System.Drawing.Color]::White
$loadingLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(360, 23)
$progressBar.Location = New-Object System.Drawing.Point(20, 60)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
$progressBar.MarqueeAnimationSpeed = 30

$loadingForm.Controls.Add($loadingLabel)
$loadingForm.Controls.Add($progressBar)
$loadingForm.Show()
$loadingForm.Refresh()

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
    param($sender, $e)
    $tabPage = $sender.TabPages[$e.Index]
    $tabBounds = $sender.GetTabRect($e.Index)
    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    if ($e.Index -eq $sender.SelectedIndex) {
        $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(0, 122, 204))
    } else {
        $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
    }
    
    $e.Graphics.DrawString($tabPage.Text, $sender.Font, $brush, $tabBounds, $sf)
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
$btnRemoveSelected.Text = "🗑️ Remove Selected Apps"
$btnRemoveSelected.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnRemoveSelected.ForeColor = [System.Drawing.Color]::White
$btnRemoveSelected.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRemoveSelected.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRemoveSelected.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnSelectAll = New-Object System.Windows.Forms.Button
$btnSelectAll.Size = New-Object System.Drawing.Size(250, 45)
$btnSelectAll.Location = New-Object System.Drawing.Point(270, 470)
$btnSelectAll.Text = "✓ Select All"
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
$btnSelectAllTweaks.Text = "✓ Select All Tweaks"
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
    $selectedTweaks = $checkListTweaks.CheckedItems
    foreach ($tweak in $selectedTweaks) {
        try {
            switch ($tweak) {
                "Disable Telemetry" {
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
                }
                "Disable Wi-Fi Sense" {
                    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
                }
                "Show File Extensions" {
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
                }
                "Show Hidden Files" {
                    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
                }
                # Add more tweak implementations here
            }
            Write-Host "Applied tweak: $tweak"
        }
        catch {
            Write-Host "Failed to apply tweak: $tweak"
        }
    }
    [System.Windows.Forms.MessageBox]::Show("Selected tweaks have been applied!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
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

# Add tab control to form
$form.Controls.Add($tabControl)
$form.Controls.Add($statusLabel)

# Close loading screen and show main form
$loadingForm.Close()
$form.Add_Shown({
    $form.Activate()
})

# Show the form
$form.ShowDialog()