#!/bin/bash
docker build -t jsonresponse-app .
sleep 2s
docker run -d -p 8090:8080 jsonresponse-app
