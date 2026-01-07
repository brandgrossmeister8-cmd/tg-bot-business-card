-- ==================== ОБЩАЯ ТАБЛИЦА ДЛЯ ВСЕХ ПРОЕКТОВ ====================
-- ВАЖНО: Выполните этот скрипт ОДИН РАЗ перед созданием таблиц для проектов
-- Таблица users будет общей для всех ваших ботов и приложений

-- Таблица пользователей (ОБЩАЯ для всех проектов)
CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY,
  first_name TEXT NOT NULL,
  username TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_interaction TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE,

  -- Дополнительные поля для расширения
  last_name TEXT,
  phone TEXT,
  email TEXT,
  metadata JSONB DEFAULT '{}'::jsonb  -- Для хранения дополнительных данных
);

-- Индексы для быстрого поиска
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);

-- Комментарии
COMMENT ON TABLE users IS 'Общая таблица пользователей для всех ботов и приложений';

-- Включаем Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Политика: все приложения (через anon key) могут управлять пользователями
CREATE POLICY "Приложения могут управлять пользователями" ON users
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

-- ==================== ГОТОВО ====================
-- После выполнения этого скрипта таблица users будет доступна всем проектам
