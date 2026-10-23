Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipPath = "d:\NODE_PROJECTS\direct_print\androprint_client_setup.zip"
$backupPath = "d:\NODE_PROJECTS\direct_print\androprint_client_setup_backup.zip"
$newFilePath = "d:\NODE_PROJECTS\direct_print\public\logs.html"

# Make a backup first
Copy-Item -Path $zipPath -Destination $backupPath -Force
Write-Host "Backup created at $backupPath"

$zip = [System.IO.Compression.ZipFile]::Open($zipPath, [System.IO.Compression.ZipArchiveMode]::Update)

# Find any existing logs.html entry
$existing = @($zip.Entries | Where-Object { ($_.FullName -replace '\\','/') -eq 'public/logs.html' })
foreach ($entry in $existing) {
    Write-Host "Removing existing entry: $($entry.FullName)"
    $entry.Delete()
}

# Add the updated file
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $newFilePath, "public/logs.html")
Write-Host "Added updated public/logs.html to zip."

$zip.Dispose()
Write-Host "Zip updated successfully."
