> # 使用 scoop 初始化系统
>
> ## 概述
>
> 本项目提供一个 PowerShell 脚本，可基于 JSON 配置文件，通过 Scoop 批量安装 Windows 软件。
>
> 脚本设计目标：
>
> - 以声明式方式管理软件安装
> - 自动处理 Scoop 仓库（包含自定义仓库）
> - 支持按环境分组安装软件
>
> 典型使用场景：
>
> - 初始化全新的开发电脑
> - 复现统一一致的开发环境
> - 在多台设备上管理工具链
>
> ## 使用方法
>
> ### 1. 前置条件
>
> 确保已安装 Scoop（需要管理员权限）：
>
> ```PowerShell
> iwr -useb get.scoop.sh | iex
> ```
>
> ### 2. 运行脚本
>
> 安装配置文件中的所有软件：
>
> ```PowerShell
> .\scoopInstall.ps1
> ```
>
> 指定自定义配置文件：
>
> ```PowerShell
> .\scoopInstall.ps1 -f .\apps.json
> ```
>
> 安装指定分组的软件：
>
> ```PowerShell
> .\scoopInstall.ps1 -f .\apps.json -Groups base,dev
> ```
>
> ## 配置文件
>
> 脚本通过 JSON 文件（默认：`apps.json`）定义：
>
> - 软件仓库（可选）
> - 软件分组
>
> ### 结构示例
>
> ```JSON
> {
>   "buckets": {
>     "extras": {},
>     "custom-bucket": {
>       "url": "https://example.com/repo.git"
>     }
>   },
>   "groups": {
>     "base": [
>       { "name": "git" },
>       { "name": "7zip" }
>     ],
>     "dev": [
>       { "name": "vscode", "bucket": "extras" }
>     ]
>   }
> }
> ```
>
> ### 字段说明
>
> - `buckets`
>
> 定义安装前需要添加的 Scoop 仓库
>
> - 若配置 `url`，则使用自定义仓库地址
> - 若留空，则使用 Scoop 官方默认仓库
>
> - `groups`
>
> 将软件按逻辑分组（如 `基础软件`、`开发工具`）
>
> - `name`
>
> Scoop 安装时使用的软件包名称
>
> - `bucket`（可选）
>
> 指定软件所属的仓库
>
> 你可以在 [Scoop 官网](https://scoop.sh/) 搜索需要的软件
>
> ## 示例
>
> 无需手动执行以下命令：
>
> ```PowerShell
> scoop bucket add scoopcn https://github.com/scoopcn/scoopcn.git
> scoop install baidudisk
> scoop install tim
> ```
>
> 只需在配置文件中定义：
>
> ```JSON
> {
>   "buckets": {
>     "scoopcn": {
>       "url": "https://github.com/scoopcn/scoopcn.git"
>     }
>   },
>   "groups": {
>     "tools": [
>       { "name": "baidudisk", "bucket": "scoopcn" },
>       { "name": "tim", "bucket": "scoopcn" }
>     ]
>   }
> }
> ```
>
> 然后执行命令：
>
> ```PowerShell
> .\scoopInstall.ps1 -Groups tools
> ```
>
> ## 推荐配置
>
> 可参考本仓库提供的 `apps.json` 文件，这是完整的配置示例。
>
> 你可以根据自身环境需求修改或扩展该配置。
>
> ## 许可证
>
> MIT 开源协议