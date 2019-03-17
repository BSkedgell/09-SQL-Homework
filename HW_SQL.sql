-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT CONCAT(first_name, ' ', last_name) AS actor_name
FROM actor;
SELECT actor_name, CAST(UPPER);

-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name in("Joe");

-- 2b
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%gen%";

-- 2c
SELECT last_name, first_name, actor_id
FROM actor
WHERE last_name LIKE "%li%"
ORDER BY last_name, first_name;

-- 2d
SELECT country, country_id
FROM country
WHERE country IN("Afghanistan", "Bangladesh", "China");

-- 3a
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NOT NULL AFTER `last_update`;

-- 3b
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a
SELECT DISTINCT last_name as last_name_dist,
COUNT(last_name) as last_name_count
FROM actor
GROUP BY last_name;

-- 4b
SELECT DISTINCT last_name as last_name_dist,
COUNT(last_name) as last_name_count
FROM actor
GROUP BY last_name
HAVING last_name_count >= 2;

-- 4c
UPDATE sakila.actor 
SET first_name='GROUCHO' 
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE sakila.actor
SET first_name='HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE address ;
	-- CREATE TABLE `address` (
-- 	  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
-- 	  `address` varchar(50) NOT NULL,
-- 	  `address2` varchar(50) DEFAULT NULL,
-- 	  `district` varchar(20) NOT NULL,
-- 	  `city_id` smallint(5) unsigned NOT NULL,
-- 	  `postal_code` varchar(10) DEFAULT NULL,
-- 	  `phone` varchar(20) NOT NULL,
-- 	  `location` geometry NOT NULL,
-- 	  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
-- 	  PRIMARY KEY (`address_id`),
-- 	  KEY `idx_fk_city_id` (`city_id`),
-- 	  SPATIAL KEY `idx_location` (`location`),
-- 	  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- 	) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
    
-- 6a 
SELECT stf.first_name, stf.last_name, addr.address 
FROM staff AS stf 
JOIN address AS addr ON (stf.address_id = addr.address_id);
   
-- 6b
SELECT  stf.first_name AS FirstName , stf.last_name AS Last,  COALESCE(SUM(pay.amount), 0)  AS Sale
FROM staff AS stf  
JOIN payment AS pay ON (stf.staff_id = pay.staff_id) 
WHERE pay.payment_date >= '2005-08-01' AND  pay.payment_date <= '2005-08-31'  GROUP BY stf.first_name, stf.last_name;

-- 6c
SELECT * FROM film;
SELECT * FROM film_actor;

SELECT film_actor.film_id , film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY film_id;

-- 6d
SELECT * FROM inventory;
SELECT * FROM film;

SELECT COUNT(*) 
FROM inventory
WHERE film_id IN
	(SELECT film_id
	FROM film
    WHERE title = 'Hunchback Impossible');

-- 6e
SELECT * FROM payment;
SELECT * FROM customer;

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(payment.amount) AS payment_amount
FROM customer
JOIN payment ON
customer.customer_id = payment.customer_id
GROUP BY customer_id
ORDER BY last_name ASC;

-- 7a
SELECT * FROM film;
SELECT * FROM language;

SELECT film_id, title, language_id FROM film
WHERE
(title LIKE 'Q%'
OR
title LIKE 'K%')
AND
language_id IN (
	SELECT language_id
    FROM language
    WHERE name = 'English'
);

-- 7b
SELECT * FROM film_actor;
SELECT * FROM film;
SELECT * FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);

-- 7c
SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON
customer.address_id = address.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

SELECT film_id, title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
		)
	);

-- 7e
SELECT * FROM film;
SELECT * FROM inventory;
SELECT * FROM rental;

SELECT inventory.film_id, COUNT(rental.inventory_id) AS rental_count
FROM inventory
JOIN rental ON
inventory.inventory_id = rental.inventory_id
GROUP BY film_id
ORDER BY rental_count DESC;

-- 7f
SELECT amount, store_id FROM payment;
SELECT store_id, store_id FROM customer;

SELECT customer.store_id, SUM(payment.amount) AS total_payment
FROM customer
JOIN payment ON
customer.store_id = payment.customer_id
GROUP BY store_id;

-- 7g
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON address.address_id = store.address_id
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id
GROUP BY store.store_id; 

#7h
SELECT category.name, COUNT(payment.amount) AS 'total_amount'
FROM inventory
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY COUNT(payment.amount) DESC LIMIT 5;

#8a
CREATE VIEW Top_5_genre AS
	SELECT category.name, COUNT(payment.amount) AS 'total_amount'
	FROM inventory
	INNER JOIN film_category ON inventory.film_id = film_category.film_id
	INNER JOIN category ON film_category.category_id = category.category_id
	INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	INNER JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY category.name
	ORDER BY COUNT(payment.amount) DESC LIMIT 5;

#8b
SELECT * FROM Top_5_genre;

#8c
DROP VIEW Top_5_genre;
	
