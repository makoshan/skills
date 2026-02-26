# Manus Webhooks (docs.manus.im/api/webhooks)

## 概览
Webhooks 用于在任务生命周期关键事件发生时发送 HTTP POST 到回调 URL。

## 事件类型
- task_created：任务创建后首次发送
- task_progress：任务执行中多次发送（计划/进度更新）
- task_stopped：任务完成或需要输入时发送
  - stop_reason: "finish" 任务完成
  - stop_reason: "ask" 需要用户输入

## 典型事件序列
1) task_created
2) task_progress（多次）
3) task_stopped

## 端点要求
- 需响应 HTTP 200
- 接收 JSON POST
- 10 秒内返回

## 安全建议
- 验证 payload（签名/来源校验）

## 常见问题
- URL 不可达/非 200 → 无法接收事件
- TLS/证书错误
- 超时（>10s）

## 测试工具
- webhook.site
- ngrok
- Postman/curl
