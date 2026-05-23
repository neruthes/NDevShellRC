#!/bin/bash

target_pid=$1
if [ -z "$target_pid" ]; then
	echo "Usage: memtree <PID>"
	return 1
fi

# 1. Get all recursive PIDs including the parent
# 2. Format them as a regex: (123|124|125)
family_regex=$(pstree -p "$target_pid" | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | paste -sd '|' -)

if [ -z "$family_regex" ]; then
	echo "PID $target_pid not found."
	return 1
fi

# 3. Run smem using the regex filter and show the total
sudo smem -t -k -c "pid user command pss rss" -P "($family_regex)$"


