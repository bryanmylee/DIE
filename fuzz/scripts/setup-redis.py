#!/usr/bin/env python3
import argparse
import os
import subprocess
#export REDIS_URL=redis://localhost:9000

print("This script makes ssh-tunneling between your redis-server and this machine.")

def parse_args():
    p = argparse.ArgumentParser()
    p.add_argument('master_host')
    p.add_argument('master_ssh_port')
    p.add_argument('master_redis_port')
    p.add_argument('master_user_id')
    p.add_argument('--redis_port')
    return p.parse_args()

args = parse_args()

p = subprocess.Popen(["tmux", "ls"], stdout=subprocess.PIPE)
out, err = p.communicate()
tunnel_name = f"ssh-tunnelling-{args.master_redis_port}"
if tunnel_name in out.decode("utf-8"):
    print(f"{tunnel_name} already exists")
    exit()

tunnel_cmd = f"'ssh -o \"StrictHostKeyChecking no\" -L {args.redis_port}:{args.master_host}:{args.master_redis_port} {args.master_user_id}@{args.master_host} -p {args.master_ssh_port}'";
os.system(f"tmux new-session -s ssh-tunneling -d {tunnel_cmd}")
