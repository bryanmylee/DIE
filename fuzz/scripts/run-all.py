#!/usr/bin/env python3
import argparse
import os
import multiprocessing
from os import environ

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('cmd', nargs='+')
    p.add_argument('--redis_port', type=int)
    default_cpu = max(1, multiprocessing.cpu_count() - 4)
    p.add_argument('--cpu', nargs='?', type=int, default=default_cpu)
    args = p.parse_args()
    cmd = args.cmd
    redis_port = args.redis_port
    cpu = args.cpu
    # Fails if unintended "output" string in command.
    # Use output## as key for output-%d instead.
    for i in range(cpu):
        new_cmd = ' '.join(cmd).replace('output##', 'output-%d' % i)
        os.system(f'tmux new-window -n jsfuzz-{i} "AFL_NO_UI=1 REDIS_URL=redis://localhost:{redis_port} {new_cmd}; /bin/bash"')
