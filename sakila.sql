USE sakila;

-- Assignment 2

-- Question 1:
-- Retrieve the total number of rentals made in the Sakila database.
SELECT COUNT(*) AS total_rentals FROM rental;

-- Question 2:
-- Find the average rental duration (in days) of movies rented from the Sakila database.
SELECT AVG(rental_duration) AS average_duration FROM film;

-- Question 3:
-- Display the first name and last name of customers in uppercase.
SELECT UPPER(first_name) AS upper_first_name, UPPER(last_name) AS upper_last_name
FROM customer;

-- Question 4:
-- Extract the month from the rental date and display it alongside the rental ID.
SELECT rental_id, EXTRACT(MONTH FROM rental_date) AS rental_month
FROM rental;

-- Question 5:
-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Question 6:
-- Find the total revenue generated by each store.
SELECT
    s.store_id AS Store_ID,
    CONCAT(a.address, ', ', c.city, ', ', cy.country) AS Store_Address,
    CONCAT(m.first_name, ' ', m.last_name) AS Manager_Name,
    SUM(p.amount) AS Total_Revenue
FROM
    payment AS p
INNER JOIN
    rental AS r ON p.rental_id = r.rental_id
INNER JOIN
    inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN
    store AS s ON i.store_id = s.store_id
INNER JOIN
    address AS a ON s.address_id = a.address_id
INNER JOIN
    city AS c ON a.city_id = c.city_id
INNER JOIN
    country AS cy ON c.country_id = cy.country_id
INNER JOIN
    staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY
    s.store_id;

-- Question 7:
-- Display the title of the movie, customer's first name, and last name who rented it.
SELECT Movie.title, Customer.first_name, Customer.last_name
FROM Rental
JOIN Movie ON Rental.movie_id = Movie.id
JOIN Customer ON Rental.customer_id = Customer.id;

-- Question 8:
-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'Gone with the Wind';

-- Question 1:
-- Determine the total number of rentals for each category of movies.
SELECT c.name AS category, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- Question 2:
-- Find the average rental rate of movies in each language.
SELECT language.name AS language, AVG(film.rental_rate) AS average_rental_rate
FROM film
JOIN language ON film.language_id = language.language_id
GROUP BY language.name;

-- Question 3:
-- Retrieve the customer names along with the total amount they've spent on rentals.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
       SUM(payment.amount) AS total_amount_spent
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id;

-- Question 4:
-- List the titles of movies rented by each customer in a particular city (e.g., 'London').
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       f.title AS movie_title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
WHERE ct.city = 'YourCityName';

-- Question 5:
-- Display the top 5 rented movies along with the number of times they've been rented.
SELECT film.title AS movie_title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id
ORDER BY rental_count DESC
LIMIT 5;

-- Question 6:
-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
SELECT customer_id
FROM rental
WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE store_id = 1
)
AND customer_id IN (
    SELECT customer_id
    FROM rental
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM inventory
        WHERE store_id = 2
    )
);
use Sakila;