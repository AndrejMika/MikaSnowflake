DROP DATABASE IF EXISTS ChinookDb;
CREATE DATABASE ChinookDb;
USE ChinookDb;

-- Staging Tables
CREATE TABLE Artist_Staging (
    ArtistId INT PRIMARY KEY NOT NULL,
    Name VARCHAR(120) NOT NULL
);

CREATE TABLE Album_Staging (
    AlbumId INT PRIMARY KEY NOT NULL,
    Title VARCHAR(160) NOT NULL,
    ArtistId INT NOT NULL
);

CREATE TABLE Track_Staging (
    TrackId INT PRIMARY KEY NOT NULL,
    Name VARCHAR(200) NOT NULL,
    AlbumId INT NOT NULL,
    MediaTypeId INT NOT NULL,
    GenreId INT NOT NULL,
    Composer VARCHAR(220) NOT NULL,
    Milliseconds INT NOT NULL,
    Bytes INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Genre_Staging (
    GenreId INT PRIMARY KEY NOT NULL,
    Name VARCHAR(120) NOT NULL
);

CREATE TABLE MediaType_Staging (
    MediaTypeId INT PRIMARY KEY NOT NULL,
    Name VARCHAR(120) NOT NULL
);

CREATE TABLE Customer_Staging (
    CustomerId INT PRIMARY KEY NOT NULL,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(40) NOT NULL,
    Company VARCHAR(80) NOT NULL,
    Address VARCHAR(70) NOT NULL,
    City VARCHAR(40) NOT NULL,
    State VARCHAR(40) NOT NULL,
    Country VARCHAR(40) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Phone VARCHAR(24) NOT NULL,
    Fax VARCHAR(24) NOT NULL,
    Email VARCHAR(60) NOT NULL,
    SupportRepId INT NOT NULL
);

CREATE TABLE Invoice_Staging (
    InvoiceId INT PRIMARY KEY NOT NULL,
    CustomerId INT NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    BillingAddress VARCHAR(70) NOT NULL,
    BillingCity VARCHAR(40) NOT NULL,
    BillingState VARCHAR(40) NOT NULL,
    BillingCountry VARCHAR(40) NOT NULL,
    BillingPostalCode VARCHAR(10) NOT NULL,
    Total DECIMAL(10, 2) NOT NULL
);

CREATE TABLE InvoiceLine_Staging (
    InvoiceLineId INT PRIMARY KEY NOT NULL,
    InvoiceId INT NOT NULL,
    TrackId INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL
);

CREATE TABLE Employee_Staging (
    EmployeeId INT PRIMARY KEY NOT NULL,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(40) NOT NULL,
    Title VARCHAR(40) NOT NULL,
    ReportsTo INT NOT NULL,
    BirthDate DATETIME NOT NULL,
    HireDate DATETIME NOT NULL,
    Address VARCHAR(70) NOT NULL,
    City VARCHAR(40) NOT NULL,
    State VARCHAR(40) NOT NULL,
    Country VARCHAR(40) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Phone VARCHAR(24) NOT NULL,
    Fax VARCHAR(24) NOT NULL,
    Email VARCHAR(60) NOT NULL
);

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
    invoice_id INT NOT NULL,
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

-- Populate Dimension and Fact Tables (Same logic as the previous version)

-- Drop Staging Tables
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Employee_Staging;
DROP TABLE IF EXISTS InvoiceLine_Staging;
DROP TABLE IF EXISTS Invoice_Staging;
DROP TABLE IF EXISTS Customer_Staging;
DROP TABLE IF EXISTS MediaType_Staging;
DROP TABLE IF EXISTS Genre_Staging;
DROP TABLE IF EXISTS Track_Staging;
DROP TABLE IF EXISTS Album_Staging;
DROP TABLE IF EXISTS Artist_Staging;
SET FOREIGN_KEY_CHECKS = 1;

