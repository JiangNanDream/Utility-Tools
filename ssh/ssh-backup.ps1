# backup-ssh.ps1

# .ssh 路径（自动获取当前用户）
$sshPath = Join-Path $env:USERPROFILE ".ssh"

if (-not (Test-Path $sshPath)) {
    Write-Host "未找到 .ssh 目录: $sshPath" -ForegroundColor Red
    exit
}

# 桌面路径
$desktop = [Environment]::GetFolderPath("Desktop")
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath = Join-Path $desktop "ssh_backup_$timestamp.zip"

# 临时目录
$tempDir = Join-Path $env:TEMP ("ssh_backup_" + $timestamp)
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 复制
Copy-Item $sshPath -Destination (Join-Path $tempDir ".ssh") -Recurse -Force

# 压缩
Compress-Archive -Path (Join-Path $tempDir "*") -DestinationPath $zipPath -Force

# 清理
Remove-Item $tempDir -Recurse -Force

Write-Host "备份完成: $zipPath" -ForegroundColor Green