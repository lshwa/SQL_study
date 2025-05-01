# [25-4W SQL 스터디] 4주차 공부 

## CTE, GROUP_CONCAT() 개념정리

### GROUP_CONCAT() 함수 

GROUP_CONCAT() : 이 함수는 **같은 그룹에 속한 값들을 연결(concatenate)**하여 하나의 문자열로 반환하는 함수이다. 주로, GROUP BY와 함께 사용하고 그룹별 데이터를 하나의 행으로 요약할 때 유용하다. 

<!-- concat 이미지 첨가 -->





~~~mysql
GROUP_CONCAT([DISTINCT] expr [, ...]
             [ORDER BY {unsigned_integer | col_name | expr} [ASC | DESC] [, ...]]
             [SEPARATOR str_val])
~~~

설명을 하면, 

- DISTINCT : 중복되는 값을 제거하고 고유한 값들만 연결해주는 기능 
- expr : 연결할 대상 컬럼이나 표현식, 여러개 사용 가능
- ORDER BY : 연결되는 값들의 정렬 순서를 지정할 수 있음.
- SEPARATOR : 기본 구분자는 쉼표(,) 이며, 원하는 구분자 (str_val)로 변경이 가능함.  



주의사항

- 반환되는 문자열 길이는 시스템 변수인 group_concat_max_len에 의해 제한 가능
- 길이를 늘리고 싶으면 아래처럼 사용 가능

~~~mysql
SET [SESSION | GLOBAL] group_concat_max_len = 값;
~~~



요약 (GROUP_CONCAT) 

> **같은 그룹의 여러 값을 하나의 문자열로 연결해주는 함수**이다. 예 : A, B, C -> 'A,B,C'

> **GROUP BY**와 함께 자주 사용한다. 



---

CONCAT 함수에 대해 복습을 한번 아래 진행해보았다. 

> CONCAT 함수의 특징: 함수 내부의 인자로 작성하여 인자와 인자 사이는 콤마로 구분하면 연결되어 출력함.

CONCAT 함수 참고사항

- CONCAT의 인수 중 하나라도, NULL 값이 들어가 있으면 그것은 NULL로 출력
- CONCAT 함수의 return 반환형은 string 타입 



---











---

## GROUP_CONCAT & CTE 문제풀이

### Q1. 우유와 요거트가 담긴 장바구니

<!-- Q1 답 -->







- 해결방법

먼저 문제의 조건에 맞게 WHERE 절에서 NAME에 우유와 요거트를 가지고 있는 상품의 행들만 가져올 수 있도록 하였다. 그리고 HAVING 절에서 GROUP_CONCAT을 사용해서 알파벳 순으로 정렬한 문자열을 생성하여 두 상품이 모두 존재할 때를 만족할 수 있도록 하였다. 

사실 이 문제는 GROUP_CONCAT 방식보다는 GROUP BY + HAVING 절을 사용하는 것이 더 바람직한 문제이다. GROUP_CONCAT 을 사용하는 것은 문자열을 결합하는 연산이 있기에 문자열 연산을 하는 진행에서 메모리 사용량이 훨 안좋은 상황이다. 따라서 위 문제와 같은 정확한 조건 체크를 가능하도록 하는 문제를 사용할 때는 `GROUP BY + HAVING ` 절을 사용해 단순 집계를 하는 것이 더 좋다. 단순히 GROUP BY + HAVING 절은 아래와 같이 사용할 수 있다. 

~~~mysql
SELECT CART_ID
FROM CART_PRODUCTS
WHERE NAME IN ('Milk', 'Yogurt')
GROUP BY CART_ID
HAVING COUNT(DISTINCT NAME) = 2
ORDER BY CART_ID;
~~~



