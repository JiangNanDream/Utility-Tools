# backup-chrome.ps1

param (
    [string]$ProfileName = "Profile 1"
)

Write-Host "请先确认 Chrome 个人资料路径：" -ForegroundColor Yellow
Write-Host "1. 打开 Chrome" 
Write-Host "2. 地址栏输入 chrome://version/"
Write-Host "3. 查看“个人资料路径（Profile Path）”"
Write-Host "4. 修改脚本中的 ProfileName（如 Profile 1 / Default）"
Write-Host ""

# Chrome 用户数据目录
$chromeUserData = Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data"
$profilePath = Join-Path $chromeUserData $ProfileName

if (-not (Test-Path $profilePath)) {
    Write-Host "未找到路径: $profilePath" -ForegroundColor Red
    exit
}

# 桌面路径
$desktop = [Environment]::GetFolderPath("Desktop")
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath = Join-Path $desktop "chrome_backup_$ProfileName_$timestamp.zip"

# 临时目录
$tempDir = Join-Path $env:TEMP ("chrome_backup_" + $timestamp)
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 复制数据
Copy-Item $profilePath -Destination (Join-Path $tempDir $ProfileName) -Recurse -Force

# 压缩
Compress-Archive -Path (Join-Path $tempDir "*") -DestinationPath $zipPath -Force

# 清理
Remove-Item $tempDir -Recurse -Force

Write-Host "备份完成: $zipPath" -ForegroundColor Green