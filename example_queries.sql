-- 📌 Example SQL Queries

-- 1. INNER JOIN — Get Movie Name, User Name, Rating
SELECT DISTINCT dm.movie_name, du.user_name, fr.rating
FROM fact_rating fr
JOIN dim_movie dm ON fr.movie_id = dm.movie_id
JOIN dim_user du ON fr.user_id = du.user_id;

-- 2. LEFT JOIN — Show All Ratings (Even If User Info Missing)
SELECT fr.rating_id, fr.rating, du.user_id
FROM fact_rating fr
LEFT JOIN dim_user du ON fr.user_id = du.user_id;

-- 3. Ratings by Month
SELECT dd.month, COUNT(fr.rating_id) AS total_ratings
FROM fact_rating fr
JOIN dim_date dd ON fr.date = dd.date
GROUP BY dd.month;
