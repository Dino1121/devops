#!/bin/bash

while true
do
    COUNT=$(docker compose ps --status running -q web | wc -l)

    echo "현재 실행 중인 web 컨테이너: $COUNT개"

    if [ "$COUNT" -ne 3 ]; then
        echo "web 컨테이너 수가 3개가 아닙니다. 복구를 시작합니다."
        docker compose up -d --scale web=3
    fi

    sleep 5
done
