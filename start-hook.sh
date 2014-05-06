#!/bin/bash

cd "$(dirname "$0")"

#
# starts a hookshot server that will `git pull` whenever
# GitHub pings us
#
# See: https://github.com/Coreh/hookshot
#
hookshot -p 9000 "git fetch && git reset --hard origin/generated"
