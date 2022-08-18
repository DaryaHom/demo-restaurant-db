do
language plpgsql  --выполнить функцию для установки БД 
$code$
begin
	
--Скрипт такой, как будто бы я решила открыть кафе с котлетками:
drop schema if exists CutletCafe cascade;

create schema CutletCafe;
set search_path to CutletCafe,public;

-- Всё начинается с меню:
drop table if exists menu;
create table menu (
	code serial primary key, 
	names varchar not null
);

insert into menu(names)
values 
	('Основное меню'),
	('Безалкогольные напитки'),
	('Алкогольные напитки');

--Список групп в меню:
drop table if exists menu_groups;

create table menu_groups (
	code serial primary key, 
	menu_code int references menu(code) on update cascade, 
	names varchar not null
);

insert into menu_groups (menu_code, names)
values 
	(1, 'Котлетки'),
	(1, 'Гарниры'),
	(1, 'Салатики'),
	(1, 'Супчики'),
	(1, 'Десерты'),
	(2, 'Зелёный чаёк'),
	(2, 'Чёрный чаёк'),
	(2, 'Лимонадик'),
	(2, 'Минералка'),
	(2, 'Кофеёк'),
	(3, 'Пиво');

--Список блюд:
drop table if exists dishes; 
-- Разделение таблиц отдельно на блюда и напитки не вполне оправдано с практической точки зрения, т.к. усложняет итоговую выборку. 
-- Возможно, блюда и напитки, следовало использовать в качестве подгрупп, выбирая данные из единой таблицы товаров.
create table dishes (
	code serial primary key,
	group_code int references menu_groups(code) on update cascade,
	names varchar not null,
	ingredients jsonb,
	netto numeric,
	price numeric not null
);

insert into dishes (group_code, names, netto, price)
values 
	(1, 'Куриная котлетка', 200, 200),
	(1, 'Котлетка по-киевски', 200, 250),
	(1, 'Говяжья котлетка', 200, 300),
	(1, 'Морковная котлетка', 200, 150),
	(1, 'Котлетка из тофу', 200, 270),
	(2, 'Пюрешка', 200, 100),
	(2, 'Гречка', 200, 150),
	(2, 'Рис', 200, 100),
	(2, 'Тушёная капустка', 200, 50),
	(2, 'Овощи на гриле', 200, 170),
	(3, 'Морковный', 200, 100),
	(3, 'Винегрет', 200, 150),
	(3, 'Помидоры-огурцы', 200, 100),
	(3, 'Цезарь', 200, 170),
	(4, 'Борщец', 200, 200),
	(4, 'Куриная лапша', 200, 170),
	(4, 'Сырный крем-суп', 200, 200),
	(5, 'Картошка', 100, 100),
	(5, 'Ванильно-творожная котлетка', 150, 150),
	(5, 'Песочно-шоколадная котлетка', 150, 150),
	(5, 'Котлетка из яблок в панировке', 150, 170);

--Список напитков:
drop table if exists drinks; 

create table drinks (
	code serial primary key,
	group_code int references menu_groups(code) on update cascade,
	names varchar,
	ingredients jsonb,
	volume numeric,
	price numeric not null
);

insert into drinks (group_code, names, volume, price)
values
	(6, 'Молочный улун', 250, 200),
	(6, 'Сенча', 250, 150),
	(6, 'Те гуанинь', 250, 150),
	(6, 'Классический зелёный крупнолистовой', 250, 100),
	(7, 'Марроканский', 250, 200),
	(7, 'С чабрецом', 250, 150),
	(7, 'С бергамотом', 250, 150),
	(7, 'Классический черный крупнолистовой', 250, 100),
	(8, 'С малиной и имбирём', 300, 200),
	(8, 'С манго и чиа', 300, 200),
	(8, 'С клубникой и базиликом', 300, 150),
	(8, 'Цитрусовый лимонадик', 300, 150),
	(9, 'С газом', 250, 100),
	(9, 'Без газа', 250, 80),
	(10, 'Американо', 250, 100),
	(10, 'Капучино', 250, 150),
	(10, 'Латте', 250, 150),
	(10, 'Флэт уайт', 200, 150),
	(11, 'Скверна', 250, 250), --У нас нет лицензии на алкоголь, поэтому в баре только пивасик из костромской пивоварни SWABZ
	(11, 'Almond', 250, 230), -- Да-да, это рекламная интеграция в учебном проекте, но они и правда очень крутые ребята ^-^
	(11, 'Rye master', 250, 200),
	(11, 'Wise honey', 250, 200);

-- Создание таблицы должностей (~ штатное расписание)
drop table if exists titles; 

create table titles (
	id serial primary key,
	title_name varchar not null
);

insert into titles (title_name)
values 
	('Повар'), 
	('Бариста'), 
	('Официант'), 
	('Менеджер'), 
	('Мойщик'), 
	('Уборщик');

--Таблица для набора работников:
drop table if exists personal; 

create table personal (
	personal_id serial primary key,
	fullname varchar not null,
	birth_date date not null,
	title int references titles(id) on update cascade
);

--Набор работников:
insert into personal (fullname, birth_date, title)
values 
	('Тукарева Анна Сергеевна', '1988-06-11', 1),
	('Самойлов Глеб Рудольфович', '1970-08-04', 1),
	('Самойлов Вадим Рудольфович', '1964-10-03', 2),
	('Иванова Алла Викторовна', '1996-01-04', 2),
	('Смирнов Сергей Борисович', '1996-04-20', 3),
	('Гришина Валентина Сергеевна', '1989-03-15', 3),
	('Истомина Елена Ивановна', '1986-09-09', 4),
	('Амаян Давид Григорьевич', '1996-12-22', 5),
	('Быстрова Елизавета Васильевна', '1997-05-07', 5),
	('Турова Анна Андреевна', '1998-04-02', 6),
	('Васнецова Любовь Евгеньевна', '1998-03-06', 6),
	('Шилова Юлия Павловна', '1998-03-18', 3);

--Табель рабочего времени или отслеживание, кто-сколько времени пробыл на работе (часов в день):
drop table if exists timesheets; 
create table timesheets (
 	work_day date not null,
 	personal_id int references personal(personal_id),
	work_hours interval 
);

--Будем считать, что табель заполняется автоматически, из системы биллинга, в которой работники отмечаются в момент прихода и ухода
insert into timesheets
values 
	('2022-08-08', 1, '10 hours'),
	('2022-08-08', 6, '10 hours'),
	('2022-08-08', 3, '10 hours'),
	('2022-08-08', 5, '10 hours'),
	('2022-08-08', 7, '8 hours'),
	('2022-08-08', 8, '10 hours'),
	('2022-08-08', 10, '10 hours'),
	('2022-08-09', 1, '10 hours'),
	('2022-08-09', 3, '10 hours'),
	('2022-08-09', 5, '10 hours'),
	('2022-08-09', 7, '8 hours'),
	('2022-08-09', 8, '10 hours'),
	('2022-08-09', 10, '10 hours'),
	('2022-08-09', 12, '10 hours'),
	('2022-08-10', 2, '10 hours'),
	('2022-08-10', 4, '10 hours'),
	('2022-08-10', 6, '10 hours'),
	('2022-08-10', 7, '8 hours'),
	('2022-08-10', 9, '10 hours'),
	('2022-08-10', 11, '10 hours'),
	('2022-08-10', 12, '10 hours'),
	('2022-08-11', 2, '10 hours'),
	('2022-08-11', 4, '10 hours'),
	('2022-08-11', 6, '10 hours'),
	('2022-08-11', 7, '8 hours'),
	('2022-08-11', 9, '10 hours'),
	('2022-08-11', 11, '10 hours'),
	('2022-08-12', 1, '10 hours'),
	('2022-08-12', 3, '10 hours'),
	('2022-08-12', 5, '10 hours'),
	('2022-08-12', 7, '8 hours'),
	('2022-08-12', 8, '10 hours'),
	('2022-08-12', 10, '10 hours'),
	('2022-08-13', 1, '10 hours'),
	('2022-08-13', 3, '10 hours'),
	('2022-08-13', 5, '10 hours'),
	('2022-08-13', 8, '10 hours'),
	('2022-08-13', 10, '10 hours'),
	('2022-08-13', 12, '10 hours'),
	('2022-08-14', 2, '10 hours'),
	('2022-08-14', 4, '10 hours'),
	('2022-08-14', 6, '10 hours'),
	('2022-08-14', 9, '10 hours'),
	('2022-08-14', 11, '10 hours'),
	('2022-08-14', 12, '10 hours');

--В целях защиты персональных данных сотрудников нужно сформировать отдельную таблицу для официантов
drop table if exists waiters;

create table waiters (
	waiter_id serial primary key,
	personal_id int references personal(personal_id) on update cascade 
);

insert into waiters(personal_id)
select p.personal_id
from personal p 
where p.title = 3;

--Дальше нужно обеспечить систему фиксации заказов:
-- Создаём скидки:
drop table if exists discounts;

create table discounts (
	code serial primary key,
	discount_name varchar,
	amount numeric	-- устанавливает коэффициент, на который необходимо умножить сумму заказа для расчёта скидки
);

insert into discounts (discount_name, amount)
values 
	('Скидка в День рождения', 0.9),
	('Скидка по карте постоянного клиента', 0.95),
	('Скидка на сумму заказа свыше 5000 рублей', 0.97);

-- Выдаём персональные скидочные карты 
drop table if exists discount_cards;
create table discount_cards (
	code serial primary key,
	client_name varchar not null
);

insert into discount_cards (client_name)
values 
	('Кирилл'),
	('Антон'),
	('Варвара');

-- Таблица для учёта заказов:
drop table if exists orders;

create table orders (
	code serial primary key,
	order_date timestamp not null,
	table_number int,
	waiter_id int references waiters(waiter_id)
);

--Таблица для элементов заказов:
drop table if exists orders_elements;
create table orders_elements (
	code int not null references orders(code),
	dishes_code int references dishes(code),
	drinks_code int references drinks(code),
	quantity int not null,
	amount numeric check (amount > 0)
);

insert into orders (order_date, table_number, waiter_id)
values	
	('2022-08-08 15:36:38', 1, 1),
	('2022-08-08 16:50:00', 2, 2),
	('2022-08-08 17:24:00', 5, 1),
	('2022-08-09 11:30:00', 1, 3),
	('2022-08-09 12:56:21', 3, 1),
	('2022-08-09 14:09:04', 4, 1),
	('2022-08-10 15:33:17', 2, 3),
	('2022-08-10 16:22:00', 3, 2),
	('2022-08-10 11:08:56', 5, 2),
	('2022-08-11 12:31:00', 4, 2),
	('2022-08-11 16:28:00', 3, 2),
	('2022-08-11 17:25:00', 1, 2),
	('2022-08-12 11:30:00', 2, 1),
	('2022-08-12 12:00:00', 3, 1),
	('2022-08-12 18:44:00', 5, 1),
	('2022-08-13 12:05:06', 4, 3),
	('2022-08-13 15:38:20', 2, 1),
	('2022-08-13 16:16:16', 1, 1),
	('2022-08-14 11:05:21', 5, 3),
	('2022-08-14 17:09:10', 3, 2),
	('2022-08-14 18:03:00', 2, 2);

--Для автозаполнения некоторых таблиц необходимо добавить функции и триггеры
--Triggerf_pre_cost_calculation - функция автоматически считает предварительную стоимость элементов заказа и записывает её в orders_elements
-- Это требуется для информирования клиента о текущей стоимости заказа и упрощения выдачи счёта
drop function if exists triggerf_pre_cost_calculation();

create or replace function triggerf_pre_cost_calculation()
returns trigger
language plpgsql
as 
$$
declare 
dishes_amount numeric;
drinks_amount numeric;
begin
	dishes_amount = coalesce((select d.price from dishes d where d.code = new.dishes_code), 0) * new.quantity;
	drinks_amount = coalesce((select d2.price from drinks d2 where d2.code = new.drinks_code), 0) * new.quantity;
	new.amount = dishes_amount + drinks_amount;
	return new;
end;
$$;

--Триггер для автоматического расчёта суммы скидки, стоимости заказа без скидки и итоговой стоимость заказа в счёте
drop trigger if exists trigger_pre_cost_calculation on orders_elements;

create or replace trigger trigger_pre_cost_calculation
before insert or update on orders_elements
 for each row execute function triggerf_pre_cost_calculation();

--После создания функций автозаполнения можно наполнить значениями таблицу учёта элементов заказов
--В качестве кода таблицы используется код заказа
insert into orders_elements (code, dishes_code, drinks_code, quantity)
values
	(1, 2, null, 2),
	(2, 4, null, 2),
	(4, 20, null, 2),
	(5, 19, null, 2),
	(6, 16, null, 4),
	(6, 21, null, 4),
	(8, 8, null, 2),
	(9, 8, null, 1),
	(10, 4, null, 2),
	(11, 5, null, 8),
	(11, 7, null, 8),
	(12, 17, null, 2),
	(13, 5, null, 3),
	(14, 12, null, 2),
	(16, 2, null, 5),
	(17, 1, null, 2),
	(18, 3, null, 2),
	(19, 8, null, 2),
	(21, 2, null, 2),
	(3, null, 20, 2),
	(6, null, 8, 4),
	(7, null, 11, 2),
	(8, null, 17, 2),
	(10, null, 14, 2),
	(11, null, 20, 8),
	(15, null, 12, 2),
	(17, null, 6, 2),
	(20, null, 9, 2);

--Таблица выданных счетов по заказам:
drop table if exists checks;

create table checks (
	code serial primary key,
	check_time timestamp not null,
	order_code int unique references orders(code), --выдача второго счёта по тому же заказу запрещена. Если такая необходимость есть, нужно отменить счёт и выдать новый либо оплатить текущий счёт и открыть другой
	discount_code int references discounts(code),
	discount_card int references discount_cards(code),
	discount_sum numeric,
	amount numeric check (amount > 0),
	total_amount numeric check (total_amount > 0)	
);

--Журнал нарушений, в который функции записывают факты некорректной выдачи счетов
drop table if exists violation_log;
create table violation_log (
	code serial primary key,
	date_time timestamp,
	userid varchar,
	message text
);

--Функция автоматически считает сумму скидки, стоимость заказа без скидки и итоговую стоимость заказа и добавляет данные в счёт
drop function if exists triggerf_check_calculation();

create or replace function triggerf_check_calculation()
returns trigger
language plpgsql
as 
$$
begin
	new.amount = (select get_amount.summ 
				from (select sum(o.amount) summ, o.code
    					from orders_elements o 
    					group by o.code) get_amount
				where get_amount.code = new.order_code);
	if new.discount_code = 2 and new.discount_card isnull then --Предотвращает оформление скидки постоянного клиента без сканирования карты лояльности
		raise notice 'Скидка постоянного клиента не может быть оформлена без карты';
		insert into violation_log (date_time, userid, message) --Заносит запись в журнал нарушений
		values (current_timestamp, current_user, 'Оформление скидки без карты клиента');
		new.discount_code = null;
	end if;
	if (new.amount > 5000 and new.discount_code isnull) then --Автоматически отслеживает и расчитывает скидку на сумму св.5т.р., если не применена другая скидка
		new.discount_code = 3;
	end if;
	new.total_amount = new.amount * coalesce((select d.amount from discounts d where d.code = new.discount_code), 1);
	new.discount_sum = new.amount - new.total_amount;
	return new;
end;
$$;

--Триггер для автоматического расчёта суммы скидки, стоимости заказа без скидки и итоговой стоимость заказа в счёте
drop trigger if exists trigger_check_calculation on checks;

create or replace trigger trigger_check_calculation
before insert on checks
 for each row execute function triggerf_check_calculation();

--Функция предотвращает оформление скидки после выдачи счёта
drop function if exists triggerf_discount_after_check();

create or replace function triggerf_discount_after_check()
returns trigger
language plpgsql
as 
$$
begin
	if (coalesce((old.discount_code), 0) < new.discount_code) or 
		(coalesce((old.discount_sum), 0) < new.discount_sum) then 
		raise notice 'Скидка не может быть изменена после выдачи счёта';
		insert into violation_log (date_time, userid, message)
		values (current_timestamp, current_user, 'Изменение скидки после выдачи счёта');
		return null;
	end if;
	return new;
end;
$$;

--Триггер для функции triggerf_discount_after_check
drop trigger if exists trigger_discount_after_check on checks;

create or replace trigger trigger_discount_after_check
before update on checks --триггерит только на обновление, т.к. добавить второй счёт по одному и тому же заказу нельзя
 for each row execute function triggerf_discount_after_check();

--После создания триггеров, предостращающих нарущения, можно наполнить значениями таблицу счетов:
insert into checks(check_time, order_code, discount_code, discount_card)
values
	('2022-08-08 16:36:38', 1, 2, 1),
	('2022-08-08 17:50:30', 2, 2, null),
	('2022-08-11 17:28:00', 11, null, null),
	('2022-08-08 18:24:00', 3, 1, null),
	('2022-08-09 12:30:00', 4, 2, 2),
	('2022-08-09 13:56:21', 5, null, null),
	('2022-08-09 15:09:04', 6, null, null),
	('2022-08-10 16:33:17', 7, null, null),
	('2022-08-10 17:22:00', 8, null, null),
	('2022-08-10 12:08:56', 9, 2, 1),
	('2022-08-11 13:31:00', 10, null, null),
	('2022-08-11 18:25:00', 12, null, null),
	('2022-08-12 12:30:00', 13, null, null),
	('2022-08-12 13:00:00', 14, 1, null),
	('2022-08-12 18:56:00', 15, null, null),
	('2022-08-13 13:05:06', 16, null, null),
	('2022-08-13 16:38:20', 17, null, null),
	('2022-08-13 17:16:16', 18, null, null),
	('2022-08-14 12:05:21', 19, 2, 3),
	('2022-08-14 18:09:10', 20, null, null),
	('2022-08-14 18:55:00', 21, 2, 2);

--Таблица оплат по счетам:
drop table if exists payments;

create table payments (
	code serial primary key,
	payment_time timestamp,
	check_code int references checks(code),
	payment_amount numeric
);

--Заполнение оплат. Оплачены все заказы, кроме 14.08.22 после 13:00
insert into payments (payment_time, check_code, payment_amount)
select (ch.check_time + interval '15 minute'), ch.code, ch.total_amount 
from checks ch
where ch.check_time < '2022-08-14 13:00:00';

--Поиск по таблицам заказы, оплаты и счета практически всегда ведётся в хронологическом порядке либо за определённый период, в связи с чем таблицы необходимо индексировать:
create index orders_date on orders(order_date);
create index checks_time on checks(check_time);
create index payments_time on payments(payment_time);

--Представления данных:
--Представление меню, отсортированное по группам товаров
drop view if exists fullmenu;

create or replace view fullmenu as 
select 
	m.names Меню, 
	mg.names Группа,
	d.code  "Код товара",
	d.names Название, 
	d.netto "Масса(Объём)", 
	d.price Цена 
from menu m 
		right join menu_groups mg on m.code = mg.menu_code 
		right join dishes d on mg.code = d.group_code
	union
select 
	m.names Меню, 
	mg.names Группа, 
	d2.code  "Код товара",
	d2.names Название, 
	d2.volume  "Масса(Объём)", 
	d2.price Цена 
from menu m 
		right join menu_groups mg on m.code = mg.menu_code 
		right join drinks d2 on mg.code = d2.group_code
order by Группа;

--Список открытых заказов (по которым не выдан счёт):
drop view if exists open_orders;

create or replace view open_orders as
select o.code "Открытые заказы"  
from orders o 
except 
select c.order_code 
from checks c; 

--Выручка за 13.08.22 с указанием закрытых заказов, суммы заказов, суммы скидок и платежей:
drop view if exists daily_income;

create or replace view daily_income as
select 
	o.code "Код заказа",
	c.discount_sum "Сумма скидки",
	c.total_amount "Сумма заказа",
	p.payment_amount "Сумма оплаты"
from orders o 
	join checks c on o.code = c.order_code
	join payments p on c.code = p.check_code
where date_trunc('day', o.order_date) = '2022-08-13';

--Скидки (сумма предоставленных скидок с разбивкой по категориям)
drop view if exists discount_sum;

create view discount_sum as
select distinct 
	d.code "Код скидки",
	d.discount_name "Название",
	sum(c.discount_sum) over (partition by c.discount_code) "Сумма предоставленных скидок"
from discounts d join checks c on d.code = c.discount_code; 

-- Список сотрудников с указанием должностей
drop view if exists personal_title; 

create view personal_title as
select 
	p.personal_id "Табельный номер",
	p.fullname "ФИО",
	p.birth_date "Дата рождения",
	t.title_name "Должность"
from personal p join titles t on p.title = t.id; 

--Рейтинг официанта по выручке:
drop view if exists waiters_rating; 

create view waiters_rating as
select distinct 
	w.waiter_id "№",
	p2.fullname "ФИО",
	sum (p.payment_amount) over (partition by w.waiter_id) "Выручка"
from waiters w 
	join orders o  on w.waiter_id = o.waiter_id
	join personal p2 on w.personal_id = p2.personal_id  
	join checks c on o.code = c.order_code 
	join payments p on c.code = p.check_code
order by "Выручка" desc;

--Для быстрого получения любых данных о формировании, составе и оплате заказов нужно создать максимально объемлющее представление о них:
drop view if exists all_orders;

create view all_orders as
select * 
from (select 
		oe.code, 
		o.order_date, 
		mg.names group_name, 
		d.names food_name,
		d.netto,
		d.price, 
		oe.quantity,
		oe.amount,
		d3.discount_name,
		c.discount_sum,
		c.total_amount,
		p2.payment_time,
		p2.payment_amount,
		o.table_number,
		p.fullname waiter
	from orders o
		left join orders_elements oe on o.code = oe.code
		join dishes d on oe.dishes_code = d.code 
		join menu_groups mg on mg.code = d.group_code
		left join checks c on oe.code = c.order_code
		left join discounts d3 on c.discount_code = d3.code
		left join payments p2 on c.code = p2.check_code
		join waiters w on o.waiter_id = w.waiter_id 
		join personal p on w.personal_id = p.personal_id
	union all
	select 
		oe.code, 
		o.order_date,
		mg.names group_name, 
		d2.names food_name,
		d2.volume,
		d2.price, 
		oe.quantity,
		oe.amount,
		d3.discount_name,
		c.discount_sum,
		c.total_amount,
		p2.payment_time,
		p2.payment_amount,
		o.table_number,
		p.fullname waiter
	from orders o
		left join orders_elements oe on o.code = oe.code
		join drinks d2 on oe.drinks_code = d2.code
		join menu_groups mg on mg.code = d2.group_code
		left join checks c on oe.code = c.order_code
		left join discounts d3 on c.discount_code = d3.code
		left join payments p2 on c.code = p2.check_code
		join waiters w on o.waiter_id = w.waiter_id 
		join personal p on w.personal_id = p.personal_id 
		) n
order by n.code;

end
$code$;