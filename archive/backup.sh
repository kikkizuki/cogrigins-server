#!/bin/bash
SERVER_DIR="/home/minecraft/Server"
WORLD_NAME="Cogrigins"
BACKUP_DIR="$SERVER_DIR/backups"
DATE=$(date +%Y-%m-%d_%H-%M)

# Создать папку для бэкапа, если её нет
mkdir -p "$BACKUP_DIR"

# Проверка, существует ли папка мира
if [ ! -d "$SERVER_DIR/$WORLD_NAME" ]; then
    echo "? ����� ���� '$WORLD_NAME' �� ������� �� ����: $SERVER_DIR/$WORLD_NAME"
    exit 1
fi

# Управление сервером через screen (для вывода в mc)
screen -S mc -X stuff "say [BACKUP] Begin saving the world to directory...$(printf \\r)"
screen -S mc -X stuff "save-off$(printf \\r)"
screen -S mc -X stuff "save-all flush$(printf \\r)"
sleep 3

# Создание копии
cp -r "$SERVER_DIR/$WORLD_NAME" "$BACKUP_DIR/$WORLD_NAME-$DATE"

# Предупреждение игроков
screen -S mc -X stuff "save-on$(printf \\r)"
screen -S mc -X stuff "say [BACKUP] Copy done: $WORLD_NAME-$DATE$(printf \\r)"

# # Удаление бэкапов старше 7 дней
find "$BACKUP_DIR" -name "Cogrigins-*" -type d -mtime +7 -exec rm -rf {} \;

echo "? backup saved: $BACKUP_DIR/$WORLD_NAME-$DATE"