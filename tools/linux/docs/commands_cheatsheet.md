# Linux Commands Cheatsheet

Commands I use regularly — organized by task.

-----

## Navigation & Files
```bash
pwd                          # current directory
ls -lah                      # list with hidden files, human sizes
cd -                         # go to previous directory
tree -L 2                    # directory tree, 2 levels deep

find . -name "*.log" -mtime -7        # logs modified in last 7 days
find /var -type f -size +100M         # files larger than 100MB
find . -name "*.py" -exec grep -l "TODO" {} \;  # files containing TODO

grep -r "error" /var/log --include="*.log"       # recursive search
grep -n "def " app.py                            # show line numbers
grep -v "^#" config.conf                         # exclude comments
awk '{print $1, $5}' access.log                  # print columns 1 and 5
sed -i 's/old_text/new_text/g' file.txt          # replace in file
```
-----

## Permissions
```bash
ls -l file.txt               # see permissions: -rwxr-xr-x
chmod 755 script.sh          # rwx for owner, rx for group/others
chmod +x script.sh           # add execute for everyone
chown user:group file.txt    # change owner and group
chown -R user /var/www       # recursive change

# Permission numbers:
# 7 = rwx (read+write+execute)
# 6 = rw-
# 5 = r-x
# 4 = r--
```
-----

## Processes
```bash
ps aux                       # all running processes
ps aux | grep nginx          # filter by name
top                          # interactive process viewer
htop                         # better top (install separately)

kill 1234                    # send SIGTERM (graceful stop)
kill -9 1234                 # send SIGKILL (force stop)
killall nginx                # kill all by name
pkill -f "python app.py"     # kill by full command match

jobs                         # background jobs in current shell
nohup ./script.sh &          # run in background, survives logout
disown %1                    # detach job from shell
```
-----

## System Resources
```bash
df -hT                       # disk usage per filesystem + type
du -sh /var/log              # size of a directory
du -ah --max-depth=1 | sort -rh | head -10  # top 10 largest items

free -mh                     # RAM and swap usage
vmstat 1 5                   # CPU/mem stats every 1s, 5 times

uptime                       # load averages (1, 5, 15 min)
lscpu                        # CPU info
lsblk                        # block devices (disks, partitions)
```
-----

## Networking
```bash
ip addr                      # network interfaces and IPs
ip route                     # routing table
ss -tulanp                   # open ports and what's listening
netstat -tulnp               # same (older systems)

curl -I https://example.com              # HTTP headers only
curl -o file.zip https://example.com/f  # download to file
wget -q https://example.com/file        # quiet download

ping -c 4 8.8.8.8            # 4 ICMP pings to Google DNS
traceroute google.com        # trace network path
nslookup example.com         # DNS lookup
dig example.com A            # detailed DNS query

# Test if port is open:
nc -zv host.com 443          # netcat check
curl -s telnet://host:port   # alternative
```
-----

## Services (systemd)
```bash
systemctl status nginx        # service status
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl reload nginx        # reload config without restart
systemctl enable nginx        # start on boot
systemctl disable nginx

systemctl list-units --type=service --state=running   # all running services

# Logs
journalctl -u nginx           # all logs for a service
journalctl -u nginx -f        # follow (live tail)
journalctl -u nginx --since "1 hour ago"
journalctl -p err             # only error-level logs
```
-----

## Users & Permissions
```bash
whoami                        # current user
id                            # uid, gid, groups
groups username               # groups a user belongs to

sudo su -                     # switch to root
sudo -u www-data bash         # switch to another user

useradd -m -s /bin/bash bob   # create user with home & bash
```
