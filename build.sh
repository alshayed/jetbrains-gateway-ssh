#!/usr/bin/env bash
set -e

tar --owner=0 --group=0 -czvf src/add-files.tar.gz -C add-files/ .
docker compose build --no-cache
docker compose up
