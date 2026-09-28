#!/bin/bash
set -e

echo "[$(date -u)] Starting OddsHarvester scrape task..."

# 建立存放資料的資料夾
mkdir -p /app/output

# 執行爬蟲：抓取英超聯賽（足球）、勝平負/讓球/大小球盤口，存成 JSON 檔
uv run oddsharvester upcoming -s football -l england-premier-league -m 1x2,asian_handicap,over_under -f json -o /app/output/upcoming.json --headless

echo "[$(date -u)] Scrape completed successfully."
