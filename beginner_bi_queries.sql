-- ✅ Beginner BI Queries

-- 1. Top 3 highest-rated movies
SELECT dm.movie_name, MAX(fr.rating)
FROM fact_rating fr
JOIN dim_movie dm ON fr.movie_id = dm.movie_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- 2. Most active users
SELECT du.user_id, COUNT(fr.rating)
FROM fact_rating fr
JOIN dim_user du ON fr.user_id = du.user_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- 3. Months with highest rating activity
SELECT dd.month_name, COUNT(fr.rating)
FROM fact_rating fr
JOIN dim_date dd ON fr.date = dd.date
GROUP BY 1
ORDER BY 2 DESC;

-- 4. Average rating per movie genre
SELECT dm.genre, AVG(fr.rating)
FROM fact_rating fr
JOIN dim_movie dm ON fr.movie_id = dm.movie_id
GROUP BY 1;

-- 5. User behavior by country
SELECT du.country, COUNT(fr.rating), AVG(fr.rating)
FROM fact_rating fr
JOIN dim_user du ON fr.user_id = du.user_id
GROUP BY 1;
