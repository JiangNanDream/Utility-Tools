# restore-qbittorrent.ps1

param (
    [Parameter(Mandatory=$true)]
    [string]$f
)

# 检查 qBittorrent 是否在运行
$qbProcess = Get-Process -Name "qbittorrent" -ErrorAction SilentlyContinue

if ($qbProcess) {
    Write-Host "检测到 qBittorrent 正在运行，请先关闭软件！" -ForegroundColor Yellow
    Write-Host "按 Enter 退出脚本..." -ForegroundColor Yellow
    Read-Host
    exit
}

# 二次确认
Write-Host " 此操作将覆盖当前 qBittorrent 配置！" -ForegroundColor Red
$confirm = Read-Host "请输入 Y 确认继续（其他任意键取消）"

if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "操作已取消"
    exit
}

# 获取路径
$localPath = Join-Path $env:LOCALAPPDATA "qBittorrent"
$roamingPath = Join-Path $env:APPDATA "qBittorrent"

# 临时目录
$tempDir = Join-Path $env:TEMP ("qb_restore_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 解压
Expand-Archive -Path $f -DestinationPath $tempDir -Force

# 还原 Local
$localBackup = Join-Path $tempDir "Local"
if (Test-Path $localBackup) {
    if (Test-Path $localPath) {
        Remove-Item $localPath -Recurse -Force
    }
    Copy-Item $localBackup -Destination $localPath -Recurse -Force
}

# 还原 Roaming
$roamingBackup = Join-Path $tempDir "Roaming"
if (Test-Path $roamingBackup) {
    if (Test-Path $roamingPath) {
        Remove-Item $roamingPath -Recurse -Force
    }
    Copy-Item $roamingBackup -Destination $roamingPath -Recurse -Force
}

# 清理
Remove-Item $tempDir -Recurse -Force

Write-Host "恢复完成" -ForegroundColor Green