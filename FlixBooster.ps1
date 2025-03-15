# Add Windows Forms and Drawing assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

# Set application icon (replace the path with your .ico file)
$iconPath = Join-Path $PSScriptRoot "FlixBooster.ico"
if (Test-Path $iconPath) {
    $appIcon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
} else {
    $appIcon = [System.Drawing.SystemIcons]::Application
}

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

# Function to check if an app is installed
function Test-AppInstalled {
    param (
        [string]$AppName
    )
    $app = Get-AppxPackage -Name $AppName -ErrorAction SilentlyContinue
    return $null -ne $app
}

# Add this function near the other functions
function Test-CriticalApp {
    param (
        [string]$AppName
    )
    $criticalApps = @(
        "Microsoft.WindowsCalculator",
        "Microsoft.WindowsStore",
        "Microsoft.WindowsNotepad",
        "Microsoft.Windows.Photos"
    )
    return $criticalApps -contains $AppName
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
$path.AddLine(20, 0, $loadingForm.Width - 20, 0)
$path.AddArc($loadingForm.Width - 20, 0, 20, 20, 270, 90)
$path.AddLine($loadingForm.Width, 20, $loadingForm.Width, $loadingForm.Height - 20)
$path.AddArc($loadingForm.Width - 20, $loadingForm.Height - 20, 20, 20, 0, 90)
$path.AddLine($loadingForm.Width - 20, $loadingForm.Height, 20, $loadingForm.Height)
$path.AddArc(0, $loadingForm.Height - 20, 20, 20, 90, 90)
$path.AddLine(0, $loadingForm.Height - 20, 0, 20)
$path.CloseFigure()
$loadingForm.Region = New-Object System.Drawing.Region($path)

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
$form.Size = New-Object System.Drawing.Size(1000, 800)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.WindowState = [System.Windows.Forms.FormWindowState]::Normal
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Add custom title bar
$titleBar = New-Object System.Windows.Forms.Panel
$titleBar.Dock = [System.Windows.Forms.DockStyle]::Top
$titleBar.Height = 40
$titleBar.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35)

# Add title and controls
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "FlixBooster"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(10, 10)

# Add minimize and close buttons
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "×"
$closeButton.Size = New-Object System.Drawing.Size(40, 40)
$closeButton.Location = New-Object System.Drawing.Point($form.Width - 40, 0)
$closeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$closeButton.ForeColor = [System.Drawing.Color]::White
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 16)
$closeButton.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35)

$minimizeButton = New-Object System.Windows.Forms.Button
$minimizeButton.Text = "−"
$minimizeButton.Size = New-Object System.Drawing.Size(40, 40)
$minimizeButton.Location = New-Object System.Drawing.Point($form.Width - 80, 0)
$minimizeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$minimizeButton.ForeColor = [System.Drawing.Color]::White
$minimizeButton.Font = New-Object System.Drawing.Font("Segoe UI", 16)
$minimizeButton.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35)

# Add button events
$closeButton.Add_Click({ $form.Close() })
$minimizeButton.Add_Click({ $form.WindowState = [System.Windows.Forms.FormWindowState]::Minimized })

# Add hover effects
$closeButton.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(232, 17, 35) })
$closeButton.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35) })
$minimizeButton.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 55) })
$minimizeButton.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35) })

# Add controls to title bar
$titleBar.Controls.AddRange(@($titleLabel, $minimizeButton, $closeButton))

# Make form draggable
$titleBar.Add_MouseDown({
    $script:dragging = $true
    $script:offset = New-Object System.Drawing.Point($form.Location.X - [System.Windows.Forms.Cursor]::Position.X, $form.Location.Y - [System.Windows.Forms.Cursor]::Position.Y)
})

$titleBar.Add_MouseMove({
    if ($script:dragging) {
        $form.Location = New-Object System.Drawing.Point([System.Windows.Forms.Cursor]::Position.X + $script:offset.X, [System.Windows.Forms.Cursor]::Position.Y + $script:offset.Y)
    }
})

$titleBar.Add_MouseUp({ $script:dragging = $false })

# Add title bar to form
$form.Controls.Add($titleBar)

# Create tabs with modern styling
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(980, 700)
$tabControl.Location = New-Object System.Drawing.Point(10, 60)
$tabControl.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 40)
$tabControl.Padding = New-Object System.Drawing.Point(20, 4)
$tabControl.ItemSize = New-Object System.Drawing.Size(100, 40)

# Style the tabs
$tabControl.DrawMode = [System.Windows.Forms.TabDrawMode]::OwnerDrawFixed
$tabControl.Add_DrawItem({
    param($sender, $e)
    $tabPage = $sender.TabPages[$e.Index]
    $tabBounds = $sender.GetTabRect($e.Index)
    
    # Create gradient background
    $gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $tabBounds,
        [System.Drawing.Color]::FromArgb(45, 45, 50),
        [System.Drawing.Color]::FromArgb(35, 35, 40),
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    
    if ($e.Index -eq $sender.SelectedIndex) {
        # Selected tab styling
        $gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $tabBounds,
            [System.Drawing.Color]::FromArgb(0, 122, 204),
            [System.Drawing.Color]::FromArgb(0, 102, 184),
            [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
        )
    }
    
    $e.Graphics.FillRectangle($gradientBrush, $tabBounds)
    
    # Draw text with shadow
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 200, 200))
    if ($e.Index -eq $sender.SelectedIndex) {
        $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    }
    
    $stringFormat = New-Object System.Drawing.StringFormat
    $stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
    $stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    $e.Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $e.Graphics.DrawString(
        $tabPage.Text,
        (New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)),
        $textBrush,
        $tabBounds,
        $stringFormat
    )
    
    $gradientBrush.Dispose()
    $textBrush.Dispose()
    $stringFormat.Dispose()
})

# Debloat tab with enhanced styling
$tabDebloat = New-Object System.Windows.Forms.TabPage
$tabDebloat.Text = "Debloat"
$tabDebloat.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 40)
$tabDebloat.Padding = New-Object System.Windows.Forms.Padding(10)

# Enhanced CheckedListBox styling
$checkListDebloat = New-Object System.Windows.Forms.CheckedListBox
$checkListDebloat.Size = New-Object System.Drawing.Size(950, 500)
$checkListDebloat.Location = New-Object System.Drawing.Point(10, 10)
$checkListDebloat.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 40)
$checkListDebloat.ForeColor = [System.Drawing.Color]::White
$checkListDebloat.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$checkListDebloat.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$checkListDebloat.ItemHeight = 30

# Modified bloatware apps list with better names
$bloatwareApps = @(
    @{Name="Microsoft.3DBuilder"; Description="3D Builder"},
    @{Name="Microsoft.549981C3F5F10"; Description="Cortana"},
    @{Name="Microsoft.BingNews"; Description="News"},
    @{Name="Microsoft.BingWeather"; Description="Weather"},
    @{Name="Microsoft.GetHelp"; Description="Get Help"},
    @{Name="Microsoft.Getstarted"; Description="Tips"},
    @{Name="Microsoft.MicrosoftOfficeHub"; Description="Office"},
    @{Name="Microsoft.MicrosoftSolitaireCollection"; Description="Solitaire"},
    @{Name="Microsoft.MixedReality.Portal"; Description="Mixed Reality"},
    @{Name="Microsoft.People"; Description="People"},
    @{Name="Microsoft.SkypeApp"; Description="Skype"},
    @{Name="Microsoft.Wallet"; Description="Wallet"},
    @{Name="Microsoft.WindowsAlarms"; Description="Alarms"},
    @{Name="Microsoft.WindowsCamera"; Description="Camera"},
    @{Name="Microsoft.WindowsFeedbackHub"; Description="Feedback"},
    @{Name="Microsoft.WindowsMaps"; Description="Maps"},
    @{Name="Microsoft.WindowsSoundRecorder"; Description="Voice Recorder"},
    @{Name="Microsoft.Xbox.TCUI"; Description="Xbox Live"},
    @{Name="Microsoft.XboxApp"; Description="Xbox"},
    @{Name="Microsoft.XboxGameOverlay"; Description="Xbox Overlay"},
    @{Name="Microsoft.XboxGamingOverlay"; Description="Xbox Gaming"},
    @{Name="Microsoft.XboxIdentityProvider"; Description="Xbox Identity"},
    @{Name="Microsoft.XboxSpeechToTextOverlay"; Description="Xbox Speech"},
    @{Name="Microsoft.YourPhone"; Description="Phone Link"},
    @{Name="Microsoft.ZuneMusic"; Description="Media Player"},
    @{Name="Microsoft.ZuneVideo"; Description="Movies & TV"},
    @{Name="Microsoft.ScreenSketch"; Description="Snipping Tool"},
    @{Name="Microsoft.Windows.Photos"; Description="Photos"},
    @{Name="Microsoft.WindowsCalculator"; Description="Calculator"},
    @{Name="Microsoft.WindowsNotepad"; Description="Notepad"},
    @{Name="Microsoft.MicrosoftEdge.Stable"; Description="Edge"},
    @{Name="Microsoft.MicrosoftStickyNotes"; Description="Sticky Notes"},
    @{Name="Microsoft.WindowsStore"; Description="Store"},
    @{Name="Microsoft.WindowsTerminal"; Description="Terminal"},
    @{Name="Microsoft.PowerAutomateDesktop"; Description="Power Automate"},
    @{Name="Microsoft.BingTranslator"; Description="Translator"},
    @{Name="Microsoft.MicrosoftTeams"; Description="Teams"},
    @{Name="Microsoft.Paint"; Description="Paint"},
    @{Name="Microsoft.OneDrive"; Description="OneDrive"},
    @{Name="Microsoft.Office.OneNote"; Description="OneNote"},
    @{Name="Microsoft.MSPaint"; Description="Paint 3D"},
    @{Name="Microsoft.Microsoft3DViewer"; Description="3D Viewer"},
    @{Name="Microsoft.MicrosoftFamily"; Description="Family"},
    @{Name="Microsoft.WindowsCommunicationsApps"; Description="Mail & Calendar"},
    @{Name="Microsoft.WindowsFeedbackHub"; Description="Feedback Hub"},
    @{Name="Microsoft.WindowsMaps"; Description="Maps"},
    @{Name="Microsoft.Messaging"; Description="Messaging"}
)

# Modify how we add items to the CheckedListBox
$checkListDebloat.Items.Clear()
foreach ($app in $bloatwareApps) {
    [void]$checkListDebloat.Items.Add([PSCustomObject]@{
        Name = $app.Name
        Description = $app.Description
    })
}

# Modify the DrawItem event handler
$checkListDebloat.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
$checkListDebloat.Add_DrawItem({
    param($sender, $e)
    
    if ($e.Index -lt 0) { return }
    
    $app = $bloatwareApps[$e.Index]
    $isInstalled = Test-AppInstalled -AppName $app.Name
    
    # Draw background
    if ($sender.GetItemChecked($e.Index)) {
        $e.Graphics.FillRectangle([System.Drawing.Brushes]::FromArgb(40, 40, 45), $e.Bounds)
    } else {
        $e.DrawBackground()
    }
    
    # Draw status circle
    $circleSize = 16
    $circleY = $e.Bounds.Y + ($e.Bounds.Height - $circleSize) / 2
    $circleRect = New-Object System.Drawing.Rectangle($e.Bounds.X + 10, $circleY, $circleSize, $circleSize)
    
    $circleBrush = New-Object System.Drawing.SolidBrush($(if ($isInstalled) { 
        [System.Drawing.Color]::FromArgb(46, 204, 113) # Green
    } else { 
        [System.Drawing.Color]::FromArgb(231, 76, 60) # Red
    }))
    
    $e.Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $e.Graphics.FillEllipse($circleBrush, $circleRect)
    
    # Draw text
    $textBrush = New-Object System.Drawing.SolidBrush($sender.ForeColor)
    $textPoint = New-Object System.Drawing.Point($e.Bounds.X + 35, $e.Bounds.Y + 5)
    $e.Graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $e.Graphics.DrawString($app.Description, $sender.Font, $textBrush, $textPoint)
    
    $circleBrush.Dispose()
    $textBrush.Dispose()
})

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

# Enhanced tweaks list with actual implementations
$tweaks = @(
    @{
        Name = "Disable Telemetry & Data Collection"
        Action = {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0
            Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
            Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
            Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
            Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
            Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
            Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
        }
    },
    @{
        Name = "Optimize Gaming Performance"
        Action = {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 4294967295
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Value "High"
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
        }
    },
    @{
        Name = "Disable Windows Search Indexing"
        Action = {
            Stop-Service "WSearch" -Force
            Set-Service "WSearch" -StartupType Disabled
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WSearch" -Name "Start" -Value 4
        }
    },
    @{
        Name = "Optimize Network Settings"
        Action = {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -Value 1
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCP1323Opts" -Value 1
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "GlobalMaxTcpWindowSize" -Value 65535
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpWindowSize" -Value 65535
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 4294967295
        }
    },
    @{
        Name = "Disable Unnecessary Services"
        Action = {
            $services = @(
                "DiagTrack",                # Connected User Experiences and Telemetry
                "dmwappushservice",         # WAP Push Message Routing Service
                "HomeGroupListener",        # HomeGroup Listener
                "HomeGroupProvider",        # HomeGroup Provider
                "lfsvc",                    # Geolocation Service
                "MapsBroker",              # Downloaded Maps Manager
                "NetTcpPortSharing",       # Net.Tcp Port Sharing Service
                "RemoteAccess",            # Routing and Remote Access
                "RemoteRegistry",          # Remote Registry
                "SharedAccess",            # Internet Connection Sharing
                "TrkWks",                  # Distributed Link Tracking Client
                "WbioSrvc",               # Windows Biometric Service
                "WMPNetworkSvc",          # Windows Media Player Network Sharing Service
                "WSearch"                  # Windows Search
            )
            foreach ($service in $services) {
                Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
                Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }
    },
    @{
        Name = "Disable Windows Defender"
        Action = {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 1
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 1
        }
    },
    @{
        Name = "Disable Visual Effects"
        Action = {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
            Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Value 0
        }
    },
    @{
        Name = "Optimize SSD Settings"
        Action = {
            fsutil behavior set DisableLastAccess 1
            fsutil behavior set EncryptPagingFile 0
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 0
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsDisableLastAccessUpdate" -Value 1
        }
    },
    @{
        Name = "Disable Hibernation"
        Action = {
            powercfg -h off
            Remove-Item -Path "C:\hiberfil.sys" -Force -ErrorAction SilentlyContinue
        }
    },
    @{
        Name = "Optimize Memory Usage"
        Action = {
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value 1
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "IoPageLockLimit" -Value 983040
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 4294967295
        }
    },
    @{
        Name = "Optimize Boot Performance"
        Action = {
            # Disable Startup Delay
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayInMSec" -Value 0
            # Disable Prefetch and Superfetch
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 0
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 0
            # Disable Fast Startup
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0
        }
    },
    @{
        Name = "Enhance Privacy Settings"
        Action = {
            # Disable Activity History
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0
            # Disable Timeline
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0
            # Disable Location Services
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
            # Disable Advertising ID
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
        }
    },
    @{
        Name = "Optimize Gaming Settings"
        Action = {
            # Enable Game Mode
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1
            # Disable Game DVR
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0
            # Optimize GPU for Performance
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6
        }
    },
    @{
        Name = "Optimize Internet Settings"
        Action = {
            # Enable DNS Cache
            Set-Service -Name Dnscache -StartupType Automatic
            Start-Service -Name Dnscache
            # Optimize Network Settings
            netsh int tcp set global autotuninglevel=normal
            netsh int tcp set global chimney=enabled
            netsh int tcp set global dca=enabled
            netsh int tcp set global netdma=enabled
            # Set Static DNS
            Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter | Where-Object {$_.Status -eq "Up"}).InterfaceIndex -ServerAddresses "8.8.8.8","1.1.1.1"
        }
    },
    @{
        Name = "Clean System Files"
        Action = {
            # Clear Temp Files
            Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
            Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
            # Clear Windows Update Cache
            Stop-Service -Name wuauserv
            Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue
            Start-Service -Name wuauserv
            # Clear Font Cache
            Stop-Service -Name FontCache
            Remove-Item -Path "$env:SystemDrive\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Force -ErrorAction SilentlyContinue
            Start-Service -Name FontCache
        }
    },
    @{
        Name = "Optimize Windows Explorer"
        Action = {
            # Show file extensions and hidden files
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
            # Disable Quick Access
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 0
            # Show This PC by default
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1
        }
    },
    @{
        Name = "Disable Windows Auto Updates"
        Action = {
            # Disable Windows Update Service
            Stop-Service "wuauserv" -Force
            Set-Service "wuauserv" -StartupType Disabled
            # Disable Windows Update Registry Keys
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 2
        }
    },
    @{
        Name = "Enhance System Security"
        Action = {
            # Disable Remote Assistance
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0
            # Enable Windows Firewall
            Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
            # Disable Remote Desktop
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1
        }
    },
    @{
        Name = "Optimize CPU Performance"
        Action = {
            # Set CPU Priority to Programs
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 4294967295
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0
            # Optimize Processor Scheduling
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38
        }
    },
    @{
        Name = "Enhance Privacy & Telemetry"
        Action = {
            # Disable Feedback Experience
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0
            # Disable Tailored Experiences
            Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0
            # Disable App Launch Tracking
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0
        }
    },
    @{
        Name = "Optimize Startup Programs"
        Action = {
            # Disable Common Startup Programs
            $startupItems = @(
                "OneDrive",
                "Teams",
                "Skype",
                "Spotify",
                "Steam",
                "Discord"
            )
            foreach ($item in $startupItems) {
                $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
                Remove-ItemProperty -Path $regPath -Name $item -ErrorAction SilentlyContinue
            }
        }
    },
    @{
        Name = "Optimize Mouse & Keyboard"
        Action = {
            # Enhance Mouse Precision
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "1"
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "6"
            Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "10"
            # Keyboard Response
            Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value "0"
            Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value "31"
        }
    },
    @{
        Name = "Optimize Drive Performance"
        Action = {
            # Disable Drive Indexing
            $drives = Get-WmiObject Win32_Volume -Filter "DriveType=3"
            foreach ($drive in $drives) {
                $obj = $drive.GetPropertyValue("IndexingEnabled")
                if ($obj) {
                    $drive.IndexingEnabled = $false
                    $drive.Put()
                }
            }
            # Enable TRIM for SSDs
            fsutil behavior set DisableDeleteNotify 0
            # Optimize Drive Performance
            Get-Volume | Optimize-Volume -ReTrim -Verbose
        }
    },
    @{
        Name = "Optimize Context Menu"
        Action = {
            # Remove Common Context Menu Items
            $contextItems = @(
                "Print",
                "Cast to Device",
                "Share",
                "Edit with Paint 3D",
                "Edit with Photos"
            )
            foreach ($item in $contextItems) {
                Remove-Item -Path "HKCR:\*\shell\$item" -Recurse -ErrorAction SilentlyContinue
            }
        }
    },
    @{
        Name = "Optimize DNS Settings"
        Action = {
            # Set CloudFlare and Google DNS
            $adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
            foreach ($adapter in $adapters) {
                Set-DnsClientServerAddress -InterfaceIndex $adapter.InterfaceIndex -ServerAddresses "1.1.1.1","8.8.8.8"
            }
            # Flush DNS Cache
            ipconfig /flushdns
            # Register DNS
            ipconfig /registerdns
        }
    }
)

foreach ($tweak in $tweaks) {
    $checkListTweaks.Items.Add($tweak.Name, $false)
}

# Create buttons for Debloat tab
$btnRemoveSelected = New-Object System.Windows.Forms.Button
$btnRemoveSelected.Size = New-Object System.Drawing.Size(300, 50)
$btnRemoveSelected.Location = New-Object System.Drawing.Point(10, 520)
$btnRemoveSelected.Text = "Remove Selected Apps"
$btnRemoveSelected.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnRemoveSelected.ForeColor = [System.Drawing.Color]::White
$btnRemoveSelected.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRemoveSelected.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRemoveSelected.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnSelectAll = New-Object System.Windows.Forms.Button
$btnSelectAll.Size = New-Object System.Drawing.Size(300, 50)
$btnSelectAll.Location = New-Object System.Drawing.Point(320, 520)
$btnSelectAll.Text = "Select All"
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
$statusLabel.Size = New-Object System.Drawing.Size(950, 40)
$statusLabel.Location = New-Object System.Drawing.Point(10, 580)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$statusLabel.Text = "Ready to optimize your system"
$statusLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLabel.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 35)
$statusLabel.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)

# Create buttons for Tweaks tab
$btnApplyTweaks = New-Object System.Windows.Forms.Button
$btnApplyTweaks.Size = New-Object System.Drawing.Size(300, 50)
$btnApplyTweaks.Location = New-Object System.Drawing.Point(10, 520)
$btnApplyTweaks.Text = "Apply Selected Tweaks"
$btnApplyTweaks.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnApplyTweaks.ForeColor = [System.Drawing.Color]::White
$btnApplyTweaks.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnApplyTweaks.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnApplyTweaks.Cursor = [System.Windows.Forms.Cursors]::Hand

$btnSelectAllTweaks = New-Object System.Windows.Forms.Button
$btnSelectAllTweaks.Size = New-Object System.Drawing.Size(300, 50)
$btnSelectAllTweaks.Location = New-Object System.Drawing.Point(320, 520)
$btnSelectAllTweaks.Text = "Select All Tweaks"
$btnSelectAllTweaks.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 65)
$btnSelectAllTweaks.ForeColor = [System.Drawing.Color]::White
$btnSelectAllTweaks.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnSelectAllTweaks.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnSelectAllTweaks.Cursor = [System.Windows.Forms.Cursors]::Hand

# Add button click events
$btnRemoveSelected.Add_Click({
    $selectedIndices = $checkListDebloat.CheckedIndices
    $selectedApps = $selectedIndices | ForEach-Object { $checkListDebloat.Items[$_] }
    
    $criticalApps = $selectedApps | Where-Object { Test-CriticalApp $_.Name }
    if ($criticalApps) {
        $warningMessage = "Warning: You are about to remove some critical system apps:`n`n"
        $warningMessage += ($criticalApps.Description -join "`n")
        $warningMessage += "`n`nThis might affect system functionality. Do you want to continue?"
        $result = [System.Windows.Forms.MessageBox]::Show(
            $warningMessage,
            "Warning",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        if ($result -eq [System.Windows.Forms.DialogResult]::No) {
            return
        }
    }
    
    $statusLabel.Text = 'Processing...'
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
    $form.Refresh()
    
    $total = $selectedApps.Count
    $current = 0
    
    foreach ($app in $selectedApps) {
        try {
            $current++
            $statusLabel.Text = ('Removing {0}... ({1} of {2})' -f $app.Description, $current, $total)
            $form.Refresh()
            
            Get-AppxPackage -Name $app.Name -AllUsers | Remove-AppxPackage
            Start-Sleep -Milliseconds 100
        }
        catch {
            $statusLabel.Text = ('Failed to remove {0}' -f $app.Description)
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
        }
    }
    
    $statusLabel.Text = 'Operation completed successfully!'
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    [System.Windows.Forms.MessageBox]::Show(
        'Selected apps have been removed successfully!',
        'Success',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
    
    # Refresh the list to update status indicators
    $checkListDebloat.Refresh()
})

$btnSelectAll.Add_Click({
    for ($i = 0; $i -lt $checkListDebloat.Items.Count; $i++) {
        $checkListDebloat.SetItemChecked($i, $true)
    }
})

$btnApplyTweaks.Add_Click({
    $statusLabel.Text = 'Applying tweaks...'
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
            
            $tweakObj = $tweaks | Where-Object { $_.Name -eq $tweak }
            if ($tweakObj) {
                & $tweakObj.Action
            }
            
            Start-Sleep -Milliseconds 50
        }
        catch {
            $statusLabel.Text = "Failed to apply $tweak"
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
            Write-Error $_.Exception.Message
        }
    }
    
    $statusLabel.Text = 'All tweaks applied successfully!'
    $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    [System.Windows.Forms.MessageBox]::Show(
        'Selected tweaks have been applied successfully!',
        'Success',
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
$tabCustomize.Padding = New-Object System.Windows.Forms.Padding(20)

# Create Windows Personalization group
$grpPersonalization = New-Object System.Windows.Forms.GroupBox
$grpPersonalization.Text = "Windows Personalization"
$grpPersonalization.Size = New-Object System.Drawing.Size(940, 300)
$grpPersonalization.Location = New-Object System.Drawing.Point(10, 10)
$grpPersonalization.ForeColor = [System.Drawing.Color]::White
$grpPersonalization.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$grpPersonalization.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 45)
$grpPersonalization.Padding = New-Object System.Windows.Forms.Padding(15)

# Create customization options
$darkModeToggle = New-Object System.Windows.Forms.CheckBox
$darkModeToggle.Text = "Dark Mode"
$darkModeToggle.Size = New-Object System.Drawing.Size(400, 30)
$darkModeToggle.Location = New-Object System.Drawing.Point(20, 40)
$darkModeToggle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$darkModeToggle.ForeColor = [System.Drawing.Color]::White

$showFileExtToggle = New-Object System.Windows.Forms.CheckBox
$showFileExtToggle.Text = "Show File Extensions"
$showFileExtToggle.Size = New-Object System.Drawing.Size(400, 30)
$showFileExtToggle.Location = New-Object System.Drawing.Point(20, 80)
$showFileExtToggle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$showFileExtToggle.ForeColor = [System.Drawing.Color]::White

$showHiddenFilesToggle = New-Object System.Windows.Forms.CheckBox
$showHiddenFilesToggle.Text = "Show Hidden Files"
$showHiddenFilesToggle.Size = New-Object System.Drawing.Size(400, 30)
$showHiddenFilesToggle.Location = New-Object System.Drawing.Point(20, 120)
$showHiddenFilesToggle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$showHiddenFilesToggle.ForeColor = [System.Drawing.Color]::White

$smallTaskbarToggle = New-Object System.Windows.Forms.CheckBox
$smallTaskbarToggle.Text = "Small Taskbar Icons"
$smallTaskbarToggle.Size = New-Object System.Drawing.Size(400, 30)
$smallTaskbarToggle.Location = New-Object System.Drawing.Point(20, 160)
$smallTaskbarToggle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$smallTaskbarToggle.ForeColor = [System.Drawing.Color]::White

# Add event handlers for customization options
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

$showFileExtToggle.Add_Click({
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value $([int](!$this.Checked))
        $statusLabel.Text = "File extensions " + $(if ($this.Checked) { "shown" } else { "hidden" })
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } catch {
        $statusLabel.Text = "Failed to change file extensions setting"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

$showHiddenFilesToggle.Add_Click({
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value $([int]($this.Checked))
        $statusLabel.Text = "Hidden files " + $(if ($this.Checked) { "shown" } else { "hidden" })
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } catch {
        $statusLabel.Text = "Failed to change hidden files setting"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

$smallTaskbarToggle.Add_Click({
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value $([int]($this.Checked))
        $statusLabel.Text = "Taskbar icons " + $(if ($this.Checked) { "small" } else { "normal" })
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } catch {
        $statusLabel.Text = "Failed to change taskbar icon size"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Add controls to groups
$grpPersonalization.Controls.AddRange(@(
    $darkModeToggle,
    $showFileExtToggle,
    $showHiddenFilesToggle,
    $smallTaskbarToggle
))

# Add groups to Customize tab
$tabCustomize.Controls.Add($grpPersonalization)

# Add Customize tab to tab control
$tabControl.Controls.Add($tabCustomize)

# Create Performance tab with modern styling
$tabPerformance = New-Object System.Windows.Forms.TabPage
$tabPerformance.Text = "Performance"
$tabPerformance.BackColor = [System.Drawing.Color]::FromArgb(35, 35, 40)
$tabPerformance.Padding = New-Object System.Windows.Forms.Padding(20)

# Create restore point group
$grpRestore = New-Object System.Windows.Forms.GroupBox
$grpRestore.Text = "System Protection"
$grpRestore.Size = New-Object System.Drawing.Size(940, 150)
$grpRestore.Location = New-Object System.Drawing.Point(10, 10)
$grpRestore.ForeColor = [System.Drawing.Color]::White
$grpRestore.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$grpRestore.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 45)

# Create restore point buttons
$createRestoreBtn = New-Object System.Windows.Forms.Button
$createRestoreBtn.Text = "Create Restore Point"
$createRestoreBtn.Size = New-Object System.Drawing.Size(200, 40)
$createRestoreBtn.Location = New-Object System.Drawing.Point(20, 35)
$createRestoreBtn.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$createRestoreBtn.ForeColor = [System.Drawing.Color]::White
$createRestoreBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$createRestoreBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)

$removeRestoreBtn = New-Object System.Windows.Forms.Button
$removeRestoreBtn.Text = "Remove Restore Points"
$removeRestoreBtn.Size = New-Object System.Drawing.Size(200, 40)
$removeRestoreBtn.Location = New-Object System.Drawing.Point(240, 35)
$removeRestoreBtn.BackColor = [System.Drawing.Color]::FromArgb(220, 53, 69)
$removeRestoreBtn.ForeColor = [System.Drawing.Color]::White
$removeRestoreBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$removeRestoreBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Create power settings group
$grpPower = New-Object System.Windows.Forms.GroupBox
$grpPower.Text = "Power Settings"
$grpPower.Size = New-Object System.Drawing.Size(940, 250)
$grpPower.Location = New-Object System.Drawing.Point(10, 170)
$grpPower.ForeColor = [System.Drawing.Color]::White
$grpPower.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$grpPower.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 45)

# Create power buttons instead of slider
$powerButtons = @(
    @{
        Name = "Power Saver"
        GUID = "a1841308-3541-4fab-bc81-f71556f20b4a"
        Color = [System.Drawing.Color]::FromArgb(40, 167, 69)
    },
    @{
        Name = "Balanced"
        GUID = "381b4222-f694-41f0-9685-ff5bb260df2e"
        Color = [System.Drawing.Color]::FromArgb(0, 123, 255)
    },
    @{
        Name = "High Performance"
        GUID = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        Color = [System.Drawing.Color]::FromArgb(255, 193, 7)
    },
    @{
        Name = "Ultimate Performance"
        GUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"
        Color = [System.Drawing.Color]::FromArgb(220, 53, 69)
    }
)

$buttonX = 20
foreach ($plan in $powerButtons) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $plan.Name
    $button.Size = New-Object System.Drawing.Size(220, 50)
    $button.Location = New-Object System.Drawing.Point($buttonX, 40)
    $button.BackColor = $plan.Color
    $button.ForeColor = [System.Drawing.Color]::White
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $button.Tag = $plan.GUID
    
    $button.Add_Click({
        $guid = $this.Tag
        try {
            if ($this.Text -eq "Ultimate Performance") {
                powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
                Start-Sleep -Milliseconds 500
            }
            powercfg /setactive $guid
            Show-ProgressAnimation -status "Power plan changed to $($this.Text)" -duration 1000
        } catch {
            Show-ProgressAnimation -status "Failed to change power plan" -duration 1000
        }
    })
    
    $grpPower.Controls.Add($button)
    $buttonX += 230
}

# Add event handlers for restore points
$createRestoreBtn.Add_Click({
    try {
        Enable-ComputerRestore -Drive "C:\"
        Checkpoint-Computer -Description "FlixBooster Restore Point" -RestorePointType "MODIFY_SETTINGS"
        $statusLabel.Text = "✅ Restore point created successfully"
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } catch {
        $statusLabel.Text = "Failed to create restore point"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

$removeRestoreBtn.Add_Click({
    try {
        vssadmin delete shadows /all /quiet
        $statusLabel.Text = "✅ Restore points removed successfully"
        $statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 255, 0)
    } catch {
        $statusLabel.Text = "Failed to remove restore points"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    }
})

# Add controls to groups
$grpRestore.Controls.AddRange(@($createRestoreBtn, $removeRestoreBtn))

# Add groups to Performance tab
$tabPerformance.Controls.AddRange(@($grpRestore, $grpPower))

# Add the Performance tab to tab control
$tabControl.Controls.Add($tabPerformance)

# Add tab control to form
$form.Controls.Add($tabControl)
$form.Controls.Add($statusLabel)

# Create animated status bar
$statusBar = New-Object System.Windows.Forms.Panel
$statusBar.Size = New-Object System.Drawing.Size(980, 5)
$statusBar.Location = New-Object System.Drawing.Point(10, 770)
$statusBar.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 45)

$statusProgress = New-Object System.Windows.Forms.Panel
$statusProgress.Size = New-Object System.Drawing.Size(0, 5)
$statusProgress.Location = New-Object System.Drawing.Point(0, 0)
$statusProgress.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)

$statusBar.Controls.Add($statusProgress)
$form.Controls.Add($statusBar)

# Function to show progress animation
function Show-ProgressAnimation {
    param(
        [string]$status,
        [int]$duration = 1000
    )
    
    $statusLabel.Text = $status
    $statusProgress.Width = 0
    $statusProgress.Visible = $true
    
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 10
    $progress = 0
    
    $timer.Add_Tick({
        $progress += 1
        $statusProgress.Width = [Math]::Min([Math]::Floor($statusBar.Width * ($progress / 100)), $statusBar.Width)
        if ($progress -ge 100) {
            $timer.Stop()
            $statusProgress.Width = 0
        }
        $form.Refresh()
    })
    
    $timer.Start()
}

# Complete loading
$progressBar.Value = 100
$loadingLabel.Text = 'Ready!'
Start-Sleep -Milliseconds 200
$loadingForm.Close()

# Show the form
$form.Icon = $appIcon
$form.ShowDialog()

# Add hover effects to buttons
function Add-ButtonHoverEffect {
    param($button)
    
    $originalColor = $button.BackColor
    $hoverColor = [System.Drawing.Color]::FromArgb(
        [Math]::Min(255, $originalColor.R + 20),
        [Math]::Min(255, $originalColor.G + 20),
        [Math]::Min(255, $originalColor.B + 20)
    )
    
    $button.Add_MouseEnter({ $this.BackColor = $hoverColor })
    $button.Add_MouseLeave({ $this.BackColor = $originalColor })
    
    # Add click animation
    $button.Add_MouseDown({ $this.BackColor = $originalColor })
    $button.Add_MouseUp({ $this.BackColor = $hoverColor })
}

# Apply hover effects to all buttons
$form.Controls | Where-Object { $_ -is [System.Windows.Forms.Button] } | ForEach-Object {
    Add-ButtonHoverEffect $_
}