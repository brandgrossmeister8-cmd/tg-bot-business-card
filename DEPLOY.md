# Инструкция по развертыванию бота на сервере

## Что уже сделано ✅

1. ✅ Код бота обновлен с функционалом обратной связи
2. ✅ База данных создана в Supabase (https://rita-supabase.tw1.ru)
3. ✅ Политики безопасности настроены
4. ✅ Файл .env настроен локально

---

## Шаг 1: Остановите бота на текущем сервере

**ВАЖНО:** Сначала остановите старый экземпляр бота, иначе Telegram не позволит запустить новый.

Подключитесь к серверу по SSH и выполните:

```bash
# Проверьте, запущен ли бот через PM2
pm2 list

# Остановите бота
pm2 stop marketing-bot

# Или удалите полностью
pm2 delete marketing-bot
```

---

## Шаг 2: Подготовка файлов для деплоя

### Вариант А: Через Git (рекомендуется)

Если у вас есть Git репозиторий:

```bash
# На локальной машине
git add .
git commit -m "Добавлен функционал обратной связи и подключение к Supabase"
git push origin main
```

### Вариант Б: Через SCP (прямая загрузка)

Если нет Git, загрузите файлы напрямую:

```bash
# На локальной машине (замените user@server на ваши данные)
scp -r /Users/Rita/Documents/Vibecoding/2_TG_bot_my_assistent user@your-server:/path/to/bot/
```

---

## Шаг 3: Настройка на сервере

Подключитесь к серверу через SSH:

```bash
ssh user@your-server
```

### 3.1. Проверка и установка Node.js

```bash
# Проверьте версию Node.js
node --version

# Если Node.js не установлен или версия < 18:
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 3.2. Установка PM2 (если не установлен)

```bash
# Установите PM2 глобально
sudo npm install -g pm2

# Проверьте установку
pm2 --version
```

### 3.3. Переход в директорию проекта

```bash
# Перейдите в директорию с ботом
cd /path/to/bot

# Или если загружали через Git:
git clone <ваш-репозиторий>
cd 2_TG_bot_my_assistent
```

### 3.4. Установка зависимостей

```bash
npm install
```

### 3.5. Создание .env файла на сервере

```bash
# Создайте .env файл
nano .env
```

Вставьте следующее содержимое:

```
# Telegram Bot Token
TELEGRAM_BOT_TOKEN=8531117052:AAEUgOO3m9YiTm_t-Dt9SM47hFksDGTmhIQ

# Supabase Configuration (ваш сервер)
SUPABASE_URL=https://rita-supabase.tw1.ru
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNjA5NDU5MjAwLCJleHAiOjI1MjQ2MDgwMDB9.D_JcDEM7eo2s0PDguXXpVg7ZsB37b7QXqcV6jBMYLu0

# Admin Telegram ID (для получения уведомлений)
ADMIN_CHAT_ID=711863588
```

Сохраните файл: `Ctrl+X` → `Y` → `Enter`

### 3.6. Проверка файлов изображений

```bash
# Убедитесь, что папка images существует и содержит файлы
ls -la images/

# Должны быть файлы:
# - photo_5440443823147844586_y.jpg
# - foto5.png
```

Если изображений нет, загрузите их:

```bash
# На локальной машине
scp images/* user@your-server:/path/to/bot/images/
```

---

## Шаг 4: Запуск бота

### 4.1. Запустите бота через PM2

```bash
pm2 start bot.js --name marketing-bot
```

### 4.2. Проверьте статус

```bash
# Проверьте, что бот запущен
pm2 status

# Посмотрите логи
pm2 logs marketing-bot --lines 50
```

Вы должны увидеть: `✅ Бот запущен и готов к работе!`

### 4.3. Настройте автозапуск

```bash
# Настройте автозапуск при перезагрузке сервера
pm2 startup

# Выполните команду, которую выдаст PM2 (начинается с sudo)
# Например: sudo env PATH=...

# Сохраните текущий список процессов
pm2 save
```

---

## Шаг 5: Тестирование

1. **Откройте Telegram** и найдите вашего бота
2. **Отправьте команду** `/start`
3. **Проверьте функционал:**
   - Квиз работает
   - Заявка на диагностику сохраняется
   - Вы получаете уведомление о новых сообщениях (в вашем личном чате с ботом)

4. **Проверьте базу данных:**
   - Зайдите в Supabase: https://rita-supabase.tw1.ru
   - Откройте раздел **Table Editor**
   - Убедитесь, что данные записываются в таблицы `users`, `messages`, `booking_requests`

---

## Полезные команды PM2

```bash
# Статус всех процессов
pm2 status

# Логи бота (в реальном времени)
pm2 logs marketing-bot

# Перезапустить бота
pm2 restart marketing-bot

# Остановить бота
pm2 stop marketing-bot

# Удалить бота из PM2
pm2 delete marketing-bot

# Мониторинг ресурсов
pm2 monit
```

---

## Обратная связь с клиентами

### Как это работает:

1. **Клиент пишет боту** любое сообщение
2. **Вы получаете уведомление** в Telegram с ID пользователя и текстом сообщения
3. **Чтобы ответить клиенту:**
   ```
   /reply <user_id> ваш текст ответа
   ```
   Например: `/reply 123456789 Спасибо за обращение! Свяжусь с вами сегодня.`

4. **Все сообщения сохраняются** в таблице `messages` в Supabase

### Просмотр сообщений в Supabase:

1. Откройте Supabase: https://rita-supabase.tw1.ru
2. Перейдите в **Table Editor** → **messages**
3. Увидите все сообщения с фильтром по:
   - `user_id` - кто написал
   - `message_type` - `user` (от клиента) или `admin` (ваш ответ)
   - `created_at` - дата и время
   - `is_read` - прочитано или нет

---

## Troubleshooting (Решение проблем)

### Бот не запускается

```bash
# Проверьте логи
pm2 logs marketing-bot --lines 100

# Проверьте .env файл
cat .env

# Проверьте, что все зависимости установлены
npm install
```

### Ошибка "409 Conflict"

Означает, что бот уже запущен где-то еще:

```bash
# Найдите все процессы node
ps aux | grep node

# Убейте нужный процесс
kill -9 <PID>

# Или остановите все PM2 процессы
pm2 stop all
pm2 delete all
```

### Данные не сохраняются в Supabase

Проверьте:
1. Правильность SUPABASE_URL и SUPABASE_KEY в .env
2. Политики безопасности (RLS) настроены
3. Логи бота: `pm2 logs marketing-bot`

---

## Контакты для поддержки

Если возникли проблемы, проверьте логи бота: `pm2 logs marketing-bot`
