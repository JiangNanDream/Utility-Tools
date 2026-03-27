## Chrome 用户数据备份脚本

本项目提供一个 PowerShell 脚本，用于备份 Google Chrome 浏览器的用户数据（书签、扩展、历史记录等）。

------

### 📦 功能说明

- 备份指定 Chrome 用户 Profile 数据
- 自动打包为 `.zip` 文件
- 输出到桌面目录
- 文件名包含时间戳，避免覆盖

------

### 📁 备份路径说明

Chrome 用户数据默认位于：

```
%LOCALAPPDATA%\Google\Chrome\User Data\
```

常见 Profile 目录：

- `Default`
- `Profile 1`
- `Profile 2`

------

### 🔍 如何获取正确的 Profile 路径（重要）

请务必先确认你的实际 Profile 路径：

1. 打开 Chrome 浏览器
2. 在地址栏输入：

```
chrome://version/
```

1. 查看 **Profile Path（个人资料路径）**

示例：

```
C:\Users\你的用户名\AppData\Local\Google\Chrome\User Data\Profile 1
```

1. 根据结果修改脚本中的参数：

```powershell
-ProfileName "Profile 1"
```

------

### 🚀 使用方法

#### 1️⃣ 执行备份

```powershell
.\backup-chrome.ps1
```

#### 2️⃣ 指定 Profile（可选）

```powershell
.\backup-chrome.ps1 -ProfileName "Default"
```

------

### 📦 输出结果

备份文件将生成在桌面，例如：

```
chrome_backup_Profile 1_20260327_120000.zip
```

------

### ⚠️ 注意事项

- 建议在备份前关闭 Chrome 浏览器，避免文件占用
- 不同用户的 Profile 名可能不同，请务必确认路径
- 备份文件包含浏览器全部用户数据，请妥善保管

------

### 📌 适用场景

- 系统重装前备份浏览器数据
- 多设备迁移 Chrome 配置
- 数据备份与恢复