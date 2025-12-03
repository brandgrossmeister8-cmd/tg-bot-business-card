#!/bin/bash

echo "🛑 Останавливаем ВСЕ процессы бота..."

# Убиваем все процессы в несколько итераций
for i in {1..5}; do
  echo "  Итерация $i..."
  pkill -9 -f "node.*bot.js" 2>/dev/null
  pkill -9 node 2>/dev/null
  sleep 2
done

echo "✅ Все процессы остановлены"
echo ""
echo "Проверка оставшихся процессов:"
PROCESSES=$(ps aux | grep "bot.js" | grep -v grep | wc -l)
if [ "$PROCESSES" -gt 0 ]; then
  echo "⚠️  Найдено процессов: $PROCESSES"
  ps aux | grep "bot.js" | grep -v grep
else
  echo "✅ Процессов не найдено"
fi
