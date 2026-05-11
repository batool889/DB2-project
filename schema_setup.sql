CREATE DATABASE IF NOT EXISTS movie_rental_dw;
USE movie_rental_dw;

# Set Primary Keys 

ALTER TABLE dim_customer ADD PRIMARY KEY (customer_id);
ALTER TABLE dim_film ADD PRIMARY KEY (inventory_id);
ALTER TABLE dim_staff ADD PRIMARY KEY (staff_id);
ALTER TABLE fact_rental ADD PRIMARY KEY (rental_id);
ALTER TABLE fact_payment ADD PRIMARY KEY (payment_id);
ALTER TABLE fact_inventory ADD PRIMARY KEY (inventory_id);

# Set Foreign Keys 

ALTER TABLE fact_rental ADD CONSTRAINT fk_rent_cust FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id);
ALTER TABLE fact_rental ADD CONSTRAINT fk_rent_film FOREIGN KEY (inventory_id) REFERENCES dim_film(inventory_id);


ALTER TABLE fact_payment ADD CONSTRAINT fk_pay_cust FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id);
ALTER TABLE fact_payment ADD CONSTRAINT fk_pay_staff FOREIGN KEY (staff_id) REFERENCES dim_staff(staff_id);


ALTER TABLE fact_inventory ADD CONSTRAINT fk_inv_film FOREIGN KEY (inventory_id) REFERENCES dim_film(inventory_id);