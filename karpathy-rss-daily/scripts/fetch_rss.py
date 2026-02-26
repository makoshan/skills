#!/usr/bin/env python3
"""
Fetch Karpathy's curated RSS feed and extract recent articles.
"""

import json
import sys
from datetime import datetime, timedelta, timezone
from xml.etree import ElementTree as ET
import urllib.request
import urllib.error

RSS_URL = "https://youmind.com/rss/pack/andrej-karpathy-curated-rss"
HOURS_LOOKBACK = 24

def fetch_rss():
    """Fetch and parse RSS feed."""
    try:
        req = urllib.request.Request(RSS_URL, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=30) as response:
            return response.read().decode("utf-8")
    except urllib.error.URLError as e:
        print(f"Error fetching RSS: {e}", file=sys.stderr)
        sys.exit(1)

def parse_atom_feed(xml_content):
    """Parse Atom feed and extract entries."""
    ns = {"atom": "http://www.w3.org/2005/Atom"}
    root = ET.fromstring(xml_content)
    
    entries = []
    cutoff = datetime.now(timezone.utc) - timedelta(hours=HOURS_LOOKBACK)
    
    for entry in root.findall("atom:entry", ns):
        try:
            title = entry.find("atom:title", ns)
            link = entry.find("atom:link", ns)
            published = entry.find("atom:published", ns)
            author_elem = entry.find("atom:author/atom:name", ns)
            summary = entry.find("atom:summary", ns)
            content = entry.find("atom:content", ns)
            
            # Parse date
            pub_text = published.text if published is not None else None
            if pub_text:
                # Handle ISO format with Z suffix
                pub_text = pub_text.replace("Z", "+00:00")
                pub_date = datetime.fromisoformat(pub_text)
                
                # Skip old entries
                if pub_date < cutoff:
                    continue
            else:
                continue
            
            entries.append({
                "title": title.text if title is not None else "Untitled",
                "link": link.get("href") if link is not None else None,
                "published": pub_date.isoformat(),
                "source": author_elem.text if author_elem is not None else "Unknown",
                "summary": (summary.text or "")[:500] if summary is not None else "",
                "has_content": content is not None and bool(content.text),
            })
        except Exception as e:
            print(f"Error parsing entry: {e}", file=sys.stderr)
            continue
    
    return entries

def group_by_source(entries):
    """Group entries by source."""
    grouped = {}
    for entry in entries:
        source = entry["source"]
        if source not in grouped:
            grouped[source] = []
        grouped[source].append(entry)
    return grouped

def main():
    xml_content = fetch_rss()
    entries = parse_atom_feed(xml_content)
    grouped = group_by_source(entries)
    
    result = {
        "fetched_at": datetime.now(timezone.utc).isoformat(),
        "lookback_hours": HOURS_LOOKBACK,
        "total_entries": len(entries),
        "sources": len(grouped),
        "by_source": grouped,
        "all_entries": sorted(entries, key=lambda x: x["published"], reverse=True),
    }
    
    print(json.dumps(result, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
