#!/usr/bin/env python3

from datetime import datetime
import json
import os
import argparse
import redis

CRASH_KEY = 'crashQueue'

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('--redis_port', type=int)
    p.add_argument('out_dir')
    args = p.parse_args()
    redis_port = args.redis_port
    out_dir = os.path.abspath(args.out_dir)

    print(f'saving crashes to {out_dir} from port {redis_port}')
    if not os.path.isdir(out_dir):
       os.makedirs(out_dir)

    r = redis.Redis(host='localhost', port=redis_port)

    num_crashes = r.llen(CRASH_KEY)
    timestamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    print(f'{num_crashes} crashes at {timestamp}')

    crash_data = r.lrange(CRASH_KEY, 0, num_crashes)

    for i, crash in enumerate(crash_data):
        with open(f'{out_dir}/crash-{timestamp}-{i}.js', 'w') as f:
            obj = json.loads(crash)
            f.write(obj['js'])
