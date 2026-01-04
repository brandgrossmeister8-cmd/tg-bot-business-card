-- Схема базы данных для Telegram бота-визитки
-- Выполните этот скрипт в SQL Editor вашего Supabase проекта

-- Таблица пользователей
CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  first_name TEXT NOT NULL,
  username TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_interaction TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE
);

-- Таблица результатов квизов
CREATE TABLE quiz_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  question_1 TEXT,
  question_2 TEXT,
  question_3 TEXT,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица заявок на диагностику
CREATE TABLE booking_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  quiz_result_id UUID REFERENCES quiz_results(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  status TEXT DEFAULT 'new'
);

-- Индексы для быстрого поиска
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_quiz_results_user_id ON quiz_results(user_id);
CREATE INDEX idx_booking_requests_user_id ON booking_requests(user_id);
CREATE INDEX idx_booking_requests_status ON booking_requests(status);

-- Таблица для хранения всех сообщений (для обратной связи)
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL,
  message_type TEXT NOT NULL CHECK (message_type IN ('user', 'admin')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_read BOOLEAN DEFAULT FALSE
);

-- Индексы для таблицы messages
CREATE INDEX idx_messages_user_id ON messages(user_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX idx_messages_is_read ON messages(is_read);

-- Комментарии к таблицам
COMMENT ON TABLE users IS 'Информация о пользователях бота';
COMMENT ON TABLE quiz_results IS 'Результаты прохождения квизов';
COMMENT ON TABLE booking_requests IS 'Заявки на диагностику от пользователей';
COMMENT ON TABLE messages IS 'Все сообщения от пользователей и ответы админа для обратной связи';

-- ==================== ПОЛИТИКИ БЕЗОПАСНОСТИ ====================
-- Row Level Security (RLS) - защита данных
-- Только бот (через ANON KEY) может записывать данные
-- Только вы (владелец Supabase) можете просматривать данные через Dashboard

-- Включаем RLS для всех таблиц
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Политика для таблицы users: бот может вставлять и обновлять
CREATE POLICY "Бот может управлять пользователями" ON users
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

-- Политика для таблицы quiz_results: бот может вставлять
CREATE POLICY "Бот может сохранять результаты квизов" ON quiz_results
  FOR INSERT
  WITH CHECK (auth.role() = 'anon');

-- Политика для таблицы booking_requests: бот может вставлять
CREATE POLICY "Бот может создавать заявки" ON booking_requests
  FOR INSERT
  WITH CHECK (auth.role() = 'anon');

-- Политика для таблицы messages: бот может вставлять и читать
CREATE POLICY "Бот может управлять сообщениями" ON messages
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');
