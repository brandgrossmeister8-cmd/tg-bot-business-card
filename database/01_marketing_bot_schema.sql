-- ==================== ТАБЛИЦЫ ДЛЯ МАРКЕТИНГОВОГО БОТА ====================
-- ВАЖНО: Перед выполнением этого скрипта убедитесь, что таблица users уже создана
-- (выполните скрипт 00_shared_schema.sql)

-- ==================== ТАБЛИЦЫ ====================

-- Таблица результатов квизов
CREATE TABLE marketing_bot_quiz_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question_1 TEXT,
  question_2 TEXT,
  question_3 TEXT,
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица заявок на диагностику
CREATE TABLE marketing_bot_booking_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  quiz_result_id UUID REFERENCES marketing_bot_quiz_results(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  status TEXT DEFAULT 'новая' CHECK (status IN ('новая', 'в_обработке', 'завершена', 'отменена'))
);

-- Таблица сообщений (для обратной связи)
CREATE TABLE marketing_bot_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL,
  message_type TEXT NOT NULL CHECK (message_type IN ('user', 'admin')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_read BOOLEAN DEFAULT FALSE
);

-- ==================== ИНДЕКСЫ ====================

CREATE INDEX idx_mb_quiz_results_user_id ON marketing_bot_quiz_results(user_id);
CREATE INDEX idx_mb_quiz_results_completed_at ON marketing_bot_quiz_results(completed_at DESC);

CREATE INDEX idx_mb_booking_requests_user_id ON marketing_bot_booking_requests(user_id);
CREATE INDEX idx_mb_booking_requests_status ON marketing_bot_booking_requests(status);
CREATE INDEX idx_mb_booking_requests_created_at ON marketing_bot_booking_requests(created_at DESC);

CREATE INDEX idx_mb_messages_user_id ON marketing_bot_messages(user_id);
CREATE INDEX idx_mb_messages_created_at ON marketing_bot_messages(created_at DESC);
CREATE INDEX idx_mb_messages_is_read ON marketing_bot_messages(is_read);

-- ==================== КОММЕНТАРИИ ====================

COMMENT ON TABLE marketing_bot_quiz_results IS 'Результаты прохождения квизов (маркетинговый бот)';
COMMENT ON TABLE marketing_bot_booking_requests IS 'Заявки на диагностику (маркетинговый бот)';
COMMENT ON TABLE marketing_bot_messages IS 'Сообщения для системы обратной связи (маркетинговый бот)';

-- ==================== ROW LEVEL SECURITY ====================

ALTER TABLE marketing_bot_quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketing_bot_booking_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketing_bot_messages ENABLE ROW LEVEL SECURITY;

-- Политики доступа
CREATE POLICY "Бот может управлять результатами квизов" ON marketing_bot_quiz_results
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

CREATE POLICY "Бот может управлять заявками" ON marketing_bot_booking_requests
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

CREATE POLICY "Бот может управлять сообщениями" ON marketing_bot_messages
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

-- ==================== ГОТОВО ====================
-- Таблицы для маркетингового бота созданы
-- Все таблицы ссылаются на общую таблицу users
