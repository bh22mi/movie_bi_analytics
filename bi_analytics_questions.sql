-- 🧠 BI-Style Analytical Queries

-- 1. Total ratings
SELECT COUNT(*) as total_ratings from fact_rating;

-- 2. Top 5 most-rated movies
SELECT dm.movie_name, COUNT(*) AS rating_count
FROM fact_rating fr
JOIN dim_movie dm USING (movie_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 3. Average rating per genre
SELECT dm.genre, ROUND(AVG(fr.rating), 2) AS average_rating
FROM fact_rating fr
JOIN dim_movie dm USING (movie_id)
GROUP BY 1;

-- 4. Monthly rating trends
SELECT dd.month_name, ROUND(AVG(fr.rating), 2) AS average_rating
FROM fact_rating fr
JOIN dim_date dd USING (date)
GROUP BY 1
ORDER BY 1;

-- 5. Top 3 users by count
SELECT du.user_name, COUNT(fr.rating)
FROM fact_rating fr
JOIN dim_user du USING (user_id)
GROUP BY fr.user_id
ORDER BY 2 DESC
LIMIT 3;

-- 6. Movie with highest avg rating (min 10 ratings)
SELECT dm.movie_name, ROUND(AVG(fr.rating),2), COUNT(*) AS rating_count
FROM fact_rating fr
JOIN dim_movie dm USING(movie_id)
GROUP BY fr.movie_id
HAVING COUNT(*) > 10
ORDER BY 2 DESC;

-- 7. Monthly trends for top 3 movies
WITH top_movies AS (
  SELECT movie_id
  FROM fact_rating
  GROUP BY movie_id
  ORDER BY COUNT(*) DESC
  LIMIT 3
)
SELECT dd.month_name, dm.movie_name, ROUND(AVG(fr.rating), 2)
FROM fact_rating fr
JOIN dim_movie dm ON fr.movie_id = dm.movie_id
JOIN dim_date dd ON fr.date = dd.date
WHERE fr.movie_id IN (SELECT movie_id FROM top_movies)
GROUP BY dd.month, dm.movie_name, dd.month_name
ORDER BY dm.movie_name, dd.month;

-- 8. Genre growth over time
WITH monthly_avg AS (
  SELECT dm.genre, dd.year, dd.month,
         CONCAT(dd.year, '-', LPAD(dd.month, 2, '0')) AS ym,
         ROUND(AVG(fr.rating), 2) AS average_rating
  FROM fact_rating fr
  JOIN dim_movie dm USING(movie_id)
  JOIN dim_date dd USING(date)
  GROUP BY 1, 2, 3
),
ranked AS (
  SELECT *,
         RANK() OVER (PARTITION BY genre ORDER BY ym) AS rank_asc,
         RANK() OVER (PARTITION BY genre ORDER BY ym DESC) AS rank_desc
  FROM monthly_avg
),
first_last AS (
  SELECT genre,
         MAX(CASE WHEN rank_asc = 1 THEN average_rating END) AS first_avg,
         MAX(CASE WHEN rank_desc = 1 THEN average_rating END) AS last_avg
  FROM ranked
  GROUP BY genre
)
SELECT genre, first_avg, last_avg,
       ROUND(last_avg - first_avg, 2) AS growth
FROM first_last
ORDER BY growth DESC;

-- 9. User’s top-rated genre
WITH user_genre_avg AS (
  SELECT fr.user_id, dm.genre, ROUND(AVG(fr.rating), 2) AS avg_rating
  FROM fact_rating fr
  JOIN dim_movie dm ON fr.movie_id = dm.movie_id
  GROUP BY fr.user_id, dm.genre
),
ranked_genres AS (
  SELECT *, RANK() OVER (PARTITION BY user_id ORDER BY avg_rating DESC) AS genre_rank
  FROM user_genre_avg
)
SELECT user_id, genre, avg_rating
FROM ranked_genres
WHERE genre_rank = 1;

-- 10. Rank movies by genre
SELECT genre, movie_name, avg_rating,
       RANK() OVER (PARTITION BY genre ORDER BY avg_rating DESC) AS genre_rank
FROM (
  SELECT dm.genre, dm.movie_name, ROUND(AVG(fr.rating),2) AS avg_rating
  FROM fact_rating fr
  JOIN dim_movie dm ON fr.movie_id = dm.movie_id
  GROUP BY fr.movie_id
) AS sub;
