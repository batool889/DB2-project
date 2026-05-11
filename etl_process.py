import pandas as pd
from sqlalchemy import create_engine

# 1. CONNECT
engine_source = create_engine("mysql+pymysql://root:batool123@localhost/sakila")
engine_dw = create_engine("mysql+pymysql://root:batool123@localhost/movie_rental_dw")

# 2. EXTRACT
df_rental = pd.read_sql("SELECT * FROM rental", engine_source)
df_payment = pd.read_sql("SELECT * FROM payment", engine_source)
df_inventory = pd.read_sql("SELECT * FROM inventory", engine_source)
df_film = pd.read_sql("SELECT * FROM film", engine_source)
df_customer = pd.read_sql("SELECT * FROM customer", engine_source)
df_staff = pd.read_sql("SELECT * FROM staff", engine_source)

# TRANSFORM /CLEANING

# FACT 1: RENTAL (Activity)
df_rental['return_date'] = df_rental['return_date'].fillna(pd.Timestamp('2025-01-01'))
df_rental['duration_days'] = (df_rental['return_date'] - df_rental['rental_date']).dt.days

# FACT 2: PAYMENT (Revenue)

df_fact_payment = df_payment[['payment_id', 'customer_id', 'staff_id', 'rental_id', 'amount', 'payment_date']]

# FACT 3: INVENTORY (Stock) 

df_fact_inventory = df_inventory[['inventory_id', 'film_id', 'store_id']]

# DIMENSIONS 
df_dim_film = pd.merge(df_inventory, df_film, on='film_id').drop_duplicates('inventory_id')
df_dim_customer = df_customer.copy()
df_dim_staff = df_staff[['staff_id', 'first_name', 'last_name', 'store_id']]

#LOAD 
df_rental.to_sql('fact_rental', engine_dw, if_exists='replace', index=False)
df_fact_payment.to_sql('fact_payment', engine_dw, if_exists='replace', index=False)
df_fact_inventory.to_sql('fact_inventory', engine_dw, if_exists='replace', index=False)

df_dim_film.to_sql('dim_film', engine_dw, if_exists='replace', index=False)
df_dim_customer.to_sql('dim_customer', engine_dw, if_exists='replace', index=False)
df_dim_staff.to_sql('dim_staff', engine_dw, if_exists='replace', index=False)

print("ETL SUCCESS: 3 Facts and 3 Dimensions Loaded!")