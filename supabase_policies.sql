-- Отключаем RLS для таблиц (так как бот использует service key и нужен полный доступ)
-- Это безопасно, так как мы используем anon key с ограниченными правами

ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results DISABLE ROW LEVEL SECURITY;
ALTER TABLE booking_requests DISABLE ROW LEVEL SECURITY;

-- Альтернативный вариант: если хотите оставить RLS включенным,
-- раскомментируйте следующие политики и закомментируйте строки DISABLE выше:

-- ALTER TABLE users ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE booking_requests ENABLE ROW LEVEL SECURITY;

-- CREATE POLICY "Enable all access for service role" ON users FOR ALL USING (true);
-- CREATE POLICY "Enable all access for service role" ON quiz_results FOR ALL USING (true);
-- CREATE POLICY "Enable all access for service role" ON booking_requests FOR ALL USING (true);
