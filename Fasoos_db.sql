
CREATE TABLE driver(driver_id integer,reg_date date); 

INSERT INTO driver(driver_id,reg_date) 
 VALUES (1,'01-01-2021'),
(2,'01-03-2021'),
(3,'01-08-2021'),
(4,'01-15-2021');

CREATE TABLE ingredients(ingredients_id integer,ingredients_name varchar(60)); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

CREATE TABLE rolls(roll_id integer,roll_name varchar(30)); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');
CREATE TABLE rolls_recipes(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

CREATE TABLE driver_order(order_id integer,driver_id integer,pickup_time datetime,distance VARCHAR(7),duration VARCHAR(10),cancellation VARCHAR(23));
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 VALUES(1,1,'01-01-2021 18:15:34','20km','32 minutes',''),
(2,1,'01-01-2021 19:10:54','20km','27 minutes',''),
(3,1,'01-03-2021 00:12:37','13.4km','20 mins','NaN'),
(4,2,'01-04-2021 13:53:03','23.4','40','NaN'),
(5,3,'01-08-2021 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'01-08-2020 21:30:45','25km','25mins',null),
(8,2,'01-10-2020 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'01-11-2020 18:50:20','10km','10minutes',null);

CREATE TABLE customer_orders(order_id integer,customer_id integer,roll_id integer,not_include_items VARCHAR(4),extra_items_included VARCHAR(4),order_date datetime);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','','01-01-2021  18:05:02'),
(2,101,1,'','','01-01-2021 19:00:52'),
(3,102,1,'','','01-02-2021 23:51:23'),
(3,102,2,'','NaN','01-02-2021 23:51:23'),
(4,103,1,'4','','01-04-2021 13:23:46'),
(4,103,1,'4','','01-04-2021 13:23:46'),
(4,103,2,'4','','01-04-2021 13:23:46'),
(5,104,1,null,'1','01-08-2021 21:00:29'),
(6,101,2,null,null,'01-08-2021 21:03:13'),
(7,105,2,null,'1','01-08-2021 21:20:29'),
(8,102,1,null,null,'01-09-2021 23:54:33'),
(9,103,1,'4','1,5','01-10-2021 11:22:59'),
(10,104,1,null,null,'01-11-2021 18:34:49'),
(10,104,1,'2,6','1,4','01-11-2021 18:34:49');

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;


--how many rolll ordered
select count(roll_id) from customer_orders as c inner join driver_order as d  on c.order_id = d.order_id where distance is not null


--how man unique customer
select * from customer_orders;
select * from driver_order;

select distinct customer_id from customer_orders

--successful order delivered by each driver
select driver_id,count(distinct order_id ) as num_of_orders from driver_order  where distance is not null group by driver_id 

--how many each type of rolls delivered

select roll_id,count(roll_id) as num_of_orders from customer_orders as c inner join driver_order as d on c.order_id = d.order_id 
where distance is not null group by roll_id

select * from customer_orders;
select * from driver_order;


select roll_id,count(roll_id) from customer_orders where order_id in
(select order_id from
(
select *,case when cancellation in('Cancellation','Customer cancellation') then 'C' else 'NC' end as status_order from driver_order
)a
where status_order = 'NC')
group by roll_id


--how many veg and non veg ordered by each customer
select * from rolls;
select * from customer_orders;
select * from driver_order;

select a.*,roll_name from rolls inner join
(
select customer_id,roll_id, count(roll_id) as counts from customer_orders group by customer_id,roll_id
)a
on a.roll_id=rolls.roll_id


--how many rolls in one order
select * from customer_orders;
select * from driver_order;

select order_id,count(order_id) from
(
select a.*,roll_id from customer_orders as c inner join 
(
select *,case when cancellation in('Cancellation','Customer cancellation') then 'C' else 'NC' end as status_order from driver_order
)a
on c.order_id = a.order_id where status_order = 'NC')x
group by x.order_id

 --create temparory table
select * from customer_orders;
select * from driver_order;

 with temp_customer_orders( order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date) as
 (
 select order_id,customer_id,roll_id,case when not_include_items is null or not_include_items ='' then '0' else not_include_items end  as new_not_include,
 case when extra_items_included is  null or extra_items_included = '' or extra_items_included = 'Nan' then '0' else extra_items_included end as new_extra_item,
 order_date from customer_orders
 )
select * from temp_customer_orders

--hour bucket
select hour_bucket,count(distinct order_id) from
(
select *,concat(datepart(hour,order_date),' - ',DATEPART(hour,order_date)+1) as hour_bucket from customer_orders
)a
group by hour_bucket

--how many orders on date
select dayy,count(distinct order_id) as num_orders from
(
select *,datepart(day,order_date) as dayy from customer_orders
)a
group by dayy

-- orders on particular day

select dayy,count(distinct order_id) as num_orders from
(
select *,datename(dw,order_date) as dayy from customer_orders
)a
group by dayy


















