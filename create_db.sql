do
language plpgsql  --��������� ������� ��� ��������� �� 
$code$
begin
	
--������ �����, ��� ����� �� � ������ ������� ���� � ����������:
drop schema if exists CutletCafe cascade;

create schema CutletCafe;
set search_path to CutletCafe,public;

-- �� ���������� � ����:
drop table if exists menu;
create table menu (
	code serial primary key, 
	names varchar not null
);

insert into menu(names)
values 
	('�������� ����'),
	('�������������� �������'),
	('����������� �������');

--������ ����� � ����:
drop table if exists menu_groups;

create table menu_groups (
	code serial primary key, 
	menu_code int references menu(code) on update cascade, 
	names varchar not null
);

insert into menu_groups (menu_code, names)
values 
	(1, '��������'),
	(1, '�������'),
	(1, '��������'),
	(1, '�������'),
	(1, '�������'),
	(2, '������ ���'),
	(2, '׸���� ���'),
	(2, '���������'),
	(2, '���������'),
	(2, '�����'),
	(3, '����');

--������ ����:
drop table if exists dishes; 
-- ���������� ������ �������� �� ����� � ������� �� ������ ��������� � ������������ ����� ������, �.�. ��������� �������� �������. 
-- ��������, ����� � �������, ��������� ������������ � �������� ��������, ������� ������ �� ������ ������� �������.
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
	(1, '������� ��������', 200, 200),
	(1, '�������� ��-�������', 200, 250),
	(1, '������� ��������', 200, 300),
	(1, '��������� ��������', 200, 150),
	(1, '�������� �� ����', 200, 270),
	(2, '�������', 200, 100),
	(2, '������', 200, 150),
	(2, '���', 200, 100),
	(2, '������� ��������', 200, 50),
	(2, '����� �� �����', 200, 170),
	(3, '���������', 200, 100),
	(3, '��������', 200, 150),
	(3, '��������-������', 200, 100),
	(3, '������', 200, 170),
	(4, '������', 200, 200),
	(4, '������� �����', 200, 170),
	(4, '������ ����-���', 200, 200),
	(5, '��������', 100, 100),
	(5, '��������-��������� ��������', 150, 150),
	(5, '�������-���������� ��������', 150, 150),
	(5, '�������� �� ����� � ���������', 150, 170);

--������ ��������:
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
	(6, '�������� ����', 250, 200),
	(6, '�����', 250, 150),
	(6, '�� �������', 250, 150),
	(6, '������������ ������ ��������������', 250, 100),
	(7, '������������', 250, 200),
	(7, '� ��������', 250, 150),
	(7, '� ����������', 250, 150),
	(7, '������������ ������ ��������������', 250, 100),
	(8, '� ������� � ������', 300, 200),
	(8, '� ����� � ���', 300, 200),
	(8, '� ��������� � ���������', 300, 150),
	(8, '���������� ���������', 300, 150),
	(9, '� �����', 250, 100),
	(9, '��� ����', 250, 80),
	(10, '���������', 250, 100),
	(10, '��������', 250, 150),
	(10, '�����', 250, 150),
	(10, '���� ����', 200, 150),
	(11, '�������', 250, 250), --� ��� ��� �������� �� ��������, ������� � ���� ������ ������� �� ����������� ��������� SWABZ
	(11, 'Almond', 250, 230), -- ��-��, ��� ��������� ���������� � ������� �������, �� ��� � ������ ����� ������ ������ ^-^
	(11, 'Rye master', 250, 200),
	(11, 'Wise honey', 250, 200);

-- �������� ������� ���������� (~ ������� ����������)
drop table if exists titles; 

create table titles (
	id serial primary key,
	title_name varchar not null
);

insert into titles (title_name)
values 
	('�����'), 
	('�������'), 
	('��������'), 
	('��������'), 
	('������'), 
	('�������');

--������� ��� ������ ����������:
drop table if exists personal; 

create table personal (
	personal_id serial primary key,
	fullname varchar not null,
	birth_date date not null,
	title int references titles(id) on update cascade
);

--����� ����������:
insert into personal (fullname, birth_date, title)
values 
	('�������� ���� ���������', '1988-06-11', 1),
	('�������� ���� �����������', '1970-08-04', 1),
	('�������� ����� �����������', '1964-10-03', 2),
	('������� ���� ����������', '1996-01-04', 2),
	('������� ������ ���������', '1996-04-20', 3),
	('������� ��������� ���������', '1989-03-15', 3),
	('�������� ����� ��������', '1986-09-09', 4),
	('����� ����� �����������', '1996-12-22', 5),
	('�������� ��������� ����������', '1997-05-07', 5),
	('������ ���� ���������', '1998-04-02', 6),
	('��������� ������ ����������', '1998-03-06', 6),
	('������ ���� ��������', '1998-03-18', 3);

--������ �������� ������� ��� ������������, ���-������� ������� ������ �� ������ (����� � ����):
drop table if exists timesheets; 
create table timesheets (
 	work_day date not null,
 	personal_id int references personal(personal_id),
	work_hours interval 
);

--����� �������, ��� ������ ����������� �������������, �� ������� ��������, � ������� ��������� ���������� � ������ ������� � �����
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

--� ����� ������ ������������ ������ ����������� ����� ������������ ��������� ������� ��� ����������
drop table if exists waiters;

create table waiters (
	waiter_id serial primary key,
	personal_id int references personal(personal_id) on update cascade 
);

insert into waiters(personal_id)
select p.personal_id
from personal p 
where p.title = 3;

--������ ����� ���������� ������� �������� �������:
-- ������ ������:
drop table if exists discounts;

create table discounts (
	code serial primary key,
	discount_name varchar,
	amount numeric	-- ������������� �����������, �� ������� ���������� �������� ����� ������ ��� ������� ������
);

insert into discounts (discount_name, amount)
values 
	('������ � ���� ��������', 0.9),
	('������ �� ����� ����������� �������', 0.95),
	('������ �� ����� ������ ����� 5000 ������', 0.97);

-- ����� ������������ ��������� ����� 
drop table if exists discount_cards;
create table discount_cards (
	code serial primary key,
	client_name varchar not null
);

insert into discount_cards (client_name)
values 
	('������'),
	('�����'),
	('�������');

-- ������� ��� ����� �������:
drop table if exists orders;

create table orders (
	code serial primary key,
	order_date timestamp not null,
	table_number int,
	waiter_id int references waiters(waiter_id)
);

--������� ��� ��������� �������:
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

--��� �������������� ��������� ������ ���������� �������� ������� � ��������
--Triggerf_pre_cost_calculation - ������� ������������� ������� ��������������� ��������� ��������� ������ � ���������� � � orders_elements
-- ��� ��������� ��� �������������� ������� � ������� ��������� ������ � ��������� ������ �����
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

--������� ��� ��������������� ������� ����� ������, ��������� ������ ��� ������ � �������� ��������� ������ � �����
drop trigger if exists trigger_pre_cost_calculation on orders_elements;

create or replace trigger trigger_pre_cost_calculation
before insert or update on orders_elements
 for each row execute function triggerf_pre_cost_calculation();

--����� �������� ������� �������������� ����� ��������� ���������� ������� ����� ��������� �������
--� �������� ���� ������� ������������ ��� ������
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

--������� �������� ������ �� �������:
drop table if exists checks;

create table checks (
	code serial primary key,
	check_time timestamp not null,
	order_code int unique references orders(code), --������ ������� ����� �� ���� �� ������ ���������. ���� ����� ������������� ����, ����� �������� ���� � ������ ����� ���� �������� ������� ���� � ������� ������
	discount_code int references discounts(code),
	discount_card int references discount_cards(code),
	discount_sum numeric,
	amount numeric check (amount > 0),
	total_amount numeric check (total_amount > 0)	
);

--������ ���������, � ������� ������� ���������� ����� ������������ ������ ������
drop table if exists violation_log;
create table violation_log (
	code serial primary key,
	date_time timestamp,
	userid varchar,
	message text
);

--������� ������������� ������� ����� ������, ��������� ������ ��� ������ � �������� ��������� ������ � ��������� ������ � ����
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
	if new.discount_code = 2 and new.discount_card isnull then --������������� ���������� ������ ����������� ������� ��� ������������ ����� ����������
		raise notice '������ ����������� ������� �� ����� ���� ��������� ��� �����';
		insert into violation_log (date_time, userid, message) --������� ������ � ������ ���������
		values (current_timestamp, current_user, '���������� ������ ��� ����� �������');
		new.discount_code = null;
	end if;
	if (new.amount > 5000 and new.discount_code isnull) then --������������� ����������� � ����������� ������ �� ����� ��.5�.�., ���� �� ��������� ������ ������
		new.discount_code = 3;
	end if;
	new.total_amount = new.amount * coalesce((select d.amount from discounts d where d.code = new.discount_code), 1);
	new.discount_sum = new.amount - new.total_amount;
	return new;
end;
$$;

--������� ��� ��������������� ������� ����� ������, ��������� ������ ��� ������ � �������� ��������� ������ � �����
drop trigger if exists trigger_check_calculation on checks;

create or replace trigger trigger_check_calculation
before insert on checks
 for each row execute function triggerf_check_calculation();

--������� ������������� ���������� ������ ����� ������ �����
drop function if exists triggerf_discount_after_check();

create or replace function triggerf_discount_after_check()
returns trigger
language plpgsql
as 
$$
begin
	if (coalesce((old.discount_code), 0) < new.discount_code) or 
		(coalesce((old.discount_sum), 0) < new.discount_sum) then 
		raise notice '������ �� ����� ���� �������� ����� ������ �����';
		insert into violation_log (date_time, userid, message)
		values (current_timestamp, current_user, '��������� ������ ����� ������ �����');
		return null;
	end if;
	return new;
end;
$$;

--������� ��� ������� triggerf_discount_after_check
drop trigger if exists trigger_discount_after_check on checks;

create or replace trigger trigger_discount_after_check
before update on checks --��������� ������ �� ����������, �.�. �������� ������ ���� �� ������ � ���� �� ������ ������
 for each row execute function triggerf_discount_after_check();

--����� �������� ���������, ��������������� ���������, ����� ��������� ���������� ������� ������:
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

--������� ����� �� ������:
drop table if exists payments;

create table payments (
	code serial primary key,
	payment_time timestamp,
	check_code int references checks(code),
	payment_amount numeric
);

--���������� �����. �������� ��� ������, ����� 14.08.22 ����� 13:00
insert into payments (payment_time, check_code, payment_amount)
select (ch.check_time + interval '15 minute'), ch.code, ch.total_amount 
from checks ch
where ch.check_time < '2022-08-14 13:00:00';

--����� �� �������� ������, ������ � ����� ����������� ������ ������ � ��������������� ������� ���� �� ����������� ������, � ����� � ��� ������� ���������� �������������:
create index orders_date on orders(order_date);
create index checks_time on checks(check_time);
create index payments_time on payments(payment_time);

--������������� ������:
--������������� ����, ��������������� �� ������� �������
drop view if exists fullmenu;

create or replace view fullmenu as 
select 
	m.names ����, 
	mg.names ������,
	d.code  "��� ������",
	d.names ��������, 
	d.netto "�����(�����)", 
	d.price ���� 
from menu m 
		right join menu_groups mg on m.code = mg.menu_code 
		right join dishes d on mg.code = d.group_code
	union
select 
	m.names ����, 
	mg.names ������, 
	d2.code  "��� ������",
	d2.names ��������, 
	d2.volume  "�����(�����)", 
	d2.price ���� 
from menu m 
		right join menu_groups mg on m.code = mg.menu_code 
		right join drinks d2 on mg.code = d2.group_code
order by ������;

--������ �������� ������� (�� ������� �� ����� ����):
drop view if exists open_orders;

create or replace view open_orders as
select o.code "�������� ������"  
from orders o 
except 
select c.order_code 
from checks c; 

--������� �� 13.08.22 � ��������� �������� �������, ����� �������, ����� ������ � ��������:
drop view if exists daily_income;

create or replace view daily_income as
select 
	o.code "��� ������",
	c.discount_sum "����� ������",
	c.total_amount "����� ������",
	p.payment_amount "����� ������"
from orders o 
	join checks c on o.code = c.order_code
	join payments p on c.code = p.check_code
where date_trunc('day', o.order_date) = '2022-08-13';

--������ (����� ��������������� ������ � ��������� �� ����������)
drop view if exists discount_sum;

create view discount_sum as
select distinct 
	d.code "��� ������",
	d.discount_name "��������",
	sum(c.discount_sum) over (partition by c.discount_code) "����� ��������������� ������"
from discounts d join checks c on d.code = c.discount_code; 

-- ������ ����������� � ��������� ����������
drop view if exists personal_title; 

create view personal_title as
select 
	p.personal_id "��������� �����",
	p.fullname "���",
	p.birth_date "���� ��������",
	t.title_name "���������"
from personal p join titles t on p.title = t.id; 

--������� ��������� �� �������:
drop view if exists waiters_rating; 

create view waiters_rating as
select distinct 
	w.waiter_id "�",
	p2.fullname "���",
	sum (p.payment_amount) over (partition by w.waiter_id) "�������"
from waiters w 
	join orders o  on w.waiter_id = o.waiter_id
	join personal p2 on w.personal_id = p2.personal_id  
	join checks c on o.code = c.order_code 
	join payments p on c.code = p.check_code
order by "�������" desc;

--��� �������� ��������� ����� ������ � ������������, ������� � ������ ������� ����� ������� ����������� ���������� ������������� � ���:
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