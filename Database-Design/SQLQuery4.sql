create database ups;
use ups;

create table retail_center (
  center_id varchar(10),
  address varchar(100),
  type varchar(50),
  constraint rc_pk primary key(center_id)
);

create table agent (
  agent_id varchar(10),
  first_name varchar(50),
  last_name varchar(50),
  vehicle_number varchar(20),
  constraint a_pk primary key (agent_id),
  constraint a_ck check (vehicle_number like '[a-z][a-z]-[0-9][0-9][0-9][0-9]' or vehicle_number like '[a-z][a-z][a-z]-[0-9][0-9][0-9][0-9]')
);

create table transport_event (
  schedule_number varchar(10),
  type varchar(50),
  delivery_route varchar(100),
  constraint te_pk primary key (schedule_number)
);


create table shipped_item (
  item_number varchar(10),
  dimension varchar(20),
  weight float,
  final_delivery_date date,
  insurance_amount float,
  destination varchar(100),
  agent_id varchar(10),
  schedule_number varchar(10),
  center_id varchar(10),
  constraint si_pk primary key (item_number),
  constraint si_fk1 foreign key (agent_id) references agent (agent_id),
  constraint si_fk2 foreign key (center_id) references retail_center (center_id),
  constraint si_fk3 foreign key (schedule_number) references transport_event (schedule_number)
);

create table production_unit (
  serial_number varchar(10),
  production_description varchar(100),
  product_type varchar(50),
  quality_test_details varchar(100),
  exact_weight float,
  constraint pu_pk primary key (serial_number)
);

create table toy_lot (
  lot_number varchar(10),
  cost_of_material float,
  created_date date,
  item_number varchar(10),
  serial_number varchar(10),
  constraint tl_pk primary key (lot_number),
  constraint tl_fk foreign key (item_number) references shipped_item (item_number)
);

create table raw_material (
  material_id varchar(10),
  unit_cost float,
  type varchar(50),
  product_id varchar(10),
  process_id varchar(10),
  constraint rm_pk primary key (material_id),
  constraint rm_ck check (type in ('direct','indirect'))
);


create table created (
  lot_number varchar(10),
  material_id varchar(10),
  constraint c_pk primary key (lot_number, material_id),
  constraint c_fk1 foreign key (lot_number) references toy_lot (lot_number),
  constraint c_fk2 foreign key (material_id) references raw_material (material_id)
);


create table includes (
  serial_number varchar(10),
  lot_number varchar(10),
  constraint i_pk primary key (serial_number, lot_number),
  constraint i_fk1 foreign key (serial_number) references production_unit (serial_number),
  constraint i_fk2 foreign key (lot_number) references toy_lot (lot_number)
);

create table phone_number(
	center_id varchar(10),
	phone_number varchar(20),
	constraint pn_fk foreign key (center_id) references retail_center(center_id),
	constraint rc_ck check (phone_number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

insert into retail_center values
('RC001','15/A,Garden Road,Malabe','toys suitable for age between 5-10'),
('RC002','20/1,Flower Road,Ragama','Shopping Mall'),
('RC003','30/C,Temple Road,Colombo','Outlet'),
('RC004','159/15,Main street,Kandy','Mall');

insert into agent values
('A001','Barry', 'Alen', 'PJA-1234'),
('A002','james', 'Smith', 'MIB-0007'),
('A003','Joey', 'Roger', 'FR-1546'),
('A004','Rachel', 'Zoe', 'HOP-1996');

insert into transport_event values
('TE001','Truck','Route 66'),
('TE002','Flight','Route 5'),
('TE003','Flight','Route 6'),
('TE004','Truck','Route 34');


INSERT into shipped_item  VALUES 
('SI001','10x10x10', 5.0, '2023-05-01',0, 'City A', 'A001', 'TE001', 'RC001'),
('SI002','8x8x8', 3.7, '2023-05-02', 0, 'Town B', 'A002', 'TE002', 'RC002'),
('SI003','12x12x12', 7.9, '2023-05-03', 0, 'Village C', 'A003', 'TE003', 'RC003'),
('SI004','15x15x15', 7.9, '2023-05-03', 0, 'Town F', 'A004', 'TE004', 'RC004');

select * from shipped_item;

INSERT into production_unit Values
('PU001','Toy 1','Metal','Passed',1.10),
('PU002','Toy 2','Wooden','failed',2.05),
('PU003','Toy 3','Plastic','failed',3.0),
('PU004','Toy 4','Plastic','passed',5.50);

INSERT into toy_lot values
('TL001',60.00,'2023-05-01','SI001','PU001'),
('TL002',55.50,'2023-05-02','SI002','PU002'),
('TL003',42.50,'2023-05-03','SI003','PU003'),
('TL004',75.00,'2023-05-03','SI004','PU004');

INSERT into raw_material values
('RM001', 15.50, 'direct', 'fp001',''),
('RM002', 20.25, 'indirect', '', 'p001'), 
('RM003', 35.00, 'direct', 'fp002', ''), 
('RM004', 50.00, 'direct','fp003', '');

insert into created values
('TL001','RM001'),
('TL002','RM002'),
('TL003','RM003'),
('TL004','RM004');

insert into includes values
('PU001','TL001'),
('PU002','TL002'),
('PU003','TL003'),
('PU004','TL004');

insert into phone_number values
('RC001','0715806969'),
('RC002','0777555555'),
('RC003','0789187091'),
('RC004','0793469101');


create trigger update_insurance_amount 
on shipped_item
for insert 
as 
begin
  update shiypped_item
  set insurance_amount = shipped_item.weight * 1000
end;

create trigger check_weight_trigger
on shipped_item
after insert
as
begin
    if exists (select * from inserted where weight <= 0)
    begin
        RAISERROR('Weight must be greater than 0.', 16, 1);
        rollback transaction;
    end;
end;

create view shipped_item_information as
select si.item_number, si.destination, si.final_delivery_date, si.center_id, si.agent_id, a.first_name, a.last_name
from shipped_item si
inner join agent a on si.agent_id = a.agent_id
inner join retail_center rc on si.center_id = rc.center_id;

create view product_details as
select tl.lot_number,tl.cost_of_material, tl.created_date, pu.product_type, pu.quality_test_details, rm.type as 'material type'
from toy_lot tl
inner join includes i on tl.lot_number = i.lot_number
inner join production_unit pu on i.serial_number = pu.serial_number
inner join created c on tl.lot_number = c.lot_number
inner join raw_material rm on c.material_id = rm.material_id;


create index weight_index
on shipped_item(weight);

create index rc_type_index
on retail_center(type);

Create procedure more_than_500g
as
begin
 	select *
  	from shipped_item
  	where weight > 0.5;
end;

Create procedure items_in_kandy
As
begin
    select *
    FROM shipped_item
    JOIN retail_center on shipped_item.center_id = retail_center.center_id
    where retail_center.address LIKE '%Kandy%';
end; 

Create procedure high_cost_lot
as
begin
    select lot_number
    from toy_lot
    where cost_of_material = (select max(cost_of_material) from toy_lot);
end;

create procedure retail_centers_for_age_5_10
as
begin
  select * 
  from retail_center rc
  inner join shipped_item si on rc.center_id = si.center_id
  where rc.type = 'toys suitable for age between 5-10';
end

exec high_cost_lot;
exec more_than_500g;
exec retail_centers_for_age_5_10;