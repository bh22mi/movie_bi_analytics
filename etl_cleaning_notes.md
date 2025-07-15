# 📋 ETL Cleaning & Data Import Notes

## ✅ Data Cleaning

### Excel:
- Cleaned genre from JSON-style list
- Normalized release dates and durations
- Converted headers to lowercase and snake_case format

### Python:
- Cleaned nulls and malformed data
- Prepared `dim_movie`, `dim_user`, `dim_date`, `fact_rating` files
- Verified referential integrity for FK constraints

## ✅ Data Import

- All cleaned `.csv` files were **manually imported using MySQL Workbench Import Wizard**
- Imported into corresponding tables:
  - `dim_movie`
  - `dim_user`
  - `dim_date`
  - `staging_fact_rating`

### Note:
After importing into `staging_fact_rating`, valid rows were inserted into `fact_rating` using:

```sql
DELETE FROM staging_fact_rating
WHERE movie_id NOT IN (SELECT movie_id FROM dim_movie)
   OR user_id NOT IN (SELECT user_id FROM dim_user)
   OR date NOT IN (SELECT date FROM dim_date);

INSERT INTO fact_rating
SELECT * FROM staging_fact_rating;
```
