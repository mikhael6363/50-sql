/* выбрать одного юзера с самым длинным именем

 В этом варианте выберет не с максимально
 */
SELECT char_length(concat("firstName", ' ', "lastName")) AS "fn_length",
  *
FROM users
ORDER BY "fn_length" DESC
LIMIT 1;
/*
 1.1. Посчитать кол-во юзеров с одним кол-вом символов в Fullname.
 1.2. Отсеять группы юзеров с кол-вом символов меньше 18.

 Например:
 15 пользователей с длиной имени = 18.
 и т.д.
 */
SELECT char_length(concat("firstName", ' ', "lastName")) AS "Fullname lenght",
  count(concat("firstName", ' ', "lastName")) AS "Number of users"
FROM users
GROUP BY "Fullname lenght"
HAVING char_length(concat("firstName", ' ', "lastName")) >= 18
ORDER BY "Fullname lenght" DESC;
/* Вариант #2 (с подзапросом) */
/*
 SELECT "FN".*
 FROM (
 SELECT char_length(concat("firstName", ' ', "lastName")) AS "fn_length",
 count(concat("firstName", ' ', "lastName")) AS "Number of users "
 FROM users
 GROUP BY "fn_length"
 ORDER BY "fn_length" DESC
 ) AS "FN"
 HAVING "fn_length" < 18;
 */
/*
 1.1. Найти кол-во сиволов в имейлах
 1.2. Начинающихся с буквы "w"
 1.3. Сгруппировать их по количеству
 1.4. Отсеять группы у к-х количество символов в имейлах меньше 22.

 2. Отсеять группы, к-е не популярны -> HAVING count(email) > 5
 */
SELECT char_length(email) AS "Email length",
  count(email) AS "Number of emails"
FROM users
WHERE email ILIKE 'm%'
GROUP BY "Email length"
HAVING char_length(email) >= 22
ORDER BY "Email length" DESC;
/* JOIN */
/*
 1. Все id заказов с 'Samsung'
 2. Сколько моделей Samsung было в одном заказе
 */
SELECT o.id AS "Номер заказа",
  count(p.model) AS "Моделей в заказе"
FROM orders AS o
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
  JOIN phones AS p ON p.id = pto."phoneId"
WHERE p.brand ILIKE 'samsung'
GROUP BY "Номер заказа";
/*
 Найти id телефонов, к-е покупают
 */
SELECT "phoneId"
FROM phones_to_orders
GROUP BY "phoneId"
ORDER BY "phoneId";
/*
 1.1. Найти id телефонов, к-е покупали
 1.2. Кол-во проданных телефонов
 */
SELECT "phoneId",
  p.model,
  sum(pto.quantity)
FROM phones_to_orders pto
  JOIN phones p ON p."id" = pto."phoneId"
GROUP BY "phoneId",
  p."model"
ORDER BY "phoneId";
/* Мейлы пользователей к-е делали заказы только Samsung */
SELECT u.email
FROM users u
  JOIN orders o ON u.id = o."userId"
  JOIN phones_to_orders pto ON pto."phoneId" = o.id
  JOIN phones p ON p.id = pto."phoneId"
WHERE p.brand ILIKE 'samsung'
GROUP BY u.email;
/*
 1.1. Пользователи и их кол-во заказов
 1.2. Отсеить польз. к-е сделали меньше 3х заказов
 */
SELECT count(o.id) "Кол-во заказов",
  u.*
FROM users u
  LEFT OUTER JOIN orders o ON u.id = o."userId"
GROUP BY u.id
HAVING count(o.id) >= 3
ORDER BY u.id;
/**/
/**/
/**/
/**/
/**/
/* Стоимость каждого заказа */
SELECT pto."orderId",
  sum(pto.quantity * p.price)
FROM phones_to_orders pto
  JOIN phones p ON pto."phoneId" = p.id
GROUP BY pto."orderId"
ORDER BY pto."orderId";
/* Извлечь все телефоны из конкретного заказа */
SELECT p.brand,
  p.model
FROM phones_to_orders pto
  JOIN phones p ON pto."phoneId" = p.id
WHERE pto."orderId" = 4;
/* Кол-во заказов каждого пользователя и его имейл */
SELECT u.id "ID Пользователя",
  count(o.id) "Кол-во заказов",
  u.email
FROM users u
  JOIN orders o ON u.id = o."userId"
GROUP BY "ID Пользователя"
ORDER BY "ID Пользователя";
/* Кол-во позиций товара в определенном заказе */
SELECT pto."orderId",
  sum(pto.quantity) "Кол-во товаров"
FROM phones_to_orders pto
GROUP BY pto."orderId"
ORDER BY pto."orderId";
/*
 Извлечь самый популярный телефон (по количеству заказов)
 1.1 Сколько раз заказывали каждый телефон
 1.2 Выбрать самый популярный
 */
SELECT p.id "ID телефона",
  concat(p.brand, ' ', p.model) "Модель телефона",
  sum(pto.quantity) "Кол-во заказов"
FROM phones_to_orders pto
  JOIN phones p ON pto."phoneId" = p.id
GROUP BY p.id,
  "Модель телефона"
ORDER BY "Кол-во заказов" DESC
LIMIT 1 OFFSET 0;