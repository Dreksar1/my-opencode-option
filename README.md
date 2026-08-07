# my-opencode-option

包含了我的 opencode 所有插件和配置。换新系统时**一键恢复**。

## 快速开始（推荐）

克隆本仓库后运行一键脚本，自动完成：安装 opencode → 恢复全部配置 → 安装插件依赖。

**Windows：**
```powershell
# 克隆仓库后，在仓库目录执行：
.\setup.ps1
```

**macOS / Linux：**
```bash
git clone <你的仓库地址>
cd my-opencode-option
chmod +x setup.sh && ./setup.sh
```

> 前置要求：已安装 Node.js（>=18）。脚本会自动安装 opencode 本体（npm 全局包 `opencode-ai`）。

## 目录结构与恢复位置

## 目录结构与恢复位置

| 本仓库目录 | 恢复到新系统的位置 | 内容 |
|---|---|---|
| `opencode/` | `~/.config/opencode/` | 主配置（opencode.json / opencode.jsonc / tui.json / package.json / .gitignore） |
| `opencode/plugins-custom/` | `~/.config/opencode/plugins-custom/` | 自定义插件：deepseek-balance（DeepSeek 余额监控） |
| `opencode/themes/` | `~/.config/opencode/themes/` | 主题文件 |
| `omo/` | `~/.omo/` | OMO 配置（各 agent 的模型分配） |
| `skills/` | `~/.cache/opencode/skills/` | skills：security-research / security-review |
| `claude/` | `~/.claude/` | MCP 服务器配置（.mcp.json） |

## 新系统恢复步骤

### 1. 安装前置依赖
```bash
# 安装 Git、Node.js（>=18）、uv（用于 MCP 服务器）
```

### 2. 恢复配置
```bash
# 将本仓库内容复制到对应位置（Windows 用户目录 ~ = C:\Users\你的用户名）
# 例如：
#   opencode/  →  ~/.config/opencode/
#   omo/       →  ~/.omo/
#   skills/    →  ~/.cache/opencode/skills/
#   claude/    →  ~/.claude/
```

### 3. 设置环境变量（重要）
```bash
# 智谱 API key（opencode.jsonc 里引用的是这个环境变量）
setx ZHIPU_API_KEY "你的智谱API密钥"
```

### 4. 安装插件依赖
```bash
cd ~/.config/opencode
npm install
```

### 5. 完成
启动 opencode 即可，oh-my-openagent 插件会自动安装。

## 注意
- **不要上传/恢复** `auth.json`、`daemon.auth`、`node_modules/`、`.local/share/opencode/` 等含密钥或缓存的文件
- `opencode.jsonc` 中的 `apiKey` 已替换为 `{env:ZHIPU_API_KEY}`，请通过环境变量注入，不要把明文密钥写进配置
