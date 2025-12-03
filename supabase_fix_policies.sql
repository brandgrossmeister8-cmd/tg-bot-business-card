-- Сначала удаляем все существующие политики (если есть)
DROP POLICY IF EXISTS "Allow anonymous insert on users" ON users;
DROP POLICY IF EXISTS "Allow anonymous update on users" ON users;
DROP POLICY IF EXISTS "Allow anonymous insert on quiz_results" ON quiz_results;
DROP POLICY IF EXISTS "Allow anonymous insert on booking_requests" ON booking_requests;

-- Включаем RLS для всех таблиц
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE booking_requests ENABLE ROW LEVEL SECURITY;

-- Создаём политики для полного доступа (INSERT, SELECT, UPDATE, DELETE) для всех
CREATE POLICY "Enable all for all users" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for all quiz_results" ON quiz_results FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Enable all for all booking_requests" ON booking_requests FOR ALL USING (true) WITH CHECK (true);
