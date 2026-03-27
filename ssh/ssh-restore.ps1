# restore-ssh.ps1

param (
    [Parameter(Mandatory=$true)]
    [Alias("f")]
    [string]$ZipFile
)

$sshPath = Join-Path $env:USERPROFILE ".ssh"

# 警告
Write-Host " 此操作将覆盖当前 .ssh 目录（包含私钥）！" -ForegroundColor Red
$confirm = Read-Host "输入 Y 确认继续（其他键取消）"

if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "操作已取消"
    exit
}

# 临时目录
$tempDir = Join-Path $env:TEMP ("ssh_restore_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 解压
Expand-Archive -Path $ZipFile -DestinationPath $tempDir -Force

$backupSsh = Join-Path $tempDir ".ssh"

if (-not (Test-Path $backupSsh)) {
    Write-Host "备份中未找到 .ssh 目录" -ForegroundColor Red
    exit
}

# 删除旧目录
if (Test-Path $sshPath) {
    Remove-Item $sshPath -Recurse -Force
}

# 复制恢复
Copy-Item $backupSsh -Destination $sshPath -Recurse -Force

#  修复权限（Windows SSH 关键）
Write-Host "正在修复 .ssh 权限..."

icacls $sshPath /inheritance:r | Out-Null
icacls $sshPath /grant:r "$($env:USERNAME):(F)" | Out-Null

Get-ChildItem $sshPath -Recurse | ForEach-Object {
    icacls $_.FullName /inheritance:r | Out-Null
    icacls $_.FullName /grant:r "$($env:USERNAME):(F)" | Out-Null
}

# 清理
Remove-Item $tempDir -Recurse -Force

Write-Host "恢复完成（权限已修复）" -ForegroundColor Green