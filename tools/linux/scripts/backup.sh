# Инкрементальные бэкапы через rsync c ротацией
#!/bin/bash

# backup.sh — Incremental backup with rotation and logging

# Usage: ./backup.sh <source_dir> <dest_dir> [–keep N]

# 

# Examples:

# ./backup.sh /home/user/projects /mnt/backup

# ./backup.sh /var/www /backup/www –keep 7

set -euo pipefail

# ── Config ───────────────────────────────────────────────────────────────────

SOURCE=”${1:-}”
DEST=”${2:-}”
KEEP=5          # default: keep 5 backups
LOG_FILE=”/var/log/backup.log”

# Parse –keep flag

for i in “$@”; do
if [[ “$i” == “–keep” ]]; then
KEEP=”${@: $((${#@} - 0)):1}” 2>/dev/null || true
fi
done
[[ “${3:-}” == “–keep” ]] && KEEP=”${4:-5}”

# ── Validate ─────────────────────────────────────────────────────────────────

if [[ -z “$SOURCE” || -z “$DEST” ]]; then
echo “Usage: $0 <source_dir> <dest_dir> [–keep N]”
exit 1
fi

[[ ! -d “$SOURCE” ]] && { echo “Error: source ‘$SOURCE’ not found”; exit 1; }

mkdir -p “$DEST”

# ── Logging ──────────────────────────────────────────────────────────────────

log() {
local msg=”[$(date ‘+%Y-%m-%d %H:%M:%S’)] $*”
echo “$msg”
echo “$msg” >> “$LOG_FILE” 2>/dev/null || true
}

# ── Backup ───────────────────────────────────────────────────────────────────

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME=“backup_${TIMESTAMP}”
BACKUP_PATH=”${DEST}/${BACKUP_NAME}”
LATEST=”${DEST}/latest”

log “Starting backup: ${SOURCE} → ${BACKUP_PATH}”

# Use –link-dest for incremental (hardlinks = no duplicate data)

LINK_DEST=””
[[ -L “$LATEST” && -d “$LATEST” ]] && LINK_DEST=”–link-dest=${LATEST}”

rsync -av   
–progress   
–delete   
–exclude=’*.tmp’   
–exclude=’*.log’   
–exclude=’.DS_Store’   
–exclude=‘node_modules/’   
–exclude=’**pycache**/’   
$LINK_DEST   
“${SOURCE}/”   
“${BACKUP_PATH}/”

# Update symlink to latest

ln -sfn “${BACKUP_PATH}” “${LATEST}”
log “Updated ‘latest’ symlink → ${BACKUP_PATH}”

# ── Rotation ─────────────────────────────────────────────────────────────────

log “Rotating: keeping last ${KEEP} backups”

BACKUP_COUNT=$(find “$DEST” -maxdepth 1 -name ‘backup_*’ -type d | wc -l)
if (( BACKUP_COUNT > KEEP )); then
TO_DELETE=$(find “$DEST” -maxdepth 1 -name ’backup_*’ -type d   
| sort | head -n $(( BACKUP_COUNT - KEEP )))
while IFS= read -r dir; do
log “Removing old backup: $dir”
rm -rf “$dir”
done <<< “$TO_DELETE”
fi

# ── Summary ──────────────────────────────────────────────────────────────────

SIZE=$(du -sh “${BACKUP_PATH}” 2>/dev/null | cut -f1)
log “Done. Size: ${SIZE} | Backups kept: $(find “$DEST” -maxdepth 1 -name ‘backup_*’ -type d | wc -l)”
