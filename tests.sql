--�����c� ��� ������������ ��:
--����� ���������
select * from violation_log v ;

--������ �� ��������� ������ ����� ����������� �����:
update checks set discount_code = 1 where code = 9;

--������������� ����, ��������������� �� ������� �������
select * from fullmenu f ;

--������ �������� ������� (�� ������� �� ����� ����):
select * from open_orders;

--������� �� 13.08.22 � ��������� �������� �������, ������ �������, ������ ������ � ��������:
select * from daily_income;

--������ (����� ��������������� ������ � ��������� �� ����������)
select * from discount_sum;

-- ������ ����������� � ��������� ����������
select * from personal_title;

--������� ��������� �� �������:
select * from waiters_rating;

--����������, ��� �� ���������� �� ����� 14.08:
select 
	w.waiter_id,
	p.fullname
from waiters w 
	join personal p on w.personal_id = p.personal_id
	join timesheets t on p.personal_id = t.personal_id 
where p.title = 3 and date_trunc('day', t.work_day) = '2022-08-14';

--������� ����� ����� � ��������� ��������� � ������� �������: 
insert into orders (order_date, table_number, waiter_id)
values	
	('2022-08-14 15:36:38', 1, 3);

select * from orders o where date_trunc('day', o.order_date) = '2022-08-14';

--�������� �������� ��� ������ ������: 
 insert into orders_elements (code, dishes_code, drinks_code, quantity)
values
	(22, 8, null, 2),
	(22, null, 6, 4),
	(22, 14, null, 2),
	(22, 10, null , 3),
	(22, null, 21, 1);

--�������� ������ ���������� ������� ������ ������:
select 
	oe.code "����� ������",
	mg.names "������",
	d.names "��������",
	oe.quantity "����������"
from orders_elements oe 
	join dishes d on oe.dishes_code = d.code 
	join menu_groups mg on mg.code = d.group_code 
where oe.code = 22
union 
select 
	oe.code "����� ������",
	mg.names "������",
	d2.names "��������",
	oe.quantity "����������"
from orders_elements oe 
	join drinks d2 on oe.drinks_code = d2.code
	join menu_groups mg on mg.code = d2.group_code 
where oe.code = 22;

--������ ��� �� ����� 22 �� ������� �� ��:
insert into checks(check_time, order_code, discount_code, discount_card)
values
	('2022-08-14 17:00:00', 22, 1, null);

select * from checks c where c.order_code = 22;

--������� ������ �� ������: 
insert into payments (payment_time, check_code, payment_amount)
values 
	('2022-08-14 17:25:40', 30, 1665);
	
--��������� ������� ���������� ����� ������ ������:
select * from waiters_rating; --����. �� ������ ����������

--� ���������� - �����! https://youtu.be/A1Qb4zfurA8