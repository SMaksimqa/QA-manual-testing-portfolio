Кастомный шелл с алиасами функциями 
# ~/.bashrc — Custom shell configuration
# Copy to home: cp .bashrc ~/.bashrc && source ~/.bashrc

# ── History ──────────────────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups     # no duplicate entries
HISTTIMEFORMAT="%Y-%m-%d %H:%M  "   # timestamp in history
shopt -s histappend                   # append, don't overwrite

# ── Shell options ─────────────────────────────────────────────────────────────
shopt -s checkwinsize    # update LINES/COLUMNS after each command
shopt -s cdspell         # auto-fix minor typos in cd
shopt -s dirspell        # autocorrect dir spelling in completion
set -o noclobber         # prevent > from overwriting files (use >| to force)

# ── Prompt ────────────────────────────────────────────────────────────────────
# Show: user@host:path (git branch) $
git_branch() {
    git branch 2>/dev/null | grep '^\*' | sed 's/\* //'
}

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(
    b=$(git_branch); [[ -n "$b" ]] && echo " ($b)"
)\[\033[00m\]\$ '

# ── Navigation ───────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Smarter ls
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -lah'
alias l='ls -CF'

# ── File operations ───────────────────────────────────────────────────────────
alias cp='cp -iv'          # confirm overwrite, verbose
alias mv='mv -iv'          # confirm overwrite, verbose
alias rm='rm -Iv'          # safer rm (interactive if >3 files)
alias mkdir='mkdir -pv'    # create parents, verbose

# Quick file search
alias ff='find . -type f -name'      # ff "*.log"
alias fd='find . -type d -name'      # fd "cache"

# ── System ────────────────────────────────────────────────────────────────────
alias df='df -hT'
alias du='du -h --max-depth=1'
alias free='free -mh'
alias top='htop 2>/dev/null || top'

# Ports & network
alias ports='ss -tulanp'
alias myip='curl -s ifconfig.me && echo'
alias localip='hostname -I | awk "{print \$1}"'
alias ping='ping -c 5'

# Services
alias sstart='sudo systemctl start'
alias sstop='sudo systemctl stop'
alias srestart='sudo systemctl restart'
alias sstatus='sudo systemctl status'
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'
alias slog='sudo journalctl -u'        # slog nginx -f

# ── Development ───────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'

alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv && source venv/bin/activate'

alias dk='docker'
alias dkps='docker ps'
alias dkimg='docker images'
alias dklog='docker logs -f'

# ── Useful functions ──────────────────────────────────────────────────────────

# Extract any archive
extract() {
    [[ ! -f "$1" ]] && { echo "File not found: $1"; return 1; }
    case "$1" in
        *.tar.bz2)  tar xjf "$1" ;;
        *.tar.gz)   tar xzf "$1" ;;
        *.tar.xz)   tar xJf "$1" ;;
        *.tar)      tar xf  "$1" ;;
        *.bz2)      bunzip2  "$1" ;;
        *.gz)       gunzip   "$1" ;;
        *.zip)      unzip    "$1" ;;
        *.7z)       7z x     "$1" ;;
        *.rar)      unrar x  "$1" ;;
        *)          echo "Unknown archive format: $1" ;;
    esac
}

# Quick backup of a file (adds .bak timestamp)
bak() {
    cp -v "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

# Show disk usage of top N items in current dir
dusort() {
    du -ah --max-depth=1 | sort -rh | head -"${1:-10}"
}

# Search running processes
psg() {
    ps aux | grep -v grep | grep -i "$1"
}

# Watch a log file with color
wlog() {
    tail -f "${1:-/var/log/syslog}" | ccze -A 2>/dev/null || tail -f "${1:-/var/log/syslog}"
}

# SSH with port forwarding shortcut
# Usage: tunnel 8080 remote-host 3000
tunnel() {
    ssh -N -L "${1}:localhost:${3}" "${2}"
}

# Create dir and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1" || return
}

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR='nano'
export VISUAL='nano'

# ── Path additions ────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── Load local overrides ──────────────────────────────────────────────────────
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

