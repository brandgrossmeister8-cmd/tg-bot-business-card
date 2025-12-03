-- Создаём политики для разрешения INSERT операций от анонимных пользователей
-- (через anon ключ, который использует бот)

-- Политика для таблицы users
CREATE POLICY "Allow anonymous insert on users"
ON users
FOR INSERT
TO anon
WITH CHECK (true);

-- Политика для таблицы quiz_results
CREATE POLICY "Allow anonymous insert on quiz_results"
ON quiz_results
FOR INSERT
TO anon
WITH CHECK (true);

-- Политика для таблицы booking_requests
CREATE POLICY "Allow anonymous insert on booking_requests"
ON booking_requests
FOR INSERT
TO anon
WITH CHECK (true);

-- Также добавим политики для UPDATE (для обновления last_interaction в users)
CREATE POLICY "Allow anonymous update on users"
ON users
FOR UPDATE
TO anon
USING (true)
WITH CHECK (true);
