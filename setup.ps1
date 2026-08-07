# ============================================================
#  my-opencode-option 一键恢复脚本 (Windows)
#  用法: 克隆仓库后，右键 setup.ps1 -> "使用 PowerShell 运行"
#        或在 PowerShell 中执行: .\setup.ps1
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  my-opencode-option 环境恢复脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# ---- 0. 前置检查 ----
$npmOk = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmOk) {
    Write-Host "[错误] 未找到 npm。请先安装 Node.js (https://nodejs.org) 并重试。" -ForegroundColor Red
    exit 1
}

# ---- 1. 安装 opencode ----
Write-Host "[1/5] 正在安装 opencode (npm 全局) ..." -ForegroundColor Yellow
npm install -g opencode-ai
if ($LASTEXITCODE -ne 0) {
    Write-Host "[错误] opencode 安装失败，请检查网络后重试。" -ForegroundColor Red
    exit 1
}

# ---- 2. 复制配置文件到正确位置 ----
$repo  = $PSScriptRoot
$homeDir = $HOME

$targets = @(
    @{ Src = "$repo\opencode"; Dst = "$homeDir\.config\opencode" },
    @{ Src = "$repo\omo";      Dst = "$homeDir\.omo" },
    @{ Src = "$repo\skills";   Dst = "$homeDir\.cache\opencode\skills" },
    @{ Src = "$repo\claude";   Dst = "$homeDir\.claude" }
)

Write-Host "[2/5] 正在复制配置文件 ..." -ForegroundColor Yellow
foreach ($t in $targets) {
    if (Test-Path $t.Src) {
        New-Item -ItemType Directory -Path $t.Dst -Force | Out-Null
        Copy-Item "$($t.Src)\*" $t.Dst -Recurse -Force
        Write-Host "  -> 已复制到 $($t.Dst)" -ForegroundColor Green
    }
}

# ---- 3. 安装 opencode 插件依赖 ----
Write-Host "[3/5] 正在安装插件依赖 (npm install) ..." -ForegroundColor Yellow
$configDir = "$homeDir\.config\opencode"
if (Test-Path "$configDir\package.json") {
    Push-Location $configDir
    npm install
    Pop-Location
}

# ---- 4. 检查环境变量 ----
Write-Host "[4/5] 检查 ZHIPU_API_KEY 环境变量 ..." -ForegroundColor Yellow
if (-not $env:ZHIPU_API_KEY) {
    Write-Host "  [提示] 未检测到 ZHIPU_API_KEY 环境变量。" -ForegroundColor Magenta
    Write-Host "  如需使用智谱(GLM)模型，请执行以下命令（需重新打开终端生效）：" -ForegroundColor Magenta
    Write-Host "      setx ZHIPU_API_KEY 你的智谱密钥" -ForegroundColor Magenta
}

# ---- 5. 完成 ----
Write-Host "[5/5] 完成! 现在运行 opencode 即可使用。" -ForegroundColor Green
Write-Host "      如果终端认不出 opencode，请重新打开一个终端窗口。" -ForegroundColor Green
