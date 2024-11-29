# Fetch all the paintings which are not displayed on any museums?
SELECT * FROM WORK
WHERE museum_id is null;

# Are there museuems without any paintings? 
SELECT m.name 
FROM museum m
LEFT JOIN work w 
ON m.museum_id = w.museum_id
WHERE w.work_id IS NULL;

# How many paintings have an asking price of more than their regular price? 
SELECT COUNT(*) 
FROM product_size
WHERE sale_price>regular_price;

# Identify the paintings whose asking price is less than 50% of its regular price
SELECT COUNT(*) 
FROM product_size
WHERE sale_price < (0.50 * regular_price);

# The top 5 canva size which cost the most?
SELECT c.label, AVG(p.sale_price) AS avg_sale_price
FROM product_size p
LEFT JOIN canvas_size c ON c.size_id = p.size_id
GROUP BY c.label
ORDER BY avg_sale_price DESC
LIMIT 5;

# Identify the museums with invalid city information in the given dataset
SELECT *
FROM museum
WHERE city REGEXP '^[0-9]';

# Fetch the top 10 most famous painting subject   
SELECT subject, COUNT(*) 
FROM subject
GROUP BY subject
ORDER BY COUNT(*) DESC
LIMIT 10;

# Identify the museums which are open on both Sunday and Monday. Display museum name, city.
SELECT m.name, m.city
FROM museum m
JOIN museum_hours h ON m.museum_id = h.museum_id
WHERE h.day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city
HAVING COUNT(DISTINCT h.day) = 2;

# How many museums are open every single day?
SELECT COUNT(*) FROM
(SELECT museum_id
FROM museum_hours
GROUP BY museum_id
HAVING COUNT(day) =7) a;

# Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
SELECT m.name, COUNT(w.work_id) AS NumberOfPaintings
FROM museum m
LEFT JOIN work w ON m.museum_id = w.museum_id
GROUP BY m.name
ORDER BY NumberOfPaintings DESC
LIMIT 5;

# Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
SELECT a.full_name,COUNT(work_id) AS NumberOfPaintings
FROM artist a
LEFT JOIN work w
ON w.artist_id=a.artist_id
GROUP BY a.full_name
ORDER BY COUNT(work_id) DESC
LIMIT 5;

# Display the 30 least popular canva sizes
SELECT c.size_id, c.width, c.height, c.label, COUNT(p.work_id) AS NumberOfPaintings
FROM canvas_size c
LEFT JOIN product_size p ON p.size_id = c.size_id
GROUP BY c.size_id, c.width, c.height, c.label
HAVING COUNT(p.work_id) > 0
ORDER BY NumberOfPaintings ASC
LIMIT 30;

# Which museum has the most no of most popular painting style?
SELECT m.name,  w.style, COUNT(w.work_id) AS StyleCount
FROM museum m
LEFT JOIN work w 
ON w.museum_id = m.museum_id
WHERE w.style = (SELECT w.style 
                 FROM work w 
                 GROUP BY w.style 
                 ORDER BY COUNT(w.work_id) DESC 
                 LIMIT 1)
GROUP BY m.name, w.style
ORDER BY StyleCount DESC
LIMIT 1;

# Identify the artists whose paintings are displayed in multiple countries
SELECT a.full_name, COUNT(work_id)
FROM artist a
JOIN work w 
ON a.artist_id = w.artist_id
JOIN museum m 
ON w.museum_id = m.museum_id
GROUP BY a.artist_id, a.full_name
HAVING COUNT(DISTINCT m.country) > 1
ORDER BY a.full_name;

# Display the country with most no of museums.
SELECT country, COUNT(museum_id)
FROM museum
GROUP BY country
ORDER BY COUNT(museum_id) DESC
LIMIT 5;
