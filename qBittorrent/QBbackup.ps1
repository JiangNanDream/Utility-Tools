# backup-qbittorrent.ps1

# 获取路径
$localPath = Join-Path $env:LOCALAPPDATA "qBittorrent"
$roamingPath = Join-Path $env:APPDATA "qBittorrent"
$desktop = [Environment]::GetFolderPath("Desktop")

# 时间戳
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath = Join-Path $desktop "qBittorrent_backup_$timestamp.zip"

# 临时目录
$tempDir = Join-Path $env:TEMP "qb_backup_$timestamp"
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 复制数据
if (Test-Path $localPath) {
    Copy-Item $localPath -Destination (Join-Path $tempDir "Local") -Recurse -Force
}

if (Test-Path $roamingPath) {
    Copy-Item $roamingPath -Destination (Join-Path $tempDir "Roaming") -Recurse -Force
}

# 压缩
Compress-Archive -Path (Join-Path $tempDir "*") -DestinationPath $zipPath -Force

# 清理临时目录
Remove-Item $tempDir -Recurse -Force

Write-Host "备份完成: $zipPath"