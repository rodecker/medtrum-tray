Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Medtrum EasyView credentials
$user = "<email>"
$pass = "<password>"
$fcm = "123" # Set any string here

# mg/dL thresholds
$minval = 80
$maxval = 140

# Refresh interval in seconds
$checkInterval = 60

$path = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $path

$tray = New-Object System.Windows.Forms.NotifyIcon
$tray.Text = "Glucose monitor"
$tray.Visible = $true

$greenIcon = New-Object System.Drawing.Bitmap 16,16
$g = [System.Drawing.Graphics]::FromImage($greenIcon)
$g.Clear([System.Drawing.Color]::Green)
$redIcon = New-Object System.Drawing.Bitmap 16,16
$r = [System.Drawing.Graphics]::FromImage($redIcon)
$r.Clear([System.Drawing.Color]::Red)
$orangeIcon = New-Object System.Drawing.Bitmap 16,16
$r = [System.Drawing.Graphics]::FromImage($orangeIcon)
$r.Clear([System.Drawing.Color]::Orange)
$whiteIcon = New-Object System.Drawing.Bitmap 16,16
$g = [System.Drawing.Graphics]::FromImage($whiteIcon)
$g.Clear([System.Drawing.Color]::White)

$tray.Icon = [System.Drawing.Icon]::FromHandle($whiteIcon.GetHicon())

$menu = New-Object System.Windows.Forms.ContextMenuStrip
$exit = $menu.Items.Add("Exit")
$exit.Add_Click({
     $tray.Visible = $false
     [System.Windows.Forms.Application]::Exit()
})
$tray.ContextMenuStrip = $menu

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $checkInterval * 1000
$timer.Add_Tick({
     try {
         $cookie = & curl.exe -si -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "user_type=M&user_name=$user&password=$pass&deviceToken=$fcm&platform=google&apptype=Follow&push_platform=google&app_version=1.2.70%28112%29&device_name=sdk_gphone_x86&bundleID=com.medtrum.easyfollowforandroidmg" https://easyview.medtrum.eu/mobile/ajax/login -o NUL -w "%header{Set-Cookie}" | Select-Object -First 1 | ForEach-Object {($_ -split '\s+')[0] -replace ';$',''}
         [double]$mmol = & curl.exe -sq -H "Cookie: $cookie" https://easyview.medtrum.eu/mobile/ajax/logindata | .\jq.exe ".monitorlist[0].sensor_status.glucose"
         $mg = [math]::Round($mmol / 0.0555, 0)

         $tray.Text = "$mg mg/dL"
         if ($mg -lt $minval) {
             $tray.Icon = [System.Drawing.Icon]::FromHandle($redIcon.GetHicon())
         } elseif ($mg -gt $maxval) {
             $tray.Icon = [System.Drawing.Icon]::FromHandle($orangeIcon.GetHicon())
         } else {
             $tray.Icon = [System.Drawing.Icon]::FromHandle($greenIcon.GetHicon())
         }
     }
     catch {
         $tray.Icon = [System.Drawing.Icon]::FromHandle($whiteIcon.GetHicon())
         $tray.Text = "No data"
     }
})

$timer.Start()
[System.Windows.Forms.Application]::Run()
