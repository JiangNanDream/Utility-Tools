# restore-chrome.ps1

param (
    [Parameter(Mandatory=$true)]
    [Alias("f")]
    [string]$ZipFile,

    [string]$ProfileName = "Profile 1"
)

# 检查 Chrome 是否运行
$chrome = Get-Process -Name "chrome" -ErrorAction SilentlyContinue
if ($chrome) {
    Write-Host "检测到 Chrome 正在运行，请先关闭浏览器！" -ForegroundColor Yellow
    Write-Host "按 Enter 退出脚本..."
    Read-Host
    exit
}

# 提示用户确认路径
Write-Host "请确认 Chrome 个人资料路径：" -ForegroundColor Yellow
Write-Host "chrome://version/ -> Profile Path"
Write-Host "当前 ProfileName: $ProfileName"
Write-Host ""

# 二次确认
Write-Host "⚠️ 此操作将覆盖当前 Chrome 用户数据！" -ForegroundColor Red
$confirm = Read-Host "输入 Y 确认继续（其他键取消）"

if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "操作已取消"
    exit
}

# 路径
$chromeUserData = Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data"
$profilePath = Join-Path $chromeUserData $ProfileName

# 临时目录
$tempDir = Join-Path $env:TEMP ("chrome_restore_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 解压
Expand-Archive -Path $ZipFile -DestinationPath $tempDir -Force

# 找到备份目录
$backupProfile = Join-Path $tempDir $ProfileName

if (-not (Test-Path $backupProfile)) {
    Write-Host "备份中未找到 Profile: $ProfileName" -ForegroundColor Red
    exit
}

# 覆盖还原
if (Test-Path $profilePath) {
    Remove-Item $profilePath -Recurse -Force
}

Copy-Item $backupProfile -Destination $profilePath -Recurse -Force

# 清理
Remove-Item $tempDir -Recurse -Force

Write-Host "恢复完成" -ForegroundColor Green