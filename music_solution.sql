SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) AS Avg_lenght FROM track)
ORDER BY milliseconds DESC;
SELECT * FROM track;
-- Q1. Who is the senior most employee based on job title? = Madan Mohan
-- Q2. Which countries have the most Invoices? = USA-131, Canada-76, Brazil-61, France-50, Germany-41
-- Q3. What are top 3 values of total invoice?
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1; 

SELECT COUNT(*) AS C, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY C DESC;

SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3;

SELECT * FROM customer c 
INNER JOIN invoice i ON ;

SELECT SUM(total) AS invoice_total, billing_city 
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC; -- Q4 

SELECT c.customer_id, c.first_name, c.last_name, SUM(i.Total) AS Total_amount FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY Total_amount DESC
LIMIT 1;

SELECT DISTINCT email, first_name, last_name
FROM customer c
JOIN invoice i on c.customer_id = i.customer_id
JOIN invoice_line il on i.invoice_id = il.invoice_id
WHERE track_id IN (
    SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name = 'Rock' 
)
ORDER BY email; -- Moderate Q1

SELECT ar.artist_id, ar.name, COUNT(g.name) AS Number_of_Songs
FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id	
ORDER BY Number_of_Songs DESC
LIMIT 10; -- Moderate Q2

WITH best_selling_artist AS(
    SELECT artist.artist_id AS artist_id, artist.name AS artist_name, 
	SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name,bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i 
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track ON track.track_id = il.track_id
JOIN album ON album.album_id = track.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = bsa.artist_id
GROUP BY 1,2,3,4
ORDER by 5 DESC;  -- Advanced Q1  









	