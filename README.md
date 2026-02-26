# 技能

Skill 是由指令、脚本和资源组成的文件夹，AI 会动态加载这些内容，以提升在特定任务上的表现。  
Skill 可以让 AI 以可复用、可重复的方式完成特定任务，例如按公司品牌规范创建文档、按组织既定流程分析数据，或自动化日常个人工作任务。

## 个人说明

这个仓库是我的个人项目，用于整理与沉淀我自己的 Skill，用于后续个人工作流与自动化任务的复用。

# Skill 分类

- [./skills](./skills)：创意与设计、开发与技术、企业与协作、文档相关 Skill 示例
- [./spec](./spec)：Agent Skills 规范
- [./template](./template)：Skill 模板


# 创建基础 Skill

创建 Skill 很简单：只需新建一个包含 `SKILL.md` 的文件夹，并在其中写入 YAML frontmatter 与说明。你可以直接使用本仓库中的 `template-skill` 作为起点：

```markdown
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---

# My Skill Name

[Add your instructions here that Claude will follow when this skill is active]

## Examples
- Example usage 1
- Example usage 2

## Guidelines
- Guideline 1
- Guideline 2
```

Frontmatter 目前仅需要两个字段：
- `name`：Skill 的唯一标识（小写，空格使用连字符）
- `description`：对 Skill 功能及使用场景的完整描述

位于 `SKILL.md` 的正文内容包括说明、示例与规则，Claude 在该 Skill 生效时会依据这些内容执行。详见 [How to create custom skills](https://support.claude.com/en/articles/12512198-creating-custom-skills)。

# 补充：openclaw、Codex、Claude Code、Skill 放置位置与配置

## 1) Skill 放哪里
- 仓库内优先位置：`./skills/<skill-name>/SKILL.md`
- 个人集中管理建议：仍放在本项目 `skills` 目录，方便版本管理。
- 通用能力平台也可读取：`$CODEX_HOME/skills`（若未设置，通常是 `~/.codex/skills`）

## 2) openclaw 放哪里 / 如何配置
- openclaw 常作为本地网关/代理命令行工具，通常独立于本仓库运行（不建议把可执行文件塞到项目里）。
- 常见做法：
  - 命令行工具安装到系统 `PATH` 可执行路径。
  - 配置文件放在用户目录下的配置目录（常见是 `~/.config/openclaw/`，具体以你安装包为准）。
- 最小排障命令：
  - `openclaw --help`
  - `openclaw gateway status`
  - `openclaw gateway status`（若提示不可用，说明服务端口/登录信息需先配置）

## 3) Codex 放哪里 / 如何配置
- 代码（本仓库里的 Skill）放在 `~/.codex/skills` 或 `$CODEX_HOME/skills`
- `CODEX_HOME` 可在环境变量中显式设置，示例：
```bash
export CODEX_HOME="$HOME/.codex"
```
- 安装与生效验证：
  - `echo "$CODEX_HOME"`
  - `ls "$CODEX_HOME/skills"`

## 4) Claude Code 放哪里 / 如何配置
- Claude Code 的 Skill 入口主要通过插件机制，而不是把 Skill 代码直接放在 Claude Code 安装目录。
- 建议流程：
  - 先保留 Skill 源文件在本仓库（如本项目的 `skills/`）
  - 在 Claude Code 执行插件注册命令并安装需要的 Skill 集合
- 配置核对（常见）：
  - `~/.claude/settings.json`（包含运行偏好/钥匙信息，按你的实际客户端版本为准）

建议：若某个组件的默认路径与你机器上不一致，先用 `which <command>` 和 `ls` 先确认后再按上述目录映射调整。
