#!/usr/bin/env python3

import json
import os
import argparse
import redis
from functools import reduce

def accum_ints_on_key(dicts, key):
    return reduce(lambda a,b: int(a) + int(b), (d[key] for d in dicts))

def accum_floats_on_key(dicts, key):
    return reduce(lambda a,b: float(a) + float(b), (d[key] for d in dicts))

FUZZERS_KEY = 'fuzzers'

if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('out_dir')
    out_dir = os.path.abspath(p.parse_args().out_dir)
    print(f'saving stats to {out_dir}')
    if not os.path.isdir(out_dir):
        os.makedirs(out_dir)

    r = redis.Redis(host='localhost', port=9000)

    fuzzers = r.smembers(FUZZERS_KEY)
    fuzzer_ids = (f"{FUZZERS_KEY}:{b.decode('utf-8')}" for b in r.smembers(FUZZERS_KEY))
    
    fuzzers_data = []
    for i, fuzzer_id in enumerate(fuzzer_ids):
        fuzzer_data_raw = r.get(fuzzer_id).decode('utf-8')
        with open(f'{out_dir}/fuzzer-{i}.txt', 'w') as f:
            f.write(fuzzer_data_raw)

        data_lines = fuzzer_data_raw.split('\n')
        data_entries = (l.split(':') for l in data_lines)
        fuzzer_data = {kv[0].strip():kv[1].strip() for kv in data_entries if len(kv) == 2}
        fuzzers_data.append(fuzzer_data)

    data = {
        'total_execs': accum_ints_on_key(fuzzers_data, 'execs_done'),
        'execs_per_sec': accum_floats_on_key(fuzzers_data, 'execs_per_sec'),
        'unique_crashes': accum_ints_on_key(fuzzers_data, 'unique_crashes'),
        'unique_hangs': accum_ints_on_key(fuzzers_data, 'unique_hangs'),
    }
    
    with open(f'{out_dir}/fuzzers.txt', 'w') as f:
        for k, v in data.items():
            f.write(f'{k}\t: {v}\n')
