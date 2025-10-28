# Задание №1
CREATE DATABASE USERS_ADVERTS;

CREATE TABLE USERS (
	DATE DATE, 
	USER_ID VARCHAR(50), 
	VIEW_ADVERTS INT);

SELECT * FROM USERS;

# 1.1.КОЛ - ВО УНИКАЛЬНЫХ ПОЛЬЗОВАТЕЛЕЙ ЗА ПЕРИОД
SELECT
	COUNT(DISTINCT USER_ID) AS COUNT_USERID
FROM USERS
WHERE DATE BETWEEN '2023-11-07' AND '2023-11-15';

# 1.2.ПОЛЬЗОВАТЕЛЬ С НАИБОЛЬШИМ ЧИСЛОМ VIEW ADVERTS
SELECT
	USER_ID,
	SUM(VIEW_ADVERTS) AS TOTAL_VIEWS
FROM USERS
GROUP BY USER_ID
ORDER BY TOTAL_VIEWS DESC
LIMIT 1;

# 1.3.СРЕДНЕЕ ЧИСЛО ПОКАЗОВ ПО ДНЯМ С БОЛЕЕ 500 ПОЛЬЗОВАТЕЛЯМИ
SELECT
	DATE,
	COUNT(USER_ID) AS ACTIVE_USERS,
	AVG(VIEWS) AS AVG_VIEWS
FROM (SELECT
		DATE,
		USER_ID,
		SUM(VIEW_ADVERTS) AS VIEWS
	FROM USERS
	GROUP BY DATE, USER_ID) AS USER_2
GROUP BY DATE
HAVING COUNT(USER_ID)> 500
ORDER BY AVG_VIEWS DESC;

# 1.4.LT ПОЛЬЗОВАТЕЛЯ
SELECT
	USER_ID,
	DATEDIFF (MAX(DATE), MIN(DATE)) AS LT
FROM USERS
GROUP BY USER_ID
ORDER BY LTDESC;

# 1.5.ПОЛЬЗОВАТЕЛЬ С НАИБОЛЬШИМ СРЕДНИМ VIEWS ЗА ДЕНЬ ПРИ АКТИВНОСТИ БОЛЕЕ 5 ДНЕЙ
SELECT
	USER_ID,
	AVG(SUM_VIEW) AS AVG_VIEW,
	COUNT(*) AS ACTIVE_DAYS
FROM (SELECT
		USER_ID,
		DATE,
		SUM(VIEW_ADVERTS) AS SUM_VIEW
	FROM USERS
	GROUP BY USER_ID, DATE) AS USERS_2
GROUP BY USER_ID
HAVING COUNT(*) > 5 
ORDER BY AVG_VIEW DESC
LIMIT 1;

# Задание №2
create database mini_project;

CREATE TABLE T_TAB1(
	ID INT UNIQUE, -- уникальный идентификатор 
	GOODS_TYPE VARCHAR(50), --  тип проданного товара
	QUANTITY INT, -- количество проданного товара
	AMOUNT INT, --  суммарная стоимость товара
	SELLER_NAME VARCHAR(50) --  имя продавца
);

INSERT INTO T_TAB1 VALUES
(1, 'MOBILE PHONE', 2, 400000, 'MIKE'),
(2, 'KEYBOARD', 1, 10000, 'MIKE'),
(3, 'MOBILE PHONE', 1, 50000, 'JANE'),
(4, 'MONITOR', 1, 110000, 'JOE'),
(5, 'MONITOR', 2, 80000, 'JANE'),
(6, 'MOBILE PHONE', 1, 130000, 'JOE'),
(7, 'MOBILE PHONE', 1, 60000, 'ANNA'),
(8, 'PRINTER', 1, 90000, 'ANNA'),
(9, 'KEYBOARD', 2, 10000, 'ANNA'),
(10, 'PRINTER', 1, 80000, 'MIKE');

select * from t_tab1;
select * from t_tab2;

CREATE TABLE T_TAB2(
ID INT UNIQUE, --  уникальный идентификатор
NAME VARCHAR(50), --  имя сотрудника
SALARY INT, --  зарплата сотрудника
AGE INT); --  возраст сотрудника

INSERT INTO T_TAB2 VALUES 
(1, 'ANNA', 110000, 27),
(2, 'JANE', 80000, 25),
(3, 'MIKE', 120000, 25),
(4, 'JOE', 70000, 24),
(5, 'RITA', 120000, 29);

# 2.1.ЗАПРОС, КОТОРЫЙ ВЕРНЁТ СПИСОК УНИКАЛЬНЫХ КАТЕГОРИЙ ТОВАРОВ
SELECT DISTINCT GOODS_TYPE
FROM T_TAB1;

# КОЛИЧЕСТВО УНИКАЛЬНЫХ КАТЕГОРИЙ
SELECT
	COUNT(DISTINCT GOODS_TYPE) AS COUNT_GOODSTYPE
FROM T_TAB1;
-- Запрос вернул 4 строк

# 2.2.ЗАПРОС, КОТОРЫЙ ВЕРНЁТ СУММАРНОЕ КОЛИЧЕСТВО И СУММАРНУЮ СТОИМОСТЬ ПРОДАННЫХ МОБИЛЬНЫХ ТЕЛЕФОНОВ
SELECT
	GOODS_TYPE,
	SUM(QUANTITY) AS QUANTITY,
	SUM(AMOUNT) AS AMOUNT
FROM T_TAB1
WHERE GOODS_TYPE = 'MOBILE PHONE';

# 2.3.ЗАПРОС, КОТОРЫЙ ВЕРНЁТ СПИСОК СОТРУДНИКОВ С ЗАРПЛАТОЙ > 100000
SELECT
	*
FROM T_TAB2
WHERE SALARY > 100000;

# КОЛИЧЕСТВО ТАКИХ СОТРУДНИКОВ
SELECT
	COUNT(*)
FROM T_TAB2
WHERE SALARY > 100000;
-- Запрос вернул 3 сотрудников

# 2.4. Запрос, который вернёт минимальный и максимальный возраст сотрудников, а также минимальную и максимальную зарплату
SELECT
	MIN(AGE) AS MIN_AGE,
	MAX(AGE) AS MAX_AGE,
	MIN(SALARY) AS MIN_SALARY,
	MAX(SALARY) AS MAX_SALARY
FROM T_TAB2;

# 2.5.СРЕДНЕЕ КОЛИЧЕСТВО ПРОДАННЫХ КЛАВИАТУР И ПРИНТЕРОВ
SELECT
	GOODS_TYPE,
	ROUND(AVG(QUANTITY), 1) AS AVG_QUANTITY
FROM T_TAB1
WHERE GOODS_TYPE IN ('KEYBOARD', 'PRINTER')
GROUP BY GOODS_TYPE;

# 2.6.ИМЯ СОТРУДНИКА И СУММАРНАЯ СТОИМОСТЬ ПРОДАННЫХ ИМ ТОВАРОВ
SELECT
	SELLER_NAME,
	SUM(AMOUNT) AS AMOUNT
FROM T_TAB1
GROUP BY SELLER_NAME;

# 2.7.ИМЯ СОТРУДНИКА,ТИП ТОВАРА, КОЛИЧЕСТВО ТОВАРА, СТОИМОСТЬ ТОВАРА, ЗАРПЛАТА И ВОЗРАСТ СОТРУДНИКА MIKE
SELECT
	T1.SELLER_NAME,
	T1.GOODS_TYPE,
	T1.QUANTITY,
	T1.AMOUNT,
	T2.SALARY,
	T2.AGE
FROM T_TAB1 T1
JOIN T_TAB2 T2 ON T1.SELLER_NAME = T2.NAME
WHERE T1.SELLER_NAME = 'MIKE';

# 2.8.ИМЯ И ВОЗРАСТ СОТРУДНИКА, КОТОРЫЙ НИЧЕГО НЕ ПРОДАЛ
SELECT
	T2.NAME,
	T2.AGE
FROM T_TAB2 T2
LEFT JOIN T_TAB1 T1 ON T2.NAME = T1.SELLER_NAME
WHERE T1.SELLER_NAME IS NULL;

# KОЛИЧЕСТВО ТАКИХ СОТРУДНИКОВ
SELECT
	COUNT(*) AS "Кол-во сотрудников без продаж"
FROM T_TAB2 T2
LEFT JOIN T_TAB1 T1 ON T2.NAME = T1.SELLER_NAME
WHERE T1.SELLER_NAME IS NULL;
-- таких сотрудников 1

# 2.9.ИМЯ СОТРУДНИКА И ЗАРПЛАТА С ВОЗРАСТОМ МЕНЬШЕ 26 ЛЕТ
SELECT
	NAME,
	SALARY
FROM T_TAB2
WHERE AGE <26;

# KОЛИЧЕСТВО СТРОК
SELECT
	COUNT(*) AS COUNT
FROM T_TAB2
WHERE AGE < 26;
-- Запрос вернул 3 строк

# 2.10. Сколько строк вернёт запрос
SELECT * FROM T_TAB1 t
JOIN T_TAB2 t2 ON t2.name = t.seller_name
WHERE t2.name = 'RITA';
-- Запрос вернул 0 строк 

# Задание №3
# 3.1 Пользователи, добавившие и прослушавшие > 10% книгу 'Coraline'
SELECT
	AB1.TITLE,
	COUNT(DISTINCT AS1.USER_ID) AS ADDED_USERS,
	COUNT(DISTINCT L1.USER_ID) AS LISTENED_USERS
FROM AUDIOBOOKS AB1
JOIN (
	SELECT
	AC.USER_ID,
	AC.AUDIOBOOK_UUID
	FROM AUDIO_CARDS AC
	JOIN AUDIOBOOKS AB ON AC.AUDIOBOOK_UUID = AB.UUID
	WHERE AB.TITLE = 'Coraline') 
AS AS1 ON AB1.UUID = AS1.AUDIOBOOK_UUID
JOIN (
	SELECT
	L.USER_ID,
	L.AUDIOBOOK_UUID
	FROM LISTENINGS L
	JOIN AUDIOBOOKS A ON L.AUDIOBOOK_UUID = A.UUID
	WHERE A.TITLE = 'Coraline'
	GROUP BY L.USER_ID, L.AUDIOBOOK_UUID, A.DURATION
	HAVING SUM(POSITION_TO - POSITION_FROM) > 0.1 * A.DURATION) 
AS L1 ON AB1.UUID = L1.AUDIOBOOK_UUID
GROUP BY AB1.TITLE;

# 3.2 По ОС и названию книги: кол-во пользователей и сумма прослушивания в часах без тестовых прослушиваний
SELECT
	L.OS_NAME,
	AB.TITLE,
	COUNT(DISTINCT USER_ID) AS USERS,
	ROUND(SUM(L.POSITION_TO - L.POSITION_FROM) / 3600.0, 1) AS TOTAL_HOURS
FROM LISTENINGS L
JOIN AUDIOBOOKS AB ON L.AUDIOBOOK_UUID = AB.UUID
WHERE L.IS_TEST = 0
GROUP BY L.OS_NAME, AB.TITLE
ORDER BY AB.TITLE, L.OS_NAME;


# 3.3 Книга, которую слушает больше всего людей
SELECT 
	AB.TITLE,
	COUNT(DISTINCT USER_ID) AS LISTENED_USERS
FROM AUDIOBOOKS AB
JOIN AUDIO_CARDS AC ON AB.UUID = AC.AUDIOBOOK_UUID
WHERE AC.STATE = 'listening'
GROUP BY AB.TITLE
ORDER BY LISTENED_USERS DESC 
LIMIT 1;

# 3.4 Книга, которую чаще всего дослушивают до конца
SELECT
	AB.TITLE,
	COUNT(DISTINCT USER_ID) AS FINISHED_USERS
FROM AUDIOBOOKS AB
JOIN AUDIO_CARDS AC ON AB.UUID = AC.AUDIOBOOK_UUID
WHERE AC.STATE = 'finished'
GROUP BY AB.TITLE
ORDER BY FINISHED_USERS DESC 
LIMIT 1;






