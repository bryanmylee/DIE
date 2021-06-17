#!/bin/sh

echo core >/proc/sys/kernel/core_pattern

cd /sys/devices/system/cpu
[ -f cpu0/cpufreq/scaling_governor ] && \
  echo performance | tee cpu*/cpufreq/scaling_governor || \
  true
