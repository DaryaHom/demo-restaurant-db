--Запроcы для тестирования БД:
--Показ нарушений
select * from violation_log v ;

--Запрос на изменение скидки после выставления счёта:
update checks set discount_code = 1 where code = 9;

--Представление меню, отсортированное по группам товаров
select * from fullmenu f ;

--Список открытых заказов (по которым не выдан счёт):
select * from open_orders;

--Выручка за 13.08.22 с указанием закрытых заказов, суммой заказов, суммой скидок и платежей:
select * from daily_income;

--Скидки (сумма предоставленных скидок с разбивкой по категориям)
select * from discount_sum;

-- Список сотрудников с указанием должностей
select * from personal_title;

--Рейтинг официанта по выручке:
select * from waiters_rating;

--Посмотреть, кто из официантов на смене 14.08:
select 
	w.waiter_id,
	p.fullname
from waiters w 
	join personal p on w.personal_id = p.personal_id
	join timesheets t on p.personal_id = t.personal_id 
where p.title = 3 and date_trunc('day', t.work_day) = '2022-08-14';

--Создать новый заказ и отследить изменения в таблице заказов: 
insert into orders (order_date, table_number, waiter_id)
values	
	('2022-08-14 15:36:38', 1, 3);

select * from orders o where date_trunc('day', o.order_date) = '2022-08-14';

--Добавить элементы для нового заказа: 
 insert into orders_elements (code, dishes_code, drinks_code, quantity)
values
	(22, 8, null, 2),
	(22, null, 6, 4),
	(22, 14, null, 2),
	(22, 10, null , 3),
	(22, null, 21, 1);

--Показать список заказанных позиций нового заказа:
select 
	oe.code "Номер заказа",
	mg.names "Группа",
	d.names "Название",
	oe.quantity "Количество"
from orders_elements oe 
	join dishes d on oe.dishes_code = d.code 
	join menu_groups mg on mg.code = d.group_code 
where oe.code = 22
union 
select 
	oe.code "Номер заказа",
	mg.names "Группа",
	d2.names "Название",
	oe.quantity "Количество"
from orders_elements oe 
	join drinks d2 on oe.drinks_code = d2.code
	join menu_groups mg on mg.code = d2.group_code 
where oe.code = 22;

--Выдать чек на заказ 22 со скидкой на ДР:
insert into checks(check_time, order_code, discount_code, discount_card)
values
	('2022-08-14 17:00:00', 22, 1, null);

select * from checks c where c.order_code = 22;

--Принять оплату по заказу: 
insert into payments (payment_time, check_code, payment_amount)
values 
	('2022-08-14 17:25:40', 30, 1665);
	
--Проверить рейтинг официантов после оплаты заказа:
select * from waiters_rating; --Ммда. Не сильно изменилось

--И напоследок - песня! https://youtu.be/A1Qb4zfurA8