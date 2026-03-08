#!/bin/bash
cd ~/Server

AUTO_RESTART=true

while true; do
    if [ "$AUTO_RESTART" = true ]; then
        echo "$(date): Starting Minecraft server..."
        ./start.sh

        EXIT_CODE=$?
        echo "$(date): Server stopped with exit code: $EXIT_CODE"

        # Если сервер остановлен командой stop (нормальный выход)
        if [ $EXIT_CODE -eq 0 ] || [ $EXIT_CODE -eq 130 ]; then
            echo "Server was stopped normally. Exiting."
            break
        else
            echo "Server crashed! Restarting in 10 seconds..."
            sleep 10
        fi
    fi
done
