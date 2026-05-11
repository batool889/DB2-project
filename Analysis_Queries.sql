USE movie_rental_dw;


# Fact 1: Rental Activity (Operations Analysis)

# Q1: Which films are rented most frequently?
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM fact_rental r
JOIN dim_film f ON r.inventory_id = f.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC;

# Q6 & Q12: Which customers rent the most, and what is the average duration?
SELECT c.first_name, c.last_name, 
       COUNT(r.rental_id) AS total_rentals, 
       AVG(r.duration_days) AS avg_duration
FROM fact_rental r
JOIN dim_customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_rentals DESC;

# Q13: Which films are returned late most often?

SELECT f.title, COUNT(*) AS late_returns
FROM fact_rental r
JOIN dim_film f ON r.inventory_id = f.inventory_id
WHERE r.duration_days > f.rental_duration
GROUP BY f.title
ORDER BY late_returns DESC;


# Fact 2: Payment & Revenue (Financial Analysis)

# Q2 & Q3: Which films generate the highest revenue?
SELECT f.title, SUM(p.amount) AS total_revenue
FROM fact_payment p
JOIN fact_rental r ON p.rental_id = r.rental_id
JOIN dim_film f ON r.inventory_id = f.inventory_id
GROUP BY f.title
ORDER BY total_revenue DESC;

# Q5: Which stores generate the highest revenue?
SELECT s.store_id, SUM(p.amount) AS store_revenue
FROM fact_payment p
JOIN dim_staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id;

# Q9: How does revenue change over time? (Monthly Trend)
SELECT MONTHNAME(payment_date) AS month, SUM(amount) AS monthly_revenue
FROM fact_payment
GROUP BY month
ORDER BY monthly_revenue DESC;


# Fact 3: Inventory & Stock (Asset Management)

# Q14 & Q15: How does store performance differ by Store ID?
SELECT store_id, COUNT(inventory_id) AS stock_count
FROM fact_inventory
GROUP BY store_id;