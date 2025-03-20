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

-- Q3. 그룹별 조건에 맞는 식당 목록 출력하기
WITH RankTable AS (
    SELECT MEMBER_ID, COUNT(*) AS review_count
    FROM REST_REVIEW
    GROUP BY MEMBER_ID
)
SELECT m.MEMBER_NAME, r.REVIEW_TEXT, 
    DATE_FORMAT(r.REVIEW_DATE, '%Y-%m-%d') AS REVIEW_DATE
FROM MEMBER_PROFILE m
JOIN REST_REVIEW r 
    ON m.MEMBER_ID = r.MEMBER_ID
JOIN (
    SELECT DISTINCT MEMBER_ID
    FROM RankTable
    WHERE review_count = (SELECT MAX(review_count) FROM RankTable)
) max_members
    ON r.MEMBER_ID = max_members.MEMBER_ID
ORDER BY r.REVIEW_DATE ASC, r.REVIEW_TEXT ASC;

