CREATE DATABASE PROJECTS;
USE PROJECTS;
SHOW TABLES;
select * from album2;
select * from artist;
select * from customer;
select * from genre;
select * from invoice;
select * from invoice_line;
select * from media_type;
select * from playlist;
select * from playlist_track;
select * from track;
select * from employee;


##########   EASY     ###########

-- 1. Who is the senior most employee based on job title?

select concat(first_name," ",last_name) as name, title as job_title,levels from employee order by levels desc limit 1;

-- 2. Which country have the most Invoices?

select billing_country,count(billing_country) as orders from invoice group by billing_country order by orders desc limit 1;

-- 3. What are top 3 values of total invoice?

select total from invoice order by total desc limit 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music
-- Festival in the city we made the most money. Write a query that returns one city that
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice
-- totals

select billing_city,round(sum(total),2) as sales from invoice group by billing_city order by sales desc limit 1;
 
 SELECT billing_city,round(sum(total),2) as total_sales from invoice group by billing_city order by total_sales desc limit 1;
 
 -- 5. Who is the best customer? The customer who has spent the most money will be
-- declared the best customer. Write a query that returns the person who has spent the
-- most money


select concat(first_name," ",last_name) as customer_name,round(sum(total),2) as spend from customer
 c join invoice i on c.customer_id=i.customer_id group by first_name,last_name order by spend desc limit 1;
 
 select concat(first_name," ",last_name) as customer_name from customer
 c join invoice i on c.customer_id=i.customer_id  order by total desc limit 1;



################ MODERATE  ##################

-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music
-- listeners. Return your list ordered alphabetically by email starting with A

select c.email,c.first_name,c.last_name,g.name from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id 
 where g.name="rock" order by email;
 
 
 
 
 
 -- 2. Let's invite the artists who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count of the top 10 rock bands


select ar.name,count(ar.name) as number_of_song from track t 
join album2 al on t.album_id=al.album_id
join artist ar on ar.artist_id=al.artist_id
join genre g on g.genre_id=t.genre_id
where g.name="rock"
group by ar.name
order by number_of_song desc
limit 10;



-- 3. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the
-- longest songs listed first


select name,milliseconds from track where milliseconds>(select avg(milliseconds) from track) order by milliseconds desc;




#####################  advance questions  ######################

-- 1. Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent

select concat(c.first_name," ",c.last_name) as name,ar.name,sum(inv.total) as total from customer c
join invoice inv on c.customer_id=inv.customer_id
join invoice_line il on inv.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join album2 al on t.album_id=al.album_id
join artist ar on ar.artist_id=al.artist_id
group by ar.name,c.first_name,c.last_name
order by total,ar.name desc;


-- 2. We want to find out the most popular music Genre for each country. We determine the
-- most popular genre as the genre with the highest amount of purchases. Write a query
-- that returns each country along with the top Genre. For countries where the maximum
-- number of purchases is shared return all Genres

select g.name,inv.billing_country,count(g.name) as total_purchase from genre g
join track t on g.genre_id=t.genre_id
join invoice_line il on il.track_id=t.track_id
join invoice inv on inv.invoice_id=il.invoice_id
group by g.name,inv.billing_country
order by g.name desc ,total_purchase desc;


-- 3. Write a query that determines the customer that has spent the most on music for each
-- country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all
-- customers who spent this amount
with q3 as
(
select i.billing_country,concat(c.first_name," ",last_name) name,i.total,
rank() over(partition by i.billing_country order by i.total desc) as rnk from customer c 
join invoice i on c.customer_id=i.customer_id 
)
select billing_country,name,sum(total) as total,rnk from q3 where rnk =1 group by 1,2 order by total desc,billing_country desc ;



