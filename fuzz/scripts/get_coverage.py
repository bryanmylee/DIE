#!/bin/python3
import redis

if __name__ == "__main__":
    r = redis.Redis(host="localhost", port=9000)
    paths = r.smembers("pathBitmap")

    hit_count = len(paths)
    total_count = max((int(path.decode("utf-8")) for path in paths))
    print(f"{total_count} paths")
    print(f"coverage: {hit_count / total_count}")
