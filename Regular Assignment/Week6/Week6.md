# [25-6W SQL 스터디] 6주차 공부 

## 종합 실전 문제 풀이 

### Q1. 복수 국적 메달 수상한 선수 찾기 

<!-- 문제 풀이 사진 -->

- **정답**

~~~mysql
SELECT a.name
FROM athletes a
JOIN records r ON a.id = r.athlete_id
JOIN teams t ON r.team_id = t.id
JOIN games g ON r.game_id = g.id
WHERE g.year >= 2000 AND r.medal IS NOT NULL
GROUP BY r.athlete_id
HAVING COUNT(DISTINCT t.id) > 1
ORDER BY a.name;
~~~

- **해결방법** 

먼저 문제에서는 선수 이름만 오름차순으로 정렬해서 출력하는데, **2000년 이후에** **메달을 받은 같은 선수가 서로 다른 국가로 메달을 수상한 경우**를 찾는것이다. 다음에 해당하는 조건은 아래의 조건에 해당한다. 

~~~mysql
year >= 2000 # 2000년 이후
medal IS NOT NULL # 메달을 받은
COUNT(DISTINCT id) > 1 # 서로 다른국가 2개 이상
~~~

이를 활용했고, 테이블간의 관계를 보자면 다음과 같다. 즉 문제를 풀기 위해서는 4개의 테이블에 다 join 연산이 필요했다. 

> athletes (a) : 선수 정보 (id, name)
>
> records (r) : medal 기록 및 연결 정보 
>
> teams (t) : 국가 정보 
>
> games (g) : 올림픽 연도 및 대회 정보 

각각에 대해 다 JOIN을 했고, WHERE 조건에 위의 조건을 활용해 **2000년 이후의 메달을 받은 기록만 필터링 할 수 있도록** 했고, 그 이후에 **선수 단위로** GROUP BY 묶어주었다. **DISTINCT**를 사용한 이유는 같은 선수가 **서로 다른 국적으로 메달을 수상한 경우**를 체크해주기 위함이다. DISTINCT를 사용할 때 중복을 제거해주기에 이를 활용해 복수 국적으로 메달을 수상한 것을 파악할 수 있었다. 마지막으로 문제의 조건에 선수들의 이름으로 **오름차순 정렬하여** 해결했다. 



### Q2. 온라인 쇼핑몰의 월 별 매출액 집계

<!-- 문제풀이 사진2 -->



- **정답**

~~~mysql
SELECT 
  strftime('%Y-%m', orders.order_date) AS order_month,
  SUM(CASE WHEN orders.order_id LIKE 'C%' THEN 0 ELSE price * quantity END) AS ordered_amount,
  SUM(CASE WHEN orders.order_id LIKE 'C%' THEN price * quantity ELSE 0 END) AS canceled_amount,
  SUM(price * quantity) AS total_amount
FROM orders
LEFT JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY order_month
ORDER BY order_month;
~~~

- **해결방법**

이 문제에서의 주로 해결해야할 포인트는 4가지이다.

**월별로 나타내기**, **정상 주문 금액, 취소 주문 금액, 총 주문 금액**을 구하고자 하는 것이다. 

먼저 월별로 나타내기 위해서는 `strftime` 을 사용해서 월별로까지만 포맷팅하여 출력되도록 하였다. 그리고 정상 주문과 취소 주문 금액에 대한 어떤 차이점이 있을지를 알아보기 위해 주문에 대한 전체 부분을 출력문을 실행하여 비교해보았다. 

> Order_id 가 C% 로 시작하는 경우는 취소 주문 금액으로 나왔다. 
>
> - Cancel 이 들어간 경우라고 이해를 했다. 

그 외에는 order_id 가 'C%' 로 시작하면 **취소된 주문**으로 간주해서 그 외는 정상 주문 금액으로 계산하도록 CASE THEN  조건을 사용하여 금액을 계산하였다. 

여기서 **LEFT JOIN**을 하였는데, **order가 존재하더라도 item**이 없을 경우가 있다고 생각하여서 그렇게 하였다. 마지막으로 문제의 조건에 맞게 월별로 묶고 `GROUP BY order_month` , 월별에 맞게 오름차순 정렬하여 `ORDER BY order_month`문제를 해결하였다. 



### Q3. 세 명이 서로 친구인 관계 찾기

<!-- 문제 풀이 사진3 -->



- **정답**

~~~mysql
WITH relation AS (
  SELECT e1.user_a_id AS a, e1.user_b_id AS b, e2.user_b_id AS c
  FROM edges e1
  JOIN edges e2 ON e1.user_b_id = e2.user_a_id
  JOIN edges e3 
    ON (
      (e3.user_a_id = e1.user_a_id AND e3.user_b_id = e2.user_b_id) OR
      (e3.user_b_id = e1.user_a_id AND e3.user_a_id = e2.user_b_id)
    )
)

SELECT a AS user_a_id, b AS user_b_id, c AS user_c_id
FROM relation
WHERE a < b AND b < c AND 3820 IN (a, b, c);
~~~



- **해결 방법**

edges 는 서로 친구인 **삼각형 관계**를 나타낸다. 그 중에서 3820 인 사용자가 같이 포함되어 있는 관계만 출력되야 하고, 그 중에서 중복을 제거하기 위해 `a < b < c` 라는 조건을 문제에서 제시해주었다. 

먼저 WITH 절을 보면 relation이라는 새로운 CTE를 제작했다. 그 내에서 같은 테이블을 한번 더 join 하면서 e1에서 A -> B , e2에서 B -> C 관계를 구성하여 A -> B -> C 의 경로를 만들도록 하였고, edge3를 한 번 더 join 함으로써 A와 C도 친구 사이인 것을 확인하도록 하였다. 

> 처음에는 한 번의 JOIN으로 할 수 있는 것으로 알았지만, 유효한 삼각형을 만들기 위해서는 A와 C 사이의 친구 사이의 관계가 있는 것을 확인할 수 있어야 했다.

그 이후는 메인 쿼리에서 문제의 조건에 맞게 (user_a_id)  형태로 컬럼 명칭을 지정해주고 , a < b < c 인 관계에 대해서 3820 이 그 그룹내에 있는지 `IN (a, b, c)` 를 활용해 해결했다. 









