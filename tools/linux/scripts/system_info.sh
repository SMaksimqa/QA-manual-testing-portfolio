# Диагностика системы с прогресс барами CPU RAM/Disk
#!/bin/bash

# system_info.sh — Collect and display system diagnostics

# Usage: ./system_info.sh [–log]

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────

RED=’\033[0;31m’; YELLOW=’\033[1;33m’; GREEN=’\033[0;32m’
CYAN=’\033[0;36m’; BOLD=’\033[1m’; RESET=’\033[0m’

LOG_MODE=false
[[ “${1:-}” == “–log” ]] && LOG_MODE=true

OUTPUT_FILE=”/tmp/sysinfo_$(hostname)*$(date +%Y%m%d*%H%M%S).txt”

# ── Helper functions ─────────────────────────────────────────────────────────

header() { echo -e “\n${CYAN}${BOLD}══ $1 ══${RESET}”; }
ok()     { echo -e “${GREEN}✓${RESET} $1”; }
warn()   { echo -e “${YELLOW}⚠${RESET}  $1”; }
err()    { echo -e “${RED}✗${RESET} $1”; }

print_bar() {
local used=$1 total=$2 label=$3
local pct=$(( used * 100 / total ))
local filled=$(( pct / 5 ))
local bar=””
for ((i=0; i<20; i++)); do
[[ $i -lt $filled ]] && bar+=“█” || bar+=“░”
done
local color=$GREEN
(( pct > 80 )) && color=$RED
(( pct > 60 && pct <= 80 )) && color=$YELLOW
echo -e “  ${label}: [${color}${bar}${RESET}] ${pct}%”
}

# ── Main report ──────────────────────────────────────────────────────────────

{
echo -e “${BOLD}System Information Report${RESET}”
echo “Generated: $(date)”
echo “Hostname:  $(hostname -f 2>/dev/null || hostname)”

header “OS & Kernel”
echo “  OS:      $(grep PRETTY_NAME /etc/os-release | cut -d’”’ -f2)”
echo “  Kernel:  $(uname -r)”
echo “  Arch:    $(uname -m)”
echo “  Uptime:  $(uptime -p)”

header “CPU”
CPU_MODEL=$(grep ‘model name’ /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
CPU_CORES=$(nproc)
LOAD=$(cut -d’ ’ -f1-3 /proc/loadavg)
echo “  Model:   ${CPU_MODEL}”
echo “  Cores:   ${CPU_CORES}”
echo “  Load:    ${LOAD} (1m 5m 15m)”

header “Memory”
MEM_TOTAL=$(awk ‘/MemTotal/ {print $2}’ /proc/meminfo)
MEM_AVAIL=$(awk ‘/MemAvailable/ {print $2}’ /proc/meminfo)
MEM_USED=$(( MEM_TOTAL - MEM_AVAIL ))
MEM_TOTAL_MB=$(( MEM_TOTAL / 1024 ))
MEM_USED_MB=$(( MEM_USED / 1024 ))
echo “  Total: ${MEM_TOTAL_MB} MB  |  Used: ${MEM_USED_MB} MB  |  Free: $(( MEM_TOTAL_MB - MEM_USED_MB )) MB”
print_bar $MEM_USED $MEM_TOTAL “RAM”

SWAP_TOTAL=$(awk ‘/SwapTotal/ {print $2}’ /proc/meminfo)
if (( SWAP_TOTAL > 0 )); then
SWAP_FREE=$(awk ‘/SwapFree/ {print $2}’ /proc/meminfo)
SWAP_USED=$(( SWAP_TOTAL - SWAP_FREE ))
print_bar $SWAP_USED $SWAP_TOTAL “Swap”
fi

header “Disk Usage”
df -h –output=target,size,used,avail,pcent | grep -E ‘^(/|/home|/var|/tmp)’ | while read -r line; do
echo “  $line”
done

header “Network Interfaces”
ip -o addr show | awk ‘{print “  “ $2 “\t” $4}’ | grep -v ‘^  lo’

header “Top 5 Processes (by CPU)”
ps aux –sort=-%cpu | awk ‘NR==1 || NR<=6 {printf “  %-10s %-6s %-6s %s\n”, $1, $3, $4, $11}’

header “Recent Login History”
last -n 5 2>/dev/null | head -5 | awk ‘{print “  “ $0}’ || echo “  (not available)”

header “Services Status”
for svc in ssh nginx mysql postgresql docker; do
if systemctl list-units –type=service –quiet 2>/dev/null | grep -q “$svc”; then
if systemctl is-active –quiet “$svc” 2>/dev/null; then
ok “$svc is running”
else
warn “$svc is stopped”
fi
fi
done

echo -e “\n${GREEN}Report complete.${RESET}”

} | tee -a “$( [[ $LOG_MODE == true ]] && echo “$OUTPUT_FILE” || echo /dev/null )”

[[ $LOG_MODE == true ]] && echo -e “\nSaved to: ${OUTPUT_FILE}”
