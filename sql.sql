
--  Q1

select week_cat, sum(pay) from (
select
order_id,
case
when dayofweek(order_purchase_timestamp)=1 or dayofweek(order_purchase_timestamp)=7 then "weekend"
else "weekday"
end week_cat from olist_orders_dataset) o join (select 
replace(order_id,'"','') order_id,
sum(payment_value) pay
from olist_order_payments_dataset
group by order_id) p
on o.order_id=p.order_id
group by week_cat;

-- Q2

select count(order_id)
from olist_orders_dataset
where order_id in 
(select order_id
from olist_order_payments_dataset
where payment_type like "credit_card" and order_id in (
select order_id
from olist_order_reviews_dataset
where review_score=5
));

-- or using joins

select count(*) from (
select p.order_id 
from olist_order_payments_dataset p join olist_order_reviews_dataset r
on p.order_id=r.order_id
where payment_type="credit_card" and review_score=5
group by p.order_id) As t;




-- Q3

select avg(shipping_days) shipping_days from (
select order_id, datediff(order_delivery_customer_date,order_purchase_timestamp) shipping_days
from olist_orders_dataset
where order_id in 
(
select order_id from olist_order_items_dataset
where product_id in (select product_id
from olist_products_dataset
where product_category_name="pet_shop"
))
) as T;

-- Q4


select avg(i.price) avg_price, avg(p.payment_value) avg_payment from (
select o.order_id,i.price, p.payment_value
from olist_order_items_dataset i join olist_order_payments_dataset p
on i.order_id=p.order_id
right join olist_orders_dataset o
on p.order_id=o.order_id
where customer_id in 
(select customer_id
from olist_customers_dataset
where customer_city="sao paulo")) as T1;

-- Q5

select review_score, sum(datediff(order_delivery_customer_date,order_purchase_timestamp)) shipping_days
from olist_orders_dataset o join olist_order_reviews_dataset r
on o.order_id=r.order_id
group by review_score;





