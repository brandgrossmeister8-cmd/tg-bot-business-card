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

-- Комментарии к таблицам
COMMENT ON TABLE users IS 'Информация о пользователях бота';
COMMENT ON TABLE quiz_results IS 'Результаты прохождения квизов';
COMMENT ON TABLE booking_requests IS 'Заявки на диагностику от пользователей';
