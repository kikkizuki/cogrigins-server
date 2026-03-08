#!/bin/bash
SERVER_DIR="/home/minecraft/Server"
SCREEN_NAME="mc"
LOG_FILE="$SERVER_DIR/restart.log"

# # Очистка логов (сохранение последних 100 строк)
if [ -f "$LOG_FILE" ]; then
    tail -100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
    echo "?? Cleared old log, keeping last 100 lines" >> "$LOG_FILE"
else
    touch "$LOG_FILE"
fi

# Логирование даты начала операции
echo "=== $(date) ===" >> "$LOG_FILE"

# Проверка наличия запущенной сессии screen
if ! screen -list | grep -q "$SCREEN_NAME"; then
    echo "? Screen session '$SCREEN_NAME' not found. Starting fresh..." >> "$LOG_FILE"
    cd "$SERVER_DIR"
    screen -dmS $SCREEN_NAME ./start.sh
    echo "? New server started" >> "$LOG_FILE"
    echo "=== Restart completed ===" >> "$LOG_FILE"
    exit 0
fi

echo "?? Starting graceful restart..." >> "$LOG_FILE"

# ШАГ 1: Предупреждение игроков
screen -S $SCREEN_NAME -X stuff "say [AUTO-RESTART] Server restart in 5 minutes!$(printf \\r)"
echo "?? Notified players: 5 minutes" >> "$LOG_FILE"
sleep 240  # Ожидание 4 минуты

screen -S $SCREEN_NAME -X stuff "say [AUTO-RESTART] Server restart in 1 minute!$(printf \\r)"  
echo "?? Notified players: 1 minute" >> "$LOG_FILE"
sleep 50   # Ожидание 50 секунд

screen -S $SCREEN_NAME -X stuff "say [AUTO-RESTART] Server restarting in 10 seconds!$(printf \\r)"
echo "?? Notified players: 10 seconds" >> "$LOG_FILE"
sleep 10

# ШАГ 2: Сохранение и остановка
screen -S $SCREEN_NAME -X stuff "say [AUTO-RESTART] Saving world...$(printf \\r)"
screen -S $SCREEN_NAME -X stuff "save-all$(printf \\r)"
sleep 5

screen -S $SCREEN_NAME -X stuff "say [AUTO-RESTART] Server stopping...$(printf \\r)"
screen -S $SCREEN_NAME -X stuff "stop$(printf \\r)"
echo "?? Sent stop command" >> "$LOG_FILE"

# ШАГ 3: Цикл ожидания остановки (максимум 30 секунд)
for i in {1..30}; do
    if ! screen -list | grep -q "$SCREEN_NAME"; then
        break
    fi
    sleep 1
done

# ШАГ 4: Если сервер не остановился мягко — принудительное закрытие
if screen -list | grep -q "$SCREEN_NAME"; then
    echo "?? Server didn't stop gracefully, forcing..." >> "$LOG_FILE"
    screen -S $SCREEN_NAME -X quit
    sleep 2
fi

# ШАГ 5: Перезапуск сервера
echo "?? Starting server..." >> "$LOG_FILE"
cd "$SERVER_DIR"
screen -dmS $SCREEN_NAME ./start.sh

# Проверка успешности запуска
sleep 5
if screen -list | grep -q "$SCREEN_NAME"; then
    echo "? Server restarted successfully" >> "$LOG_FILE"
else
    echo "? Failed to restart server" >> "$LOG_FILE"
fi

echo "=== Restart completed ===" >> "$LOG_FILE"

# Удаление логов старше 7 дней (ротация)
find "$SERVER_DIR" -name "restart.log.*" -mtime +7 -delete 2>/dev/null || true