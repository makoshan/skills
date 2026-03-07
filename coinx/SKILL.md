---
name: coinx
description: 使用 coinx CLI（ccxt + ta）查询加密货币价格、K线和多指标共振信号，输出机器可读 JSON，适用于新闻信号确认与量化分析。
homepage: https://github.com/makoshan/tg-crypto-listener
metadata: {"clawdbot":{"emoji":"📈","requires":{"bins":["python"]}}}
---

# coinx

使用 `coinx` CLI 查询价格、K线和技术指标信号（不执行下单）。

安装
- Python 依赖：`pip install ccxt pandas numpy ta pytest`

快速入门
- 查看帮助：`python -m coinx --help`

常用命令
- 价格快照：`python -m coinx price --ex okx --symbol BTC/USDT`
- K线数据：`python -m coinx candle --ex okx --symbol BTC/USDT --tf 1h --limit 200`
- 共振信号：`python -m coinx ta confluence --ex okx --symbol BTC/USDT --tf-main 1h --tf-htf 4h --lookback 500`

输出要点
- 默认输出 JSON。
- 关键字段：
  - `price.last`, `price.chg24h_pct`, `price.vol24h`
  - `indicators`（RSI/MACD/OBV/VWMA/MFI/CCI/CMF/ATR/MA/SAR/Breakout/日周RSI）
  - `signals`（`trend_gate_long`, `entry_filter_long`, `tp_filter`）
  - `score`（`score_main`, `score_htf`, `final_bias`）
  - `structure.events`（如 `SOW`, `LPSY`, `ST`）

退出码
- `0` 成功
- `2` 参数错误
- `3` 数据错误
- `4` 计算错误
- `1` 其他内部错误

在 tg-crypto-listener 中的用途
- 作为新闻/情绪信号的技术面确认层。
- 将 `final_bias` 与 `score_main/score_htf` 融合进 AI `action/confidence`。
- 用 `breakout_high40/breakout_low40` 作为事件触发后的关键位校验。

