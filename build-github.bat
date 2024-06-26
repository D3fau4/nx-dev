@echo off
docker build --no-cache -t ghcr.io/d3fau4/nx-dev .
docker push ghcr.io/d3fau4/nx-dev