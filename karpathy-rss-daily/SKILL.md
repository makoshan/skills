---
name: karpathy-rss-daily
description: Generate daily briefings from Andrej Karpathy's curated RSS feeds. Use when asked to create AI/tech daily digest, Karpathy RSS report, or technology news briefing. Fetches past 24h content, reads original articles, and produces themed summaries.
---

# Karpathy RSS Daily

Generate daily briefings from Andrej Karpathy's curated RSS feeds.

## Data Source

- **Aggregated Feed**: `https://youmind.com/rss/pack/andrej-karpathy-curated-rss`
- **Original OPML**: `https://gist.github.com/emschwartz/e6d2bf860ccc367fe37ff953ba6de66b`

## Workflow

### 1. Fetch RSS Feed

```bash
python3 skills/karpathy-rss-daily/scripts/fetch_rss.py
```

Output: JSON with articles from past 24h, grouped by source.

### 2. Select Articles

- Pick 1-2 articles per source (prioritize recency + relevance)
- Skip duplicates or low-content entries

### 3. Read Original Content

For each selected article, use `web_fetch` to get full content:

```
web_fetch(url=article_link, maxChars=8000)
```

### 4. Generate Briefing

Create a document following the template below.

## Output Template

```markdown
# YYYY-MM-DD - Karpathy 精选 RSS 日报

> Andrej Karpathy 精选的信源资讯汇总 | 共 [N] 条更新

---

## 🔥 核心主题：【主题标题】

【合并相同主题的内容，带引用链接】

## {emoji}【主题 2】：【副标题】

...

---

## 📊 今日数据

- **XX** 条 RSS 更新
- **YY** 篇精选深度阅读
- **ZZ** 个核心主题：AA、BB、CC

## 💡 编者观察

【1-2 句观察或洞见】

---

*本日报由 AI 自动生成 | 数据源：[Andrej Karpathy curated RSS](https://youmind.com/rss/pack/andrej-karpathy-curated-rss)*
```

## Theme Emojis

- 🔥 热门/突发
- 🤖 AI/ML
- 💻 编程/开发
- 🔐 安全
- 📱 产品/设计
- 🌐 互联网/Web
- 📈 商业/融资
- 🧠 深度思考
- 🔧 工具/效率

## Cron Setup (Optional)

Schedule daily generation at 8:00 AM:

```json
{
  "name": "karpathy-daily",
  "schedule": { "kind": "cron", "expr": "0 8 * * *", "tz": "Asia/Shanghai" },
  "payload": { "kind": "agentTurn", "message": "生成今日 Karpathy 精选 RSS 日报" },
  "sessionTarget": "isolated",
  "delivery": { "mode": "announce" }
}
```

## Notes

- YouMind aggregates multiple sources into one feed (easier than parsing 100+ individual feeds)
- Focus on AI, security, systems, and engineering content
- Merge related articles under unified themes
- Always include source links for verification
