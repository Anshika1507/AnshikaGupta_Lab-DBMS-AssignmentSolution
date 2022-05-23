drop database if exists e_commerce;
create database E_commerce;
use E_commerce;
drop table if exists Supplier;
create table Supplier(Supp_id int primary key,
Supp_name varchar(50) not null,
Supp_city varchar(30) not null,
Supp_phone varchar(15)
);
create table Customer(Cus_id int primary key,
Cus_name varchar(20),
Cus_phone varchar(10),
Cus_city varchar(30),
Cus_gender char
);
create table Category(Cat_id int primary key,
Cat_name varchar(20) not null
);
create table Products(Pro_id int primary key,
Pro_name varchar(20) not null,
Pro_desc varchar(60),
Cat_id int,
foreign key(Cat_id) references Category(Cat_id)
);
create table Supplier_pricing(Pricing_id int primary key,
Pro_id int,
Supp_id int,
Supp_price int default 0,
foreign key(Pro_id) references Products(Pro_id),
foreign key(Supp_id) references Supplier(Supp_id)
);
create table Orders(Ord_id int primary key,
Ord_amount int not null,
Ord_date date not null,
Cus_id int,
Pricing_id int,
foreign key(Cus_id) references Customer(Cus_id),
foreign key(Pricing_id) references Supplier_pricing(Pricing_id)
);
create table Rating(Rat_id int primary key,
Ord_id int,
Rat_ratstars int not null,
foreign key(Ord_id) references Orders(Ord_id)
);

insert into Supplier values
(1,'Rajesh Retails','Delhi','1234567890'),
(2, 'Appario Ltd.', 'Mumbai', '2589631470'),
(3, 'Knome products', 'Banglore', '9785462315'),
(4,'Bansal Retails', 'Kochi', '8975463285'),
(5, 'Mittal Ltd.', 'Lucknow', '7898456532');

insert into Customer values
(1, 'AAKASH', '9999999999', 'DELHI', 'M'),
(2, 'AMAN', '9785463215', 'NOIDA', 'M'),
(3, 'NEHA', '9999999999', 'MUMBAI', 'F'),
(4, 'MEGHA', '9994562399', 'KOLKATA', 'F'),
(5, 'PULKIT', '7895999999', 'LUCKNOW', 'M');

insert into Category values
(1, 'BOOKS'),
(2, 'GAMES'),
(3, 'GROCERIES'),
(4, 'ELECTRONICS'),
(5, 'CLOTHES');

insert into Products values
(1,'gta v','Windows 7 and above with i5 processor and 8GB RAM',2),
(2,'tshirt','SIZE-L with Black, Blue and White variations',5),
(3,'rog laptop','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),
(4,'oats','Highly Nutritious from Nestle',3),
(5,'harry porter','Best Collection of all time by J.K Rowling ',1),
(6,'milk','1L Toned MIlk',3),
(7,'boat earphones','1.5Meter long Dolby Atmos',4),
(8,'jeans','Stretchable Denim Jeans with various sizes and color',5),
(9,'project IGI','compatible with windows 7 and above',2),
(10,'Hoodie','Black GUCCI for 13 yrs and above',5),
(11,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),
(12,'Train Your Brain','By Shireen Stephen',1);

insert into Supplier_pricing values
(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000);

insert into Orders values
(101,1500,'2021-10-06',2,1),
(102,1000,'2021-10-12',3,5),
(103,30000,'2021-09-16',5,2),
(104,1500,'2021-10-05',1,1),
(105,3000,'2021-08-16',4,3),
(106,1450,'2021-08-18',1,4),
(107,789,'2021-09-01',3,2),
(108,780,'2021-09-07',5,5),
(109,3000,'2021-00-10',5,3),
(110,2500,'2021-09-10',2,4),
(111,1000,'2021-09-15',4,5),
(112,789,'2021-09-16',4,3),
(113,31000,'2021-09-16',1,4),
(114,1000,'2021-09-16',3,5),
(115,3000,'2021-09-16',5,3),
(116,99,'2021-09-17',2,1);

insert into Rating values
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4);

#3
select count(1),c.Cus_gender from Customer c join Orders o on c.Cus_id = o.Cus_id where Ord_amount >= 3000 group by c.Cus_gender;

#4
select Cus_id, Pro_name from Products join Customer where Cus_id=2 and  Pro_id in (select Pro_id  from Supplier_pricing
 where Pricing_id in (select Pricing_id  from Orders where ORD_ID in (select Ord_id from Orders where Cus_id=2) ) );

#5
select s.* from Supplier s inner join Supplier_pricing on s.Supp_id= Supplier_pricing.Supp_id
 group by Supplier_pricing.Supp_id
 having COUNT(Supplier_pricing.Supp_id)>1;
 
 #6
select min(s.Supp_price) Least_expensive ,p.*,c.cat_name from Supplier_pricing s join Products p
on s.Pro_id = p.Pro_id join Category c on p.Cat_id = c.Cat_id group by c.Cat_id;

#7
select Pro_id, Pro_name from Products where Pro_id=any (select sp.Pro_ID from Orders o 
 inner join Supplier_pricing sp on o.Pricing_id= sp.Pricing_id where o.Ord_Date > '2021-10-05');
 
#8
select Cus_name,Cus_gender from Customer where Cus_name like '%A%';

#9
DELIMITER $$
create procedure Appraisal()
begin
select s.Supp_id, s.Supp_name, rt.Rat_ratstars,
case
    when rt.Rat_ratstars=5 then 'EXCELLENT SERVICE'
    when rt.Rat_ratstars= 4 then 'GOOD SERVICE'
	when rt.Rat_ratstars > 2 then 'AVERAGE SERVICE'
    else 'POOR SERVICE'
end as Type_of_Service
from Rating rt
inner join Orders on rt.Ord_id= Orders.Ord_id
inner join Supplier_pricing sp on sp.Pricing_id= Orders.Pricing_id
inner join Supplier s on s.Supp_id= sp.Supp_id;
END $$
DELIMITER ;

call Appraisal();