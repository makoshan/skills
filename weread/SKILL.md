---
name: weread
description: |
  Use this skill when the user wants to search books on WeRead (微信读书), look up book details, check book availability, or find books by title/author/keyword on weread.qq.com. Also trigger when the user mentions "微信读书", "weread", or wants to check if a book is available on WeRead.
---

# WeRead 微信读书搜索

Search books on WeRead (微信读书) using the public API.

## Instructions

When the user invokes `/weread <query>`, search WeRead and present the results.

### Step 1: Parse the query

The argument after `/weread` is the search keyword. Examples:
- `/weread 烟霞洞` → search for "烟霞洞"
- `/weread 三体 刘慈欣` → search for "三体 刘慈欣"
- `/weread bookId:31131759` → fetch details for a specific book

### Step 2: Call the API

Use the Bash tool to call the WeRead search API:

```bash
curl -s 'https://weread.qq.com/web/search/global?keyword=ENCODED_KEYWORD' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' \
  -H 'Accept: application/json' \
  -H 'Referer: https://weread.qq.com/'
```

Replace `ENCODED_KEYWORD` with the URL-encoded search keyword. Use `python3 -c "import urllib.parse; print(urllib.parse.quote('关键词'))"` to encode if needed.

### Step 3: Parse and display results

Parse the JSON response with a Python one-liner or jq. The response structure:

```
{
  "books": [
    {
      "bookInfo": {
        "bookId": "...",
        "title": "...",
        "author": "...",
        "cover": "https://cdn.weread.qq.com/...",
        "intro": "...",
        "publisher": "...",
        "price": 0,          // in cents (分)
        "bookStatus": 1,     // 1=available, 5=pending
        "soldout": 0,        // 0=available, 1=removed
        "payType": 4097,
        "format": "epub",
        "newRating": 797,    // divide by 10 for percentage (79.7%)
        "newRatingCount": 3930
      },
      "bookContentInfo": {          // present when keyword found in book content
        "chapterTitle": "...",
        "abstract": "...",          // text snippet with keyword context
        "keyword": ["烟霞洞"]
      },
      "readingCount": 15043,        // daily readers
      "subscribeCount": 1
    }
  ],
  "totalCount": 847,
  "hasMore": true
}
```

### Step 4: Format the output

Present results as a markdown table with these columns:

| # | Title | Author | Rating | Daily Readers | Status | Price | Link |
|---|-------|--------|--------|---------------|--------|-------|------|

Rules for formatting:
- **Rating**: `newRating / 10`% (e.g., 797 → 79.7%). Show "—" if not available.
- **Daily Readers**: `readingCount`. Show "—" if 0.
- **Status**:
  - `bookStatus=1` + `soldout=0` → "可读"
  - `bookStatus=5` or `soldout=1` → "待上架"
- **Price**: `price / 100` 元. If 0, show "免费".
- **Link**: `https://weread.qq.com/web/bookDetail/{bookId}`
- If `bookContentInfo` exists, show the matching chapter and text snippet below the table for that book.

### Additional capabilities

#### Book detail lookup
If the query starts with `bookId:`, fetch book details:
```bash
curl -s 'https://weread.qq.com/web/book/info?bookId=BOOK_ID' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36' \
  -H 'Referer: https://weread.qq.com/'
```

#### Book chapter list
```bash
curl -s 'https://weread.qq.com/web/book/chapter/e_0?bookId=BOOK_ID' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36' \
  -H 'Referer: https://weread.qq.com/'
```

#### Multiple searches
If the user provides multiple keywords separated by `|`, run each as a separate search and combine results.

## API Reference

| Endpoint | Method | Params | Description |
|----------|--------|--------|-------------|
| `/web/search/global` | GET | `keyword` | Search books by keyword |
| `/web/book/info` | GET | `bookId` | Get book details |
| `/web/book/chapter/e_0` | GET | `bookId` | Get chapter list |
| `/web/book/publicinfos` | GET | `bookIds` (comma-sep) | Batch book info |

All endpoints:
- Base URL: `https://weread.qq.com`
- No auth required for search
- Set `Referer: https://weread.qq.com/` header
- Rate limit: add 1-2s delay between batch requests
