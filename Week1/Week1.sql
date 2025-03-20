-- Q1. Rank Score 답
SELECT score, DENSE_RANK() OVER (ORDER BY score DESC) AS `rank`
FROM Scores
ORDER BY score DESC;

-- Q2. 다음날도 서울숲의 미세먼지 농도는 나쁨
WITH RankTable AS (
    SELECT measured_at, pm10, 
      LEAD(measured_at) OVER (PARTITION BY station ORDER BY measured_at) AS next_day,
      LEAD(pm10) OVER (PARTITION BY station ORDER BY measured_at) AS next_pm10
    FROM measurements
    WHERE station = '서울숲'
)
SELECT measured_at AS today, next_day, pm10, next_pm10
FROM RankTable
WHERE pm10 < next_pm10
ORDER BY today;

-- Q3. 