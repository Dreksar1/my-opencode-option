# my-opencode-option

包含了我的 opencode 所有插件和配置。换新系统时**一键恢复**。包含oh-my-opencode 和多个mcp

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

## 可选：GitHub CLI（gh）

OMO 的 GitHub 自动化功能（PR 创建、issue、代码搜索等）需要 [GitHub CLI](https://cli.github.com/)。建议安装并登录：

```bash
# Windows
winget install --id GitHub.cli -e

# macOS / Linux
# brew install gh  或访问 https://cli.github.com/

# 登录（浏览器授权）
gh auth login
```

验证配置是否正常：`omo doctor`（在 opencode 所在环境运行）。

## 目录结构与恢复位置

| 本仓库目录 | 恢复到新系统的位置 | 内容 |
|---|---|---|
| `opencode/` | `~/.config/opencode/` | 主配置（opencode.json / opencode.jsonc / tui.json / package.json / .gitignore） |
| `opencode/plugins-custom/` | `~/.config/opencode/plugins-custom/` | 自定义插件：deepseek-balance（DeepSeek 余额监控） |
| `omo/` | `~/.omo/` | OMO 配置（各 agent 的模型分配） |
| `skills/` | `~/.cache/opencode/skills/` | skills：security-research / security-review |
| `claude/` | `~/.claude/` | MCP 服务器配置（.mcp.json） |

> **注意**：旧格式主题文件（`themes/`）已从仓库移除。opencode 1.18+ 改用内置主题系统，**不要**再放自定义 `themes/*.json` 文件（旧格式会导致主题加载失败回退默认）。换主题请用 opencode 内的 `/theme` 命令。

## 插件说明

| 插件 | 安装方式 | 说明 |
|---|---|---|
| oh-my-openagent (OMO) | `opencode.jsonc` 的 `plugin` 字段，opencode 自动从 npm 安装 | 多模型编排、并行后台 agent、LSP/AST 工具 |
| superpowers | **git clone**（见下方） | 完整软件开发方法论技能集（brainstorming、TDD、debugging 等 14 个 skills） |
| deepseek-balance | 仓库自带 `plugins-custom/` | DeepSeek 余额监控（TUI 侧边栏显示） |

### superpowers 安装（重要）

`opencode.json` 已配置 `"plugin": ["~/.config/opencode/node_modules/superpowers"]`，但 **npm 的 git 依赖安装在 Windows 上有已知问题**（官方文档确认）。正确安装方式：

```bash
# 在 ~/.config/opencode/ 下执行：
git clone --depth 1 https://github.com/obra/superpowers.git "$HOME/.config/opencode/node_modules/superpowers"
# Windows: git clone --depth 1 https://github.com/obra/superpowers.git %USERPROFILE%\.config\opencode\node_modules\superpowers
```

安装后重启 opencode，用 `Tell me about your superpowers` 验证。setup 脚本已包含此步骤。

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

### 5. 安装 superpowers 插件（如果 setup 脚本没装成功）
```bash
# Windows:
git clone --depth 1 https://github.com/obra/superpowers.git %USERPROFILE%\.config\opencode\node_modules\superpowers
# macOS/Linux:
git clone --depth 1 https://github.com/obra/superpowers.git "$HOME/.config/opencode/node_modules/superpowers"
```

### 6. 完成
启动 opencode 即可，oh-my-openagent 插件会自动安装。验证 superpowers：`Tell me about your superpowers`

## 注意
- **不要上传/恢复** `auth.json`、`daemon.auth`、`node_modules/`、`.local/share/opencode/` 等含密钥或缓存的文件
- `opencode.jsonc` 中的 `apiKey` 已替换为 `{env:ZHIPU_API_KEY}`，请通过环境变量注入，不要把明文密钥写进配置
