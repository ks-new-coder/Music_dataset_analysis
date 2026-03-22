-- Q1. Who is the senior most employee based on job title? = Madan Mohan
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1; 
-- Q2. Which countries have the most Invoices? = USA-131, Canada-76, Brazil-61, France-50, Germany-41
SELECT COUNT(*) AS C, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY C DESC;
-- Q3. What are top 3 values of total invoice?
SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3;
-- Q4. Find one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.
SELECT SUM(total) AS invoice_total, billing_city 
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC; 
-- Q5. Find the person who has spent the most money.
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.Total) AS Total_amount FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY Total_amount DESC
LIMIT 1;
-- Q6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email, starting with A.
SELECT DISTINCT email, first_name, last_name
FROM customer c
JOIN invoice i on c.customer_id = i.customer_id
JOIN invoice_line il on i.invoice_id = il.invoice_id
WHERE track_id IN (
    SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name = 'Rock' 
)
ORDER BY email;
-- Q7. Let's invite the artists who have written the most rock music in our dataset. Find the artist's name and total track count of the top 10 rock bands.
SELECT ar.artist_id, ar.name, COUNT(g.name) AS Number_of_Songs
FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id	
ORDER BY Number_of_Songs DESC
LIMIT 10; 
-- Q8 Return all the track names that have a song length longer than the average song length. Retrun the name, and Milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) AS Avg_lenght FROM track)
ORDER BY milliseconds DESC;
SELECT * FROM track;
-- Q9 Find how much amount was spent by each customer on artists? Write a query to return customer name, artist name and total spent.
SELECT c.customer_id, c.first_name, c.last_name,bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i 
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track ON track.track_id = il.track_id
JOIN album ON album.album_id = track.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = bsa.artist_id
GROUP BY 1,2,3,4
ORDER by 5 DESC;  
-- Q10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared retrun all genres.
WITH cte_popular_genre AS (
     SELECT COUNT(il.*) AS purchases, c.country, g.name, g.genre_id, 
	 ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS RowNo	
	 FROM invoice_line il
	 JOIN invoice i ON il.invoice_id = i.invoice_id
	 JOIN customer c ON i.customer_id = c.customer_id
	 JOIN track t ON t.track_id = il.track_id
	 JOIN genre g ON g.genre_id = t.genre_id
	 GROUP BY 2, 3, 4
	 ORDER BY 2 ASC, 1 DESC
)
SELECT * 
FROM cte_popular_genre
WHERE RowNo <= 1
ORDER BY purchases DESC
LIMIT 10; 
-- Q11. Write a query that determines the customer who has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
WITH CTE_spending_byCustomer AS(
     SELECT c.customer_id, c.first_name, c.last_name, i.billing_country, SUM(i.total) AS total_spending,
     ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(i.total) DESC) AS RowNo
     FROM customer c
     JOIN invoice i ON i.customer_id = c.customer_id
     GROUP BY 1, 2, 3,4
     ORDER BY 4 ASC, 5 DESC
)
SELECT * FROM CTE_spending_byCustomer 
WHERE RowNo <= 1; 

-- Best-selling artist
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
SELECT * FROM best_selling_artist;
