-- 문제1. 많이 주문한 테이블 찾기 
SELECT *
FROM tips
WHERE total_bill > (
  SELECT AVG(total_bill)
  FROM tips
);

-- 문제2. 레스토랑의 대목
SELECT t.*
FROM tips t
JOIN (
  SELECT day
  FROM tips
  GROUP BY day
  HAVING SUM(total_bill) >= 1500
) AS sub
ON t.day = sub.day;

-- 문제3. 식품 분류별 가장 비싼 식품의 정보 조회하기: 서브쿼리 문제풀이
SELECT CATEGORY, PRICE, PRODUCT_NAME
FROM FOOD_PRODUCT f
WHERE (CATEGORY, PRICE) IN (
    SELECT CATEGORY, MAX(PRICE)
    FROM FOOD_PRODUCT
    WHERE CATEGORY IN ('과자', '국', '김치', '식용유')
    GROUP BY CATEGORY
)
ORDER BY PRICE DESC;

-- 문제3. 식품 분류별 가장 비싼 식품의 정보 조회하기: WITH 문제풀이 
WITH CTE AS (
    SELECT CATEGORY, MAX(PRICE) AS Max_Price
    FROM FOOD_PRODUCT
    WHERE CATEGORY IN ('과자','국','김치','식용유')
    GROUP BY CATEGORY
)
SELECT f.CATEGORY, f.PRICE, f.PRODUCT_NAME
FROM FOOD_PRODUCT f
JOIN CTE c
    ON f.CATEGORY = c.CATEGORY AND f.PRICE = c.Max_Price
ORDER BY f.PRICE DESC;

