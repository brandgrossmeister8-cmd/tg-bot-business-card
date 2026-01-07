-- ==================== ШАБЛОН ДЛЯ НОВЫХ ПРОЕКТОВ ====================
-- Скопируйте этот файл и замените 'projectname' на краткое имя вашего проекта
-- Например: ecommerce, crm, analytics, shop и т.д.
-- ВАЖНО: Используйте короткие английские названия без пробелов

-- ==================== ПРИМЕРЫ ТАБЛИЦ ====================

-- Пример таблицы 1: Настройки проекта
CREATE TABLE projectname_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  setting_key TEXT NOT NULL,
  setting_value JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Пример таблицы 2: Активности пользователей
CREATE TABLE projectname_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  activity_type TEXT NOT NULL,
  activity_data JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==================== ИНДЕКСЫ ====================

CREATE INDEX idx_projectname_settings_user_id ON projectname_settings(user_id);
CREATE INDEX idx_projectname_settings_key ON projectname_settings(setting_key);

CREATE INDEX idx_projectname_activities_user_id ON projectname_activities(user_id);
CREATE INDEX idx_projectname_activities_type ON projectname_activities(activity_type);
CREATE INDEX idx_projectname_activities_created_at ON projectname_activities(created_at DESC);

-- ==================== КОММЕНТАРИИ ====================

COMMENT ON TABLE projectname_settings IS 'Пользовательские настройки (проект: НАЗВАНИЕ)';
COMMENT ON TABLE projectname_activities IS 'История активностей пользователей (проект: НАЗВАНИЕ)';

-- ==================== ROW LEVEL SECURITY ====================

ALTER TABLE projectname_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE projectname_activities ENABLE ROW LEVEL SECURITY;

-- Политики доступа (настройте под свои нужды)
CREATE POLICY "Приложение может управлять настройками" ON projectname_settings
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

CREATE POLICY "Приложение может управлять активностями" ON projectname_activities
  FOR ALL
  USING (auth.role() = 'anon')
  WITH CHECK (auth.role() = 'anon');

-- ==================== ИНСТРУКЦИИ ====================
-- 1. Скопируйте этот файл с новым именем (например: 03_ecommerce_schema.sql)
-- 2. Замените все 'projectname' на краткое имя вашего проекта (например: ecommerce, shop, crm)
-- 3. Измените таблицы под свои нужды
-- 4. Выполните скрипт в Supabase SQL Editor
-- 5. Общая таблица users будет доступна автоматически!
--
-- Примеры именования:
-- - marketing_bot_ (уже используется для текущего бота)
-- - ecommerce_ (для интернет-магазина)
-- - crm_ (для CRM системы)
-- - analytics_ (для аналитики)
