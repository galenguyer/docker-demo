#!/usr/bin/env bash
docker run --name redis --detach --interactive --tty --rm --publish 6379:6379 redis

# This can also be written as
# docker run -n redis -dit --rm -p 6379:6379 redis