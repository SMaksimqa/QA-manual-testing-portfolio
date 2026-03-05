Создание /удаление пользователей + аудит безопасности 
#!/bin/bash

# user_manager.sh — Create, delete, and audit system users

# Usage: ./user_manager.sh [create|delete|list|audit] [username]

# Requires: root or sudo

set -euo pipefail

[[ $EUID -ne 0 ]] && { echo “Run as root: sudo $0 $*”; exit 1; }

BOLD=’\033[1m’; GREEN=’\033[0;32m’; RED=’\033[0;31m’
YELLOW=’\033[1;33m’; RESET=’\033[0m’

log()  { echo -e “${GREEN}✓${RESET} $*”; }
warn() { echo -e “${YELLOW}⚠${RESET}  $*”; }
err()  { echo -e “${RED}✗${RESET} $*”; exit 1; }

# ── Create user ───────────────────────────────────────────────────────────────

cmd_create() {
local username=”${1:-}”
[[ -z “$username” ]] && { echo “Usage: $0 create <username>”; exit 1; }
id "$username" &>/dev/null && err "User '$username' already exists"

# Create user with home directory and bash shell
useradd -m -s /bin/bash "$username"
log "Created user: $username"

# Generate a random password
local password
password=$(openssl rand -base64 12)
echo "$username:$password" | chpasswd
log "Password set (show once): ${BOLD}${password}${RESET}"

# Force password change on first login
chage -d 0 "$username"
log "Password change required on first login"

# Create SSH dir with correct permissions
local ssh_dir="/home/${username}/.ssh"
mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"
touch "${ssh_dir}/authorized_keys"
chmod 600 "${ssh_dir}/authorized_keys"
chown -R "${username}:${username}" "$ssh_dir"
log "SSH directory created"

echo -e "\n${BOLD}User '${username}' is ready.${RESET}"
echo "  To add sudo: usermod -aG sudo ${username}"
echo "  To add SSH key: echo '<pubkey>' >> ${ssh_dir}/authorized_keys"

}

# ── Delete user ───────────────────────────────────────────────────────────────

cmd_delete() {
local username=”${1:-}”
[[ -z “$username” ]] && { echo “Usage: $0 delete <username>”; exit 1; }
[[ “$username” == “root” ]] && err “Refusing to delete root”
id "$username" &>/dev/null || err "User '$username' not found"

read -r -p "Delete user '$username' and home directory? [y/N] " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && { echo "Aborted."; exit 0; }

# Kill all user processes
pkill -u "$username" 2>/dev/null && warn "Killed running processes for $username" || true

userdel -r "$username" 2>/dev/null && log "Deleted user and home: $username" \
    || { userdel "$username"; warn "Home directory may remain"; }

}

# ── List users ────────────────────────────────────────────────────────────────

cmd_list() {
echo -e “${BOLD}System Users (UID 1000+):${RESET}”
echo “”
printf “  %-15s %-6s %-20s %s\n” “USERNAME” “UID” “HOME” “SHELL”
printf “  %-15s %-6s %-20s %s\n” “––––” “—” “––” “—–”
awk -F: ‘$3 >= 1000 && $3 != 65534 {printf “  %-15s %-6s %-20s %s\n”, $1, $3, $6, $7}’ /etc/passwd
echo -e "\n${BOLD}Users with sudo access:${RESET}"
grep -Po '^sudo.+:\K.*$' /etc/group | tr ',' '\n' | sed 's/^/  /'

}

# ── Audit ─────────────────────────────────────────────────────────────────────

cmd_audit() {
echo -e “${BOLD}Security Audit${RESET}\n”
echo -e "${BOLD}Users with empty passwords:${RESET}"
awk -F: '($2 == "" || $2 == "!") {print "  " $1}' /etc/shadow 2>/dev/null \
    || echo "  (requires root)"

echo -e "\n${BOLD}Users with UID 0 (root-equivalent):${RESET}"
awk -F: '$3 == 0 {print "  " $1}' /etc/passwd

echo -e "\n${BOLD}Accounts with no expiry set:${RESET}"
awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd | while read -r user; do
    expiry=$(chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d: -f2 | xargs)
    [[ "$expiry" == "never" ]] && echo "  $user (password never expires)"
done

echo -e "\n${BOLD}Last logins:${RESET}"
lastlog 2>/dev/null | awk 'NR>1 && $2 != "**Never" {print "  " $0}' | head -10

}

# ── Dispatch ──────────────────────────────────────────────────────────────────

COMMAND=”${1:-}”
case “$COMMAND” in
create) cmd_create “${2:-}” ;;
delete) cmd_delete “${2:-}” ;;
list)   cmd_list ;;
audit)  cmd_audit ;;
*)
echo -e “${BOLD}user_manager.sh${RESET} — user management utility”
echo “”
echo “Usage: $0 <command> [username]”
echo “”
echo “Commands:”
echo “  create <username>  — create user with SSH dir and temp password”
echo “  delete <username>  — remove user and home directory”
echo “  list               — show all non-system users”
echo “  audit              — security check (empty passwords, UID 0, expiry)”
;;
esac
