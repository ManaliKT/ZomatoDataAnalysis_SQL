-- Q. what is the total amount each costomer spent on zomato?
--final output contains these fields,
-- userid
-- total_amount-spend

select s.userid, sum(p.price) as total_amt_spend
from sales s inner join product p
on s.product_id = p.product_id
group by s.userid;

-- /////////////////////////////////////////////////////////////////////////////

-- Q. how many days has each costomer visited zomato?
-- final output contains these fields
-- userid
-- total_days

select userid, count(distinct created_date) as total_days
from sales
group by userid
order by userid;

-- /////////////////////////////////////////////////////////////////////////////

--Q.what was the first product purchased by each customer?
-- final output contains these fields
-- userid
-- product_id
-- created_date
-- rank

select * from
(select *, rank() over (partition by userid order by created_date) rnk 
from sales) t
where rnk = 1 ;

-- /////////////////////////////////////////////////////////////////////////////


--Q. what is the most purchased item on the menu and how many times was it purchased by all customers?
-- final output contains these fields
-- userid
-- sales_per_customer

select userid, count(product_id) as sales_per_cutm
from sales
where product_id = 
(select product_id
from sales
group by product_id 
order by count(product_id) desc limit 1)
group by userid;

-- /////////////////////////////////////////////////////////////////////////////

--Q.which item was most popular for each customer?
-- final output contains these fields
-- product_id
-- userid
-- count
-- rank

select * from
(select *, rank() over (partition by userid order by cnt desc) as rnk from
(select product_id,userid,count(product_id) as cnt
from sales
group by product_id,userid) t) tt
where rnk = 1;

-- /////////////////////////////////////////////////////////////////////////////

--Q.which item was purchased first by the customer after they become a member?
-- final output contains these fields
-- userid
-- created_date
-- product_id
-- gold_signup_date
-- rank

select * from
(select *,
 rank() over (partition by userid order by created_date) rnk from
(select s.userid,s.created_date,s.product_id,g.gold_signup_date 
 from sales s inner join 
goldusers_signup g  
on s.userid = g.userid
where created_date >=gold_signup_date) as c ) d
where rnk =1;

-- /////////////////////////////////////////////////////////////////////////////

--Q.rank all the transaction of the customers
-- final output contains these fields
-- userid
-- created_date
-- product_id
-- rank

select * ,
		rank() over (partition  by userid order by created_date) rnk 
from sales;

-- /////////////////////////////////////////////////////////////////////////////

--Q.which item was purchased just before the customer become a member?
-- final output contains these fields
-- userid
-- created_date
-- product_id
-- gold_signup_date
-- rank

select * from
(select *,
 rank() over (partition by userid order by created_date desc ) rnk from
(select s.userid,s.created_date,s.product_id,g.gold_signup_date 
 from sales s inner join 
goldusers_signup g  
on s.userid = g.userid
where created_date <=gold_signup_date) as c ) d
where rnk =1;
















