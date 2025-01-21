--basic aggregate function
use mavenmovies
--question 1 
select count(customer_id) from rental
--question 2
select avg(rental_duration) from film
--question 3
select * from rental
select avg(datediff(return_date,rental_date)) from rental
--question 4
select upper(first_name),upper(last_name) from customer
--question 5
select customer_id ,count(*) from rental
group by customer_id
--question 6
SELECT * 
FROM film_category fc
JOIN film f ON fc.film_id = f.film_id;
--question 7
SELECT fc.category_id, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
GROUP BY fc.category_id;
--question 8
select * from rental
select * from language
select * from film
select l.name , avg(f.rental_rate) from film as f
join language as l
on f.language_id = l.language_id
group by l.language_id
--question 9 
select f.title , c.first_name , c.last_name from film as f
join inventory as i 
on f.film_id = i.film_id
join rental as r
on r.inventory_id = i.inventory_id
join customer as c 
on r.customer_id = c.customer_id
--question 10
select f.title,a.first_name , a.last_name from film_actor as fa
join film as f
on f.film_id = fa.film_id 
join actor as a 
on a.actor_id=fa.actor_id
where f.title = 'Gone with the Wind'
--question 11
select c.first_name, c.last_name,sum(p.amount) from customer as c
join payment as p
on c.customer_id = p.customer_id
join rental as r 
on p.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
--question 12
select cu.first_name , cu.last_name , f.title from customer as cu
join address as a 
on cu.address_id = a.address_id
join city as c
on c.city_id = a.city_id
join rental as r 
on cu.customer_id = r.customer_id
join inventory as i
on r.inventory_id = i.inventory_id
join film as f
on i.film_id = f.film_id
where c.city = 'London'
group by cu.first_name , cu.last_name , f.title
--question 13
select * from inventory
select f.title , count(r.rental_id) from film as f
join inventory as i 
on f.film_id = i.film_id
join rental as r
on i.inventory_id = r.inventory_id
group by f.film_id , f.title 
order by count(r.rental_id) desc
limit 5
--question 14
select * from rental
SELECT c.first_name, c.last_name, c.customer_id
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;



