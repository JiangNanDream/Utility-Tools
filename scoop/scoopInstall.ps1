param(
    [Alias("f")]
    [string]$ConfigFile = ".\apps.json",
	
    [string[]]$Groups = @()
)

# --------------------------
# 基础检查
# --------------------------
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop is not installed"
    exit 1
}

if (-not (Test-Path $ConfigFile)) {
    Write-Host "Config file not found: $ConfigFile"
    exit 1
}

# --------------------------
# 读取配置
# --------------------------
try {
    $config = Get-Content $ConfigFile | ConvertFrom-Json
} catch {
    Write-Host "Invalid JSON format"
    exit 1
}

# --------------------------
# 处理 bucket
# --------------------------
$existingBuckets = scoop bucket list | ForEach-Object {
    ($_ -split '\s+')[0]
}

if ($config.buckets) {
    foreach ($b in $config.buckets.PSObject.Properties) {

        $name = $b.Name
        $url = $b.Value.url

        if ($existingBuckets -contains $name) {
            continue
        }

        if ($url) {
            Write-Host "Adding bucket: $name ($url)"
            scoop bucket add $name $url
        } else {
            Write-Host "Adding bucket: $name"
            scoop bucket add $name
        }

        if ($LASTEXITCODE -eq 0) {
            $existingBuckets += $name
        } else {
            Write-Host "Failed to add bucket: $name"
        }
    }
}

# --------------------------
# 收集目标应用
# --------------------------
$targetApps = @()

if ($Groups.Count -eq 0) {
    foreach ($g in $config.groups.PSObject.Properties) {
        $targetApps += $g.Value
    }
} else {
    foreach ($g in $Groups) {
        if ($config.groups.$g) {
            $targetApps += $config.groups.$g
        } else {
            Write-Host "Group not found: $g"
        }
    }
}

# --------------------------
# 安装应用
# --------------------------
foreach ($app in $targetApps) {

    $name = $app.name

    if (-not $name) {
        continue
    }

    Write-Host ""
    Write-Host "Processing: $name"

    # 检查是否已安装
    $installed = scoop list | Where-Object { $_ -match "^$name\s" }

    if ($installed) {
        Write-Host "Already installed"
        continue
    }

    # 安装
    Write-Host "Installing..."
    scoop install $name

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success"
    } else {
        Write-Host "Failed"
    }
}

Write-Host ""
Write-Host "Done"