#!/bin/bash

# Найти PID активного аудиопроцесса
PID=$(wpctl status | grep "RUNNING" | awk '{print $NF}' | tr -d ']')

# Проверить, нашли ли мы PID
if [[ -z "$PID" ]]; then
    echo "🔇 Нет воспроизведения"
    exit 0
fi

# Найти заголовок окна по PID
WINDOW_TITLE=$(xdotool search --pid "$PID" getwindowname 2>/dev/null | head -n 1)

# Если не нашли заголовок, показать просто имя процесса
if [[ -z "$WINDOW_TITLE" ]]; then
    WINDOW_TITLE=$(ps -p "$PID" -o comm=)
fi

# Вывести результат
echo "🎵 $WINDOW_TITLE"
