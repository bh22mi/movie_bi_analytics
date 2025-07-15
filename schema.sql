USE movie_schema;

CREATE TABLE dim_movie (
  movie_id INT PRIMARY KEY,
  movie_name VARCHAR(50),
  genre VARCHAR(20),
  release_date DATE,
  duration_mins INT,
  average_rating DOUBLE,
  rating_count DOUBLE
);

CREATE TABLE dim_user (
  user_id INT PRIMARY KEY,
  user_name varchar(50),
  gender varchar(10),
  country varchar(20)
);

CREATE TABLE dim_date (
  date DATE PRIMARY KEY,
  year INT,
  month INT,
  month_name varchar(10),
  quarter varchar(10),
  week_number INT
);

CREATE TABLE fact_rating (
  rating_id INT PRIMARY KEY AUTO_INCREMENT,
  movie_id INT,
  user_id INT,
  date DATE,
  rating DOUBLE,
  FOREIGN KEY (movie_id) REFERENCES dim_movie(movie_id),
  FOREIGN KEY (user_id) REFERENCES dim_user(user_id),
  FOREIGN KEY (date) REFERENCES dim_date(date)
);

CREATE TABLE staging_fact_rating (
  rating_id INT,
  movie_id INT,
  user_id INT,
  date DATE,
  rating FLOAT
);

DELETE FROM staging_fact_rating
WHERE movie_id NOT IN (SELECT movie_id FROM dim_movie)
   OR user_id NOT IN (SELECT user_id FROM dim_user)
   OR date NOT IN (SELECT date FROM dim_date);

INSERT INTO fact_rating
SELECT * FROM staging_fact_rating;
