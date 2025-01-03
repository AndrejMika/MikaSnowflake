# MikaSnowflake
ETL proces datasetu Chinook

Tento repozitár obsahuje implementáciu ETL procesu v Snowflake pre analýzu dát z Chinook databázy. Projekt sa zameriava na preskúmanie predajných trendov, preferencií zákazníkov a výkonnosti hudobného katalógu. Výsledný dátový model umožňuje multidimenzionálnu analýzu a vizualizáciu kľúčových metrik.
1. Úvod a popis zdrojových dát

Cieľom projektu je analyzovať dáta týkajúce sa predaja hudobných skladieb, zákazníkov, zamestnancov a fakturácie. Táto analýza umožňuje identifikovať najpredávanejšie skladby, regióny s najvyššími tržbami a správanie zákazníkov.

Zdrojové dáta pochádzajú z Chinook databázy, ktorá obsahuje niekoľko hlavných tabuliek:

    tracks: Informácie o skladbách (názov, album, interpret, žáner, dĺžka).
    invoices: Údaje o faktúrach (dátum, zákazník, suma).
    customers: Informácie o zákazníkoch (meno, adresa, krajina).
    employees: Detaily o zamestnancoch (meno, pozícia, manažér).
    invoice_items: Položky faktúr (skladba, cena, množstvo).

1.1 Dátová architektúra
ERD diagram

Surové dáta sú usporiadané v relačnom modeli, znázornenom na entitno-relačnom diagrame (ERD):

    Hlavné entity: Tracks, Customers, Invoices, Invoice_Items.
    Vzťahy: Faktúry obsahujú položky, ktoré sa vzťahujú na konkrétne skladby. Zákazníci sú prepojení s faktúrami.

2. Dimenzionálny model

Navrhnutý bol hviezdicový model (star schema) s centrálnou faktovou tabuľkou fact_sales, ktorá je prepojená s nasledujúcimi dimenziami:

    dim_tracks: Informácie o skladbách (názov, album, interpret, žáner).
    dim_customers: Demografické údaje o zákazníkoch (krajina, mesto, veková kategória).
    dim_date: Dátumové údaje (deň, mesiac, rok, štvrťrok).
    dim_employees: Detaily o zamestnancoch (meno, pozícia, manažér).

Diagram hviezdicového modelu

Schéma hviezdy ukazuje prepojenia medzi faktovou tabuľkou a dimenziami, zjednodušuje pochopenie a analýzu dát.
3. ETL proces v Snowflake

ETL proces zahŕňal tri fázy: Extract, Transform, Load.
3.1 Extract (Extrahovanie dát)

Dáta boli najprv nahraté do Snowflake pomocou stage úložiska my_stage. Príklad:

CREATE OR REPLACE STAGE my_stage;

COPY INTO tracks_staging
FROM @my_stage/tracks.csv
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

3.2 Transform (Transformácia dát)

Dáta boli vyčistené a transformované do formátu vhodného pre analýzu.
Dimenzia dim_tracks

Tabuľka obsahuje detaily o skladbách.

CREATE TABLE dim_tracks AS
SELECT DISTINCT
    t.TrackId AS dim_trackId,
    t.Name AS track_name,
    al.Title AS album_title,
    ar.Name AS artist_name,
    g.Name AS genre
FROM tracks_staging t
JOIN albums al ON t.AlbumId = al.AlbumId
JOIN artists ar ON al.ArtistId = ar.ArtistId
JOIN genres g ON t.GenreId = g.GenreId;

Dimenzia dim_customers

Obsahuje demografické údaje o zákazníkoch, ako sú krajina a mesto.

CREATE TABLE dim_customers AS
SELECT DISTINCT
    c.CustomerId AS dim_customerId,
    c.FirstName || ' ' || c.LastName AS full_name,
    c.Country AS country,
    c.City AS city,
    CASE 
        WHEN c.Age BETWEEN 18 AND 24 THEN '18-24'
        WHEN c.Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.Age >= 45 THEN '45+'
        ELSE 'Unknown'
    END AS age_group
FROM customers_staging c;

Faktová tabuľka fact_sales

Faktová tabuľka obsahuje záznamy o predaji.

CREATE TABLE fact_sales AS
SELECT 
    ii.InvoiceLineId AS fact_salesId,
    ii.UnitPrice * ii.Quantity AS total_sale,
    d.dim_dateId AS dateID,
    c.dim_customerId AS customerID,
    t.dim_trackId AS trackID
FROM invoice_items ii
JOIN dim_date d ON ii.InvoiceId = d.InvoiceId
JOIN dim_customers c ON ii.CustomerId = c.CustomerId
JOIN dim_tracks t ON ii.TrackId = t.TrackId;

3.3 Load (Načítanie dát)

Dáta boli nahraté do cieľového dátového skladu a staging tabuľky boli odstránené:

DROP TABLE IF EXISTS tracks_staging;
DROP TABLE IF EXISTS customers_staging;
DROP TABLE IF EXISTS invoices_staging;
DROP TABLE IF EXISTS invoice_items_staging;

4. Vizualizácia dát

Dashboard obsahuje 6 vizualizácií:

    Top 10 skladieb podľa predaja

SELECT 
    t.track_name,
    SUM(f.total_sale) AS total_sales
FROM fact_sales f
JOIN dim_tracks t ON f.trackID = t.dim_trackId
GROUP BY t.track_name
ORDER BY total_sales DESC
LIMIT 10;

Predaj podľa krajín

SELECT 
    c.country,
    SUM(f.total_sale) AS total_sales
FROM fact_sales f
JOIN dim_customers c ON f.customerID = c.dim_customerId
GROUP BY c.country
ORDER BY total_sales DESC;

Trend predaja podľa mesiacov

SELECT 
    d.month,
    SUM(f.total_sale) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.dateID = d.dim_dateId
GROUP BY d.month
ORDER BY d.month;

Najlepší zamestnanci podľa tržieb

SELECT 
    e.employee_name,
    SUM(f.total_sale) AS total_sales
FROM fact_sales f
JOIN dim_employees e ON f.employeeID = e.dim_employeeId
GROUP BY e.employee_name
ORDER BY total_sales DESC;

Rozdelenie predajov podľa žánru

SELECT 
    t.genre,
    SUM(f.total_sale) AS total_sales
FROM fact_sales f
JOIN dim_tracks t ON f.trackID = t.dim_trackId
GROUP BY t.genre
ORDER BY total_sales DESC;

Predaj počas dní v týždni

    SELECT 
        d.dayOfWeek,
        SUM(f.total_sale) AS total_sales
    FROM fact_sales f
    JOIN dim_date d ON f.dateID = d.dim_dateId
    GROUP BY d.dayOfWeek
    ORDER BY total_sales DESC;

Dashboard ponúka komplexný pohľad na predajné údaje, umožňuje identifikovať trendy a optimalizovať predajné stratégie.

Andrej Mika
