INSERT INTO dim_customers (first_name, last_name, age, email, country, postal_code, pet_type, pet_name, pet_breed, source_customer_id)
SELECT DISTINCT customer_first_name, customer_last_name, customer_age, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed, sale_customer_id
FROM mock_data;

INSERT INTO dim_sellers (first_name, last_name, email, country, postal_code, source_seller_id)
SELECT DISTINCT seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code, sale_seller_id
FROM mock_data;

INSERT INTO dim_products (name, category, price, weight, color, size, brand, material, description, rating, reviews, release_date, expiry_date, source_product_id)
SELECT DISTINCT product_name, product_category, product_price, product_weight, product_color, product_size, product_brand, product_material, product_description, product_rating, product_reviews, TO_DATE(product_release_date, 'MM/DD/YYYY'), TO_DATE(product_expiry_date, 'MM/DD/YYYY'), sale_product_id
FROM mock_data;

INSERT INTO dim_stores (name, location, city, state, country, phone, email)
SELECT DISTINCT store_name, store_location, store_city, store_state, store_country, store_phone, store_email
FROM mock_data;

INSERT INTO dim_suppliers (name, contact, email, phone, address, city, country)
SELECT DISTINCT supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country
FROM mock_data;

INSERT INTO fact_sales (customer_id, seller_id, product_id, store_id, supplier_id, sale_date, quantity, total_price)
SELECT 
    cust.customer_id,
    sel.seller_id,
    prod.product_id,
    stor.store_id,
    sup.supplier_id,
    TO_DATE(mock.sale_date, 'MM/DD/YYYY'),
    mock.sale_quantity,
    mock.sale_total_price
FROM mock_data mock
JOIN dim_customers cust ON mock.sale_customer_id = cust.source_customer_id
JOIN dim_sellers sel ON mock.sale_seller_id = sel.source_seller_id
JOIN dim_products prod ON mock.sale_product_id = prod.source_product_id
JOIN dim_stores stor ON mock.store_phone = stor.phone
JOIN dim_suppliers sup ON mock.supplier_phone = sup.phone;

ALTER TABLE dim_customers DROP COLUMN source_customer_id;
ALTER TABLE dim_sellers DROP COLUMN source_seller_id;
ALTER TABLE dim_products DROP COLUMN source_product_id;

DROP TABLE mock_data