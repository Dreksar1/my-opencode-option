#!/usr/bin/env bash
# ============================================================
#  my-opencode-option 一键恢复脚本 (macOS / Linux)
#  用法: 克隆仓库后执行:
#    chmod +x setup.sh && ./setup.sh
# ============================================================
set -e

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "========================================"
echo "  my-opencode-option 环境恢复脚本"
echo "========================================"

# ---- 0. 前置检查 ----
if ! command -v npm >/dev/null 2>&1; then
    echo "[错误] 未找到 npm。请先安装 Node.js (https://nodejs.org) 并重试。"
    exit 1
fi

# ---- 1. 安装 opencode ----
echo "[1/5] 正在安装 opencode (npm 全局) ..."
npm install -g opencode-ai

# ---- 2. 复制配置文件到正确位置 ----
copy_dir() {
    if [ -d "$1" ]; then
        mkdir -p "$2"
        cp -R "$1/." "$2/"
        echo "  -> 已复制到 $2"
    fi
}

echo "[2/5] 正在复制配置文件 ..."
copy_dir "$REPO/opencode" "$HOME_DIR/.config/opencode"
copy_dir "$REPO/omo"      "$HOME_DIR/.omo"
copy_dir "$REPO/skills"   "$HOME_DIR/.cache/opencode/skills"
copy_dir "$REPO/claude"   "$HOME_DIR/.claude"

# ---- 3. 安装 opencode 插件依赖 ----
echo "[3/5] 正在安装插件依赖 (npm install) ..."
if [ -f "$HOME_DIR/.config/opencode/package.json" ]; then
    (cd "$HOME_DIR/.config/opencode" && npm install)
fi

# ---- 4. 检查环境变量 ----
echo "[4/5] 检查 ZHIPU_API_KEY 环境变量 ..."
if [ -z "$ZHIPU_API_KEY" ]; then
    echo "  [提示] 未检测到 ZHIPU_API_KEY 环境变量。"
    echo "  如需使用智谱(GLM)模型，请执行："
    echo "      echo 'export ZHIPU_API_KEY=你的智谱密钥' >> ~/.zshrc  # 或 ~/.bashrc"
    echo "  然后执行 source ~/.zshrc 使生效"
fi

# ---- 5. 完成 ----
echo "[5/5] 完成! 现在运行 opencode 即可使用。"
