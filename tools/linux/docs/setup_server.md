# Ubuntu 22.04 Server Setup — From Scratch

Step-by-step guide for setting up a production-ready Ubuntu server. Covers security hardening, nginx, and deploying a web app.

-----

## 1. Initial Login & Update
```bash
# Login as root (first time)
ssh root@your-server-ip

# Update everything
apt update && apt upgrade -y

# Set hostname
hostnamectl set-hostname my-server
```
-----

## 2. Create a Non-Root User

Never work as root in production. Create a regular user with sudo.
```bash
adduser deploy
usermod -aG sudo deploy
```
# Test sudo works
```bash
su - deploy
sudo whoami   # should print "root"
```
-----

## 3. SSH Key Authentication

Disable password login — keys only.
```bash
# On your LOCAL machine, generate a key if you don't have one:
ssh-keygen -t ed25519 -C "my-server"

# Copy public key to server:
ssh-copy-id deploy@your-server-ip

# Now test key login:
ssh deploy@your-server-ip
```
Edit /etc/ssh/sshd_config on the server:
```
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```
```bash
# Apply changes
sudo systemctl restart sshd

# Test in a NEW terminal before closing current one!
ssh deploy@your-server-ip
```
-----

## 4. Firewall (UFW)
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow OpenSSH      # SSH (port 22)
sudo ufw allow 80/tcp       # HTTP
sudo ufw allow 443/tcp      # HTTPS

sudo ufw enable
sudo ufw status verbose
```
-----

## 5. Fail2ban (Block Brute Force)
```bash
sudo apt install fail2ban -y

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
Edit /etc/fail2ban/jail.local:
```ini
[DEFAULT]
bantime  = 1h
findtime = 10m
maxretry = 5

[sshd]
enabled = true
port    = ssh
```
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Check status
sudo fail2ban-client status sshd
```
-----

## 6. Install Nginx
```bash
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Test: visit http://your-server-ip — should show nginx welcome page
```
-----

## 7. SSL Certificate (Let’s Encrypt)
```bash
sudo apt install certbot python3-certbot-nginx -y

# Make sure your domain's DNS points to the server first!
sudo certbot --nginx -d example.com -d www.example.com

# Auto-renewal is set up automatically. Test it:
sudo certbot renew --dry-run
```
-----

## 8. Deploy a Node.js App (example)
```bash
# Install Node.js via NodeSource
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
node --version

# Install PM2 (process manager)
sudo npm install -g pm2

# Clone and start your app
cd /var/www
sudo git clone https://github.com/youruser/myapp.git
cd myapp
npm install --production

# Start with PM2
pm2 start app.js --name myapp
pm2 startup                 # generate startup command
pm2 save                    # save process list
```
Configure nginx to proxy to Node.js (see nginx.conf in this repo).

-----

## 9. Basic Monitoring
```bash
# Check what's eating disk space
du -sh /var/log/*  | sort -rh | head -10

# Set up log rotation if needed
sudo nano /etc/logrotate.d/myapp

# Watch live system stats
watch -n 2 'free -mh && echo && df -h'

# Check which ports are listening
ss -tulanp
```
-----

## 10. Useful Commands for Day-to-Day
```bash
# Tail app logs with timestamps
journalctl -u nginx -f --output=short-precise

# Check failed systemd services
systemctl --failed

# Reload nginx config without downtime
sudo nginx -t && sudo systemctl reload nginx

# View active connections to port 443
ss -tnp | grep :443

# Quick CPU/mem snapshot
top -bn1 | head -15
```
-----

## Checklist

- [ ] Non-root user with sudo
- [ ] SSH key login only, root login disabled
- [ ] UFW firewall enabled (only 22, 80, 443)
- [ ] Fail2ban running
- [ ] Unattended-upgrades configured
- [ ] SSL certificate installed and auto-renewing
- [ ] App running under its own system user (not root)
- [ ] Logs being rotated
- [ ] Backups configured (see `backup.sh`)
