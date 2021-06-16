#!/usr/bin/env python3
import argparse
import os
import subprocess
#export REDIS_URL=redis://localhost:9000

p = subprocess.Popen(["tmux", "ls"], stdout=subprocess.PIPE)
out, err = p.communicate()
if "ssh-tunneling" in out.decode("utf-8"):
    print("ssh-tunneling already exists")
    exit()

print("This script makes ssh-tunneling between your redis-server and this machine.")

def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument('master_host')
    p.add_argument('master_ssh_port')
    p.add_argument('master_redis_port')
    p.add_argument('master_user_id')
    return p.parse_args()

args = parse_args()
tunnel_cmd = f"'ssh -L 9000:{args.master_host}:{args.master_redis_port} {args.master_user_id}@{args.master_host} -p {args.master_ssh_port}'";
os.system(f"tmux new-session -s ssh-tunneling -d {tunnel_cmd}")
