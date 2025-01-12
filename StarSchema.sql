DROP DATABASE IF EXISTS ChinookDb;
CREATE DATABASE ChinookDb;
USE ChinookDb;

-- Dimension Tables
CREATE TABLE dim_track (
    track_id INT PRIMARY KEY NOT NULL,
    name VARCHAR(200) NOT NULL,
    composer VARCHAR(220) NOT NULL,
    milliseconds INT NOT NULL,
    bytes INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    album_title VARCHAR(160) NOT NULL,
    artist_name VARCHAR(120) NOT NULL,
    genre_name VARCHAR(120) NOT NULL,
    media_type VARCHAR(120) NOT NULL,
    playlist_name VARCHAR(120) NOT NULL
);

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    company VARCHAR(80) NOT NULL,
    address VARCHAR(70) NOT NULL,
    city VARCHAR(40) NOT NULL,
    state VARCHAR(40) NOT NULL,
    country VARCHAR(40) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    phone VARCHAR(24) NOT NULL,
    email VARCHAR(60) NOT NULL
);

CREATE TABLE dim_employee (
    employee_id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    title VARCHAR(40) NOT NULL,
    reports_to INT NOT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    address VARCHAR(70) NOT NULL,
    city VARCHAR(40) NOT NULL,
    state VARCHAR(40) NOT NULL,
    country VARCHAR(40) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    phone VARCHAR(24) NOT NULL,
    email VARCHAR(60) NOT NULL
);

CREATE TABLE dim_date (
    date_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    week INT NOT NULL,
    quarter INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE fact_sales (
    fact_sales_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    track_id INT NOT NULL,
    date_id INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (employee_id) REFERENCES dim_employee(employee_id),
    FOREIGN KEY (track_id) REFERENCES dim_track(track_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);


