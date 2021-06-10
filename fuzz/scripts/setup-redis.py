#!/usr/bin/env python3
import os
import subprocess
#export REDIS_URL=redis://localhost:9000

p = subprocess.Popen(["tmux", "ls"], stdout=subprocess.PIPE)
out, err = p.communicate()
if "ssh-tunneling" in out.decode("utf-8"):
    print("ssh-tunneling already exists")
    exit()

print("This script makes ssh-tunneling between your redis-server and this machine.")

host = input("redis-server HOST : ")
sshport = input("redis-server SSH PORT : ")
port = input("redis-server REDIS PORT : ")
login = input("redis-server USER ID : ")

os.system(f"tmux new-session -s ssh-tunneling -d 'ssh -L 9000:{host}:{port} {login}@{host} -p {sshport}'")
