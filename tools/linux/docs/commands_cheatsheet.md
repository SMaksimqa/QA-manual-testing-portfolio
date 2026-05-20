# Linux Commands Cheatsheet

Commands I use regularly for QA work — checking server state, reading logs, navigating files on remote machines.

---

## Navigation & Files
```bash
pwd                          # current directory
ls -la                       # list with hidden files and details
cd /var/log                  # change directory
cd -                         # go back to previous directory

cat file.txt                 # show file contents
tail -n 50 file.log          # last 50 lines
tail -f app.log              # follow log in real time
head -n 20 file.txt          # first 20 lines

grep "ERROR" app.log         # search lines with "ERROR"
grep -i "error" app.log      # case-insensitive search
grep -r "TODO" .             # recursive search in current folder

---

## Processes and resources
ps aux                       # all running processes
ps aux | grep python         # filter by name
top                          # interactive process viewer
htop                         # nicer alternative (often pre-installed)
kill 1234                    # stop process by PID
kill -9 1234                 # force kill

df -h                        # disk usage per filesystem
free -h                      # RAM and swap usage
uptime                       # how long system is running + load
---
## Networking 

ping -c 4 google.com         # 4 pings to check connectivity
curl https://api.example.com # send HTTP GET request
curl -I https://example.com  # only response headers
ss -tulnp                    # see open ports and what's listening
---
## Services and logs

systemctl status nginx        # check service status
systemctl restart nginx       # restart service
journalctl -u nginx           # logs for a specific service
journalctl -u nginx -f        # follow service logs live
---

## Permissions 

chmod +x script.sh           # make script executable
chmod 755 file               # rwx for owner, rx for others
sudo command                 # run as root
---

## Docker 

docker ps                              # list running containers
docker ps -a                           # all containers (including stopped)
docker logs morning-bot                # see container logs
docker logs -f morning-bot             # follow logs in real time
docker exec -it morning-bot bash       # enter running container
docker compose up -d                   # start services in background
docker compose down                    # stop services
docker compose logs --tail 50          # last 50 lines of compose logs
docker compose restart                 # restart services
docker compose ps                      # status of compose services
---
## SSH

ssh user@server.com                    # connect to remote server
ssh -p 2222 user@server.com            # connect on custom port
scp file.txt user@server.com:/path/    # copy file to remote
scp user@server.com:/path/file.txt .   # copy file from remote


