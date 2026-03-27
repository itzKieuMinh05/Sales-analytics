-- Tạo bảng dim_customer
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id INTEGER,
    country TEXT,
    customer_key INTEGER PRIMARY KEY
);

-- Tạo bảng dim_product
CREATE TABLE IF NOT EXISTS dim_product (
    stockcode TEXT,
    description TEXT,
    product_key INTEGER PRIMARY KEY
);

-- Tạo bảng dim_time
CREATE TABLE IF NOT EXISTS dim_time (
    invoicedate TIMESTAMP,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    weekday TEXT,
    date_key INTEGER PRIMARY KEY
);

-- Tạo bảng fact_sales
CREATE TABLE IF NOT EXISTS fact_sales (
    invoice VARCHAR(20),
    customer_key INTEGER,
    product_key INTEGER,
    date_key INTEGER,
    quantity INTEGER,
    price NUMERIC,
    total NUMERIC,
    is_return BOOLEAN
);

-- Nhập dữ liệu từ CSV
COPY dim_customer FROM '/var/lib/postgresql/data_import/dim_customer.csv' DELIMITER ',' CSV HEADER;
COPY dim_product FROM '/var/lib/postgresql/data_import/dim_product.csv' DELIMITER ',' CSV HEADER;
COPY dim_time FROM '/var/lib/postgresql/data_import/dim_time.csv' DELIMITER ',' CSV HEADER;
COPY fact_sales FROM '/var/lib/postgresql/data_import/fact_sales.csv' DELIMITER ',' CSV HEADER;
