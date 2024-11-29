# Famous Paintings Data Analysis
![image](https://github.com/user-attachments/assets/726d1225-59d7-498e-aef7-7a84a32f477d)

## 📖 Project Overview
This repository explores the Famous Paintings Dataset sourced from Kaggle to answer key questions about artists, museums, and artworks. By analyzing this dataset, we gain insights into the art world, such as identifying prolific artists, comparing museum collections, and understanding artistic trends.

# 1. 🛠️ Defining the Question
We aim to explore the Famous Paintings Dataset to answer the following:

- Which artist has the most paintings in museums worldwide?
- What is the most common painting style exhibited in museums?
- Which artists have paintings displayed in multiple countries?
- Which country houses the highest number of museums?

# 2. 📊 Collecting the Data
The dataset used in this project is the Famous Paintings Dataset, sourced from Kaggle. It comprises multiple interconnected tables that provide detailed information about artists, paintings, museums, and related attributes. The key tables are:

### Artist: 
Contains details about artists, including their full names, nationality, artistic style, and lifespan.
- Key columns: artist_id, full_name, nationality, style

### Canvas Size: 
Describes the dimensions of painting canvases and their labels.
- Key columns: size_id, width, height, label

###  Image Link: 
Links to images of paintings, including URLs for small and large thumbnails.
- Key columns: work_id, url, thumbnail_small_url

### Museum: 
Provides data on museums where artworks are displayed, including their location and contact information.
- Key columns: museum_id, name, city, state, country

### Museum Hours: 
Lists the opening and closing times of museums by day.
- Key columns: museum_id, day, open, close

### Product Size: 
Links paintings to their dimensions and price information for sale or regular pricing.
- Key columns: work_id, size_id, sale_price

### Subject: 
Defines subjects associated with paintings, such as themes or categories.
- Key columns: work_id, subject

### Work: 
The main table for artworks, linking paintings to their artist, style, and museum.
- Key columns: work_id, name, artist_id, style, museum_id


# 3. 🧹 Cleaning the Data
Data cleaning involved using Excel to remove duplicate entries, ensuring the dataset was free from redundant records. 

# 4.🔍 Analyzing the Data
Using SQL queries, we analyzed the dataset to uncover:

### Fetch all the paintings which are not displayed on any museums?
```bash
SELECT * FROM WORK
WHERE museum_id is null;
```
![image](https://github.com/user-attachments/assets/ae29f669-5da7-4320-b3b3-bec5b0ef549c)

### Are there museuems without any paintings? 
```bash
SELECT m.name 
FROM museum m
LEFT JOIN work w 
ON m.museum_id = w.museum_id
WHERE w.work_id IS NULL;
```
![image](https://github.com/user-attachments/assets/41734bd8-567c-47c8-b9f3-20729ce306ce)

### How many paintings have an asking price of more than their regular price? 
```bash
SELECT COUNT(*) 
FROM product_size
WHERE sale_price>regular_price;
```
![image](https://github.com/user-attachments/assets/148998cc-6e0a-44fd-beb7-ceca705bb9bb)

### Identify the paintings whose asking price is less than 50% of its regular price
```bash
SELECT COUNT(*) 
FROM product_size
WHERE sale_price < (0.50 * regular_price);
```
![image](https://github.com/user-attachments/assets/ee9b5edd-6247-4bc9-aa4f-dfa4576ead4c)

### The top 5 canva size which cost the most?
```bash
SELECT c.label, AVG(p.sale_price) AS avg_sale_price
FROM product_size p
LEFT JOIN canvas_size c ON c.size_id = p.size_id
GROUP BY c.label
ORDER BY avg_sale_price DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/d84d3302-5a97-4e8c-90fc-665371f3e974)

### Identify the museums with invalid city information in the given dataset
```bash
SELECT *
FROM museum
WHERE city REGEXP '^[0-9]';
```
![image](https://github.com/user-attachments/assets/4ead0517-9862-436c-bae8-bc8dc85fd90a)

### Fetch the top 10 most famous painting subject   
```bash
SELECT subject, COUNT(*) 
FROM subject
GROUP BY subject
ORDER BY COUNT(*) DESC
LIMIT 10;
```
![image](https://github.com/user-attachments/assets/42ef90de-b8eb-420f-9e1e-bffbe4d48c6f)

### Identify the museums which are open on both Sunday and Monday. Display museum name, city.
```bash
SELECT m.name, m.city
FROM museum m
JOIN museum_hours h ON m.museum_id = h.museum_id
WHERE h.day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city
HAVING COUNT(DISTINCT h.day) = 2;
```
![image](https://github.com/user-attachments/assets/c13f72e3-e3c3-4f3c-974b-7fff562258c5)

### How many museums are open every single day?
```bash
SELECT COUNT(*) FROM
(SELECT museum_id
FROM museum_hours
GROUP BY museum_id
HAVING COUNT(day) =7) a;
```
![image](https://github.com/user-attachments/assets/d214cbc5-fa4e-4384-a697-52bd4361a8a4)

### Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
```bash
SELECT m.name, COUNT(w.work_id) AS NumberOfPaintings
FROM museum m
LEFT JOIN work w ON m.museum_id = w.museum_id
GROUP BY m.name
ORDER BY NumberOfPaintings DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/40680456-fe41-4b4a-bf17-bcb89c2312ad)

### Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
```bash
SELECT a.full_name,COUNT(work_id) AS NumberOfPaintings
FROM artist a
LEFT JOIN work w
ON w.artist_id=a.artist_id
GROUP BY a.full_name
ORDER BY COUNT(work_id) DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/05dd1ba1-6ef1-4216-9860-7930cf95fa7d)

### Display the 30 least popular canva sizes
```bash
SELECT c.size_id, c.width, c.height, c.label, COUNT(p.work_id) AS NumberOfPaintings
FROM canvas_size c
LEFT JOIN product_size p ON p.size_id = c.size_id
GROUP BY c.size_id, c.width, c.height, c.label
HAVING COUNT(p.work_id) > 0
ORDER BY NumberOfPaintings ASC
LIMIT 30;
```
![image](https://github.com/user-attachments/assets/2f213b31-2580-43b5-9ea1-d9e61a69e763)

### Which museum has the most no of most popular painting style?
```bash
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
```
![image](https://github.com/user-attachments/assets/2dc82477-0f6b-4713-8e83-a141af30ab79)

### Identify the artists whose paintings are displayed in multiple countries
```bash
SELECT a.full_name, COUNT(work_id)
FROM artist a
JOIN work w 
ON a.artist_id = w.artist_id
JOIN museum m 
ON w.museum_id = m.museum_id
GROUP BY a.artist_id, a.full_name
HAVING COUNT(DISTINCT m.country) > 1
ORDER BY a.full_name;
```
![image](https://github.com/user-attachments/assets/3211161b-1984-417e-abfa-72dee1268fd9)

### Display the country with most no of museums.
```bash
SELECT country, COUNT(museum_id)
FROM museum
GROUP BY country
ORDER BY COUNT(museum_id) DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/8fd9ec75-ad5b-47fa-a1e4-e91a1339182c)

# 5. 🙏 Acknowledgment  

We would like to express our gratitude to [techTFQ](https://www.youtube.com/@techTFQ) for their insightful content, which served as a significant source of inspiration for this project.
