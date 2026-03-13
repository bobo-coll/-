#!/bin/bash
# setup-chiku-calendar.sh
# 此腳本用於建立 chiku-calendar GitHub 儲存庫並推送程式碼
# 使用方式: GITHUB_TOKEN=your_pat bash setup-chiku-calendar.sh

set -e

OWNER="bobo-coll"
REPO="chiku-calendar"
GITHUB_TOKEN="${GITHUB_TOKEN:?請先設定 GITHUB_TOKEN 環境變數}"

echo "1. 建立 GitHub 儲存庫 ${OWNER}/${REPO}..."
curl -f -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -X POST https://api.github.com/user/repos \
  -d "{
    \"name\": \"${REPO}\",
    \"description\": \"個人行事曆 by 柏宏\",
    \"private\": false,
    \"auto_init\": false
  }" | python3 -c "import sys,json; r=json.load(sys.stdin); print('✓ 儲存庫建立完成:', r['html_url'])"

echo "2. 推送程式碼到 main branch..."
git remote add chiku "https://x-access-token:${GITHUB_TOKEN}@github.com/${OWNER}/${REPO}.git" 2>/dev/null || \
  git remote set-url chiku "https://x-access-token:${GITHUB_TOKEN}@github.com/${OWNER}/${REPO}.git"
git push chiku main
echo "✓ 程式碼推送完成"

echo "3. 開啟 GitHub Pages..."
curl -f -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -X POST "https://api.github.com/repos/${OWNER}/${REPO}/pages" \
  -d '{
    "source": {
      "branch": "main",
      "path": "/"
    }
  }' | python3 -c "import sys,json; r=json.load(sys.stdin); print('✓ GitHub Pages 設定完成:', r.get('html_url','(等待佈建)'))"

echo ""
echo "=============================="
echo "完成！請稍等幾分鐘，Pages 網址："
echo "https://${OWNER}.github.io/${REPO}/"
echo "=============================="
