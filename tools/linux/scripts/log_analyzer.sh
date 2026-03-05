# Анализ nginx/auth/syslog логов (topIP коды ответов брутфорс)
#!/bin/bash

# log_analyzer.sh — Parse nginx/syslog/auth logs and print a summary

# Usage: ./log_analyzer.sh [nginx|auth|syslog] [logfile]

set -euo pipefail

MODE=”${1:-nginx}”
LOGFILE=”${2:-}”

BOLD=’\033[1m’; CYAN=’\033[0;36m’; RED=’\033[0;31m’
GREEN=’\033[0;32m’; YELLOW=’\033[1;33m’; RESET=’\033[0m’

header() { echo -e “\n${CYAN}${BOLD}─── $1 ───${RESET}”; }

# ── Nginx access log analysis ─────────────────────────────────────────────────

analyze_nginx() {
local log=”${LOGFILE:-/var/log/nginx/access.log}”
[[ ! -f “$log” ]] && { echo “File not found: $log”; exit 1; }
echo -e "${BOLD}Nginx Access Log:${RESET} $log"
echo "Lines: $(wc -l < "$log")"

header "Top 10 IP Addresses"
awk '{print $1}' "$log" | sort | uniq -c | sort -rn | head -10 \
    | awk '{printf "  %6d  %s\n", $1, $2}'

header "HTTP Status Codes"
awk '{print $9}' "$log" | sort | uniq -c | sort -rn \
    | awk '{printf "  %s  %d requests\n", $2, $1}'

header "Top 10 Requested URLs"
awk '{print $7}' "$log" | sort | uniq -c | sort -rn | head -10 \
    | awk '{printf "  %6d  %s\n", $1, $2}'

header "Top 10 User Agents"
awk -F'"' '{print $6}' "$log" | sort | uniq -c | sort -rn | head -10 \
    | awk '{printf "  %5d  %s\n", $1, substr($0, index($0,$2))}'

header "Requests per Hour (today)"
grep "$(date '+%d/%b/%Y')" "$log" 2>/dev/null \
    | awk '{print $4}' | cut -d: -f2 | sort | uniq -c \
    | awk '{printf "  %02d:00  %s requests\n", $2, $1}' || echo "  No data for today"

header "4xx and 5xx Errors"
grep -E '" (4|5)[0-9]{2} ' "$log" | awk '{print $9, $7}' \
    | sort | uniq -c | sort -rn | head -10 \
    | awk '{printf "  %5d  HTTP %s  %s\n", $1, $2, $3}'

}

# ── Auth log analysis ─────────────────────────────────────────────────────────

analyze_auth() {
local log=”${LOGFILE:-/var/log/auth.log}”
[[ ! -f “$log” ]] && { echo “File not found: $log”; exit 1; }
echo -e "${BOLD}Auth Log:${RESET} $log"

header "Failed SSH Login Attempts"
FAIL_COUNT=$(grep -c "Failed password" "$log" 2>/dev/null || echo 0)
echo "  Total failed attempts: ${FAIL_COUNT}"

echo -e "\n  Top attacking IPs:"
grep "Failed password" "$log" 2>/dev/null \
    | grep -oP '(\d{1,3}\.){3}\d{1,3}' | sort | uniq -c | sort -rn | head -10 \
    | awk '{printf "  %6d  %s\n", $1, $2}'

header "Successful Logins"
grep "Accepted password\|Accepted publickey" "$log" 2>/dev/null \
    | awk '{print $1, $2, $3, $9, $11}' | tail -10 \
    | awk '{printf "  %s %s %s  user=%s  from=%s\n", $1, $2, $3, $4, $5}' \
    || echo "  None found"

header "sudo Usage"
grep "sudo:" "$log" 2>/dev/null | grep "COMMAND" | tail -10 \
    | awk -F'COMMAND=' '{print "  " $2}' || echo "  None found"

}

# ── Syslog analysis ───────────────────────────────────────────────────────────

analyze_syslog() {
local log=”${LOGFILE:-/var/log/syslog}”
[[ ! -f “$log” ]] && log=”/var/log/messages”
[[ ! -f “$log” ]] && { echo “File not found”; exit 1; }
echo -e "${BOLD}Syslog:${RESET} $log"

header "Error Count by Service"
grep -i "error\|critical\|emerg" "$log" 2>/dev/null \
    | awk '{print $5}' | sort | uniq -c | sort -rn | head -10 \
    | awk '{printf "  %5d  %s\n", $1, $2}' || echo "  No errors found"

header "Last 10 Critical Messages"
grep -i "critical\|emerg\|alert" "$log" 2>/dev/null | tail -10 \
    | awk '{$1=$2=$3=""; print "  " $0}' || echo "  None"

header "Kernel OOM Events"
grep -i "out of memory\|OOM" "$log" 2>/dev/null | wc -l \
    | xargs -I{} echo "  OOM events: {}"

}

# ── Dispatch ──────────────────────────────────────────────────────────────────

case “$MODE” in
nginx)   analyze_nginx ;;
auth)    analyze_auth ;;
syslog)  analyze_syslog ;;
*)
echo “Usage: $0 [nginx|auth|syslog] [logfile]”
echo “  nginx   — analyze nginx access.log”
echo “  auth    — analyze auth.log (SSH attempts, sudo)”
echo “  syslog  — analyze syslog (errors, OOM)”
exit 1
;;
esac
