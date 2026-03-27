## qBittorrent 配置备份与恢复脚本

本项目提供两个 PowerShell 脚本，用于备份和恢复 qBittorrent 的配置文件。

------

### 📦 备份脚本（backup-qbittorrent.ps1）

功能：

- 自动打包以下目录：
  - `%LOCALAPPDATA%\qBittorrent`
  - `%APPDATA%\qBittorrent`
- 生成 `.zip` 文件到桌面
- 文件名包含时间戳，避免覆盖

使用方法：

```powershell
.\backup-qbittorrent.ps1
```

------

### ♻️ 恢复脚本（restore-qbittorrent.ps1）

功能：

- 从备份的 ZIP 文件恢复配置
- 自动还原到原始路径
- 覆盖已有配置

使用方法：

```powershell
.\restore-qbittorrent.ps1 -f "路径\到\备份.zip"
```

------

### ⚠️ 注意事项

- 恢复前请确保 **qBittorrent 已关闭**
- 若检测到程序正在运行，脚本会直接退出
- 恢复操作会**覆盖当前配置文件**
- 建议恢复前手动备份现有配置（如有需要）

------

### 📁 适用场景

- 系统重装后恢复配置
- 多设备迁移 qBittorrent 设置
- 配置备份与版本管理