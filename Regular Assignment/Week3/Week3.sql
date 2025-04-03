-- Q1. 삼각형 종류 분류하기 답 
SELECT 
    CASE 
        WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
        WHEN A = B AND B = C THEN 'Equilateral'
        WHEN A = B OR A = C OR B = C THEN 'Isosceles'
        ELSE 'Scalene'
    END AS Triangle_type
FROM TRIANGLES;

-- Q2. fine-customer-referee 답
SELECT name 
FROM Customer 
WHERE referee_id NOT IN (2) OR referee_id IS NULL;
