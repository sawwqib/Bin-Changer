$version = "v1.0-BinChanger"
$recycle_bin_themes_path = "$env:userprofile\Pictures\RecycleBinThemes"
$ProgressPreference = "SilentlyContinue"

# Your themes
$supported_themes = @("cat", "hitler", "fries")

Write-Host @"
 	    BIN CHANGER
                                                                                            

           Recycle Bin Themer $version by @sawwqib
"@

$textInfo = (Get-Culture).TextInfo
Write-Host "Select a theme:"
for ($i = 0; $i -lt $supported_themes.count; $i++){
    Write-Host " [$($i+1)] $($supported_themes[$i])"
}
Write-Host " [0] Default"

$choice = Read-Host "`nChoice"
if (-not($choice -ge 0 -and $choice -le $supported_themes.count)) {
   Write-Host "Invalid choice!"
   exit 
}

function writeToDefaultIconRegistry {
    param ($name, $value)
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "$name" -Value "$value"
}

if ($choice -eq 0) {
    writeToDefaultIconRegistry "(Default)" "%SystemRoot%\System32\imageres.dll,-55"
    writeToDefaultIconRegistry "full" "%SystemRoot%\System32\imageres.dll,-54"
    writeToDefaultIconRegistry "empty" "%SystemRoot%\System32\imageres.dll,-55"
    Stop-Process -ProcessName explorer -Force
    Write-Host "Recycle Bin restored to default icons."
    exit
}

$selected_theme = $supported_themes[$choice - 1]
$empty_icon_url = "https://raw.githubusercontent.com/sawwqib/Bin-Changer/main/themes/$selected_theme/empty.ico"
$full_icon_url  = "https://raw.githubusercontent.com/sawwqib/Bin-Changer/main/themes/$selected_theme/full.ico"

$theme_folder = "$recycle_bin_themes_path\$selected_theme"
$empty_icon_path = "$theme_folder\empty.ico"
$full_icon_path  = "$theme_folder\full.ico"

mkdir -Force $theme_folder | Out-Null

Invoke-WebRequest $empty_icon_url -OutFile $empty_icon_path
Invoke-WebRequest $full_icon_url -OutFile $full_icon_path

writeToDefaultIconRegistry "(Default)" "$empty_icon_path,0"
writeToDefaultIconRegistry "full" "$full_icon_path,0"
writeToDefaultIconRegistry "empty" "$empty_icon_path,0"

Stop-Process -ProcessName explorer -Force
Write-Host "Recycle Bin theme applied: $selected_theme ✅"

