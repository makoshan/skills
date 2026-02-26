# Manus API Quickstart (summary)

- Base URL: https://api.manus.ai
- Create task: POST /v1/tasks
- Header: API_KEY: <MANUS_API_KEY>
- Payload: {"prompt": "..."}

Example:
```
curl --request POST \
  --url 'https://api.manus.ai/v1/tasks' \
  --header 'accept: application/json' \
  --header 'content-type: application/json' \
  --header "API_KEY: $MANUS_API_KEY" \
  --data '{"prompt": "hello"}'
```
