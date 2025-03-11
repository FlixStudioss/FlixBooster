# Add Windows Forms for GUI
Add-Type -AssemblyName System.Windows.Forms

# Create the Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Bloatware Remover"
$form.Size = New-Object System.Drawing.Size(400, 300)

# Create the About Button
$aboutButton = New-Object System.Windows.Forms.Button
$aboutButton.Text = "About"
$aboutButton.Size = New-Object System.Drawing.Size(100, 40)
$aboutButton.Location = New-Object System.Drawing.Point(50, 50)
$aboutButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Bloatware Remover v1.0`nCreated to help remove unwanted apps and software." -replace "`n", [Environment]::NewLine, "About")
})

# Create the Software Categories Button
$softwareCategoriesButton = New-Object System.Windows.Forms.Button
$softwareCategoriesButton.Text = "Software Categories"
$softwareCategoriesButton.Size = New-Object System.Drawing.Size(150, 40)
$softwareCategoriesButton.Location = New-Object System.Drawing.Point(50, 100)
$softwareCategoriesButton.Add_Click({
    # Display categories of software (e.g., installed apps, system apps, etc.)
    $categoriesForm = New-Object System.Windows.Forms.Form
    $categoriesForm.Text = "Select Software Category"
    $categoriesForm.Size = New-Object System.Drawing.Size(300, 200)

    # Create category buttons
    $installedButton = New-Object System.Windows.Forms.Button
    $installedButton.Text = "Installed Apps"
    $installedButton.Size = New-Object System.Drawing.Size(200, 40)
    $installedButton.Location = New-Object System.Drawing.Point(50, 30)
    $installedButton.Add_Click({
        # Show installed software list
        $installedApps = Get-WmiObject -Class Win32_Product | Select-Object Name, Version
        $softwareList = $installedApps | ForEach-Object { "$($_.Name) - $($_.Version)" } -join "`n"
        [System.Windows.Forms.MessageBox]::Show("Installed Apps:`n$softwareList", "Installed Apps")
    })

    $systemAppsButton = New-Object System.Windows.Forms.Button
    $systemAppsButton.Text = "System Apps"
    $systemAppsButton.Size = New-Object System.Drawing.Size(200, 40)
    $systemAppsButton.Location = New-Object System.Drawing.Point(50, 80)
    $systemAppsButton.Add_Click({
        # Show system apps (e.g., from Windows Store)
        $systemApps = Get-AppxPackage | Select-Object Name, PackageFullName
        $appsList = $systemApps | ForEach-Object { "$($_.Name) - $($_.PackageFullName)" } -join "`n"
        [System.Windows.Forms.MessageBox]::Show("System Apps:`n$appsList", "System Apps")
    })

    $categoriesForm.Controls.Add($installedButton)
    $categoriesForm.Controls.Add($systemAppsButton)
    $categoriesForm.ShowDialog()
})

# Add buttons to the main form
$form.Controls.Add($aboutButton)
$form.Controls.Add($softwareCategoriesButton)

# Show the form
$form.ShowDialog()
