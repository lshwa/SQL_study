# [25-3W SQL 스터디] 3주차 공부 

## CASE문 & 비교, 논리 연산자 개념정리

### 흐름 제어 함수(Flow Control Functions)

| 이름     | 설명                             |
| -------- | -------------------------------- |
| CASE     | 조건에 따라 값을 반환하는 연산자 |
| IF()     | if-else 조건문                   |
| IFNULL() | NULL 검사 후에 대체 값을 반환    |
| NULLIF() | 두 값이 같으면 NULL 반환         |

아래에는 하나씩 자세히 보도록 하겠다. 

___

### CASE 연산자

CASE 연산은 크게 2가지로 나뉜다. 

**1. CASE VALUE 방식**

~~~sql
CASE value  
    WHEN compare_value THEN result  
    [WHEN compare_value THEN result ...]  
    [ELSE result]  
END;
~~~

value가 compare_value랑 비교하는 건데, 일차하는 경우에는 첫 번째 result를 반환하고, 일치하는 값이 없으면, ELSE에 있는 값을 반환한다.



**2. CASE WHEN condition 방식**

~~~sql
CASE  
    WHEN condition THEN result  
    [WHEN condition THEN result ...]  
    [ELSE result]  
END;
~~~

첫 번째 참인 condition이 result를 반환하고, 맞지 않으면 하나씩 아래로 내려가 condition들을 다 확인한다. 만약 다 일치하지 않을 때에는 ELSE result에서 값을 받는다. 

> ELSE 가 없을 땐 NULL 값을 반환한다. 
>
> 

---

### IF() 함수

프로그래밍에서의 IF 함수가 CASE WHEN, 즉 조건문이라고 인식하면 될 것 같고, SQL에서 IF() 함수는 문법이 다음과 같다. 

~~~sql
IF(expr1, expr2, expr3)
~~~

expr1이 참이면, expr2 , 둘 다 아니면 expr3을 반환하는 방식이다. 

> expr1이 0이 아니고, NULL이 아니라는 가정



---

### IFNULL() 함수

말 그래도, NULL이 아닌지, NULL인지를 판단해주는 함수이다. 문법은 다음과 같다.

~~~sql
IFNULL(expr1, expr2)
~~~

expr1이 NULL 이 아니면, expr1을 반환하고, 아니면(NULL) expr2를 반환한다.



---

### NULLIF() 함수

IFNULL() 함수와 헷갈릴 수 있는데, 이 함수에서는 expr간의 비교를 담당한다. 문법은 다음과 같다.

~~~sql
NULLIF(expr1, expr2)
~~~

expr1과 expr2 값이 같으면 NULL을 반환한다. 

그렇지 않으면 expr1을 반환한다.

 

---

## 반환 타입 결정 방식

CASE, IF, IFNULL, NULLIF 모두 반환 타임 결정하는 방식이 존재한다.  다음은 각 타입에 대해 설명이다.

1. 숫자 타입

- 모든 값이 숫자면 결과도 숫자
- 하나라도 DOUBLE이면 결과는 DOUBLE
- 하나라도 DECIMAL이면 결과는 DECIMAL
- 정수끼리 조합 시 더 넓은 타입으로 변환

> 타입이 존재할 때, 더 정교한 값을 가질 수 있는 타입으로 자동 캐스팅 되는 것을 알 수 있다. SQL도 프로그래밍 언어와 같음을 알 수 있다. 



2. 문자열 타입 

- 모두 CHAR, VARCHAR 면 최장 길이 기준 VARCHAR을 반환

> CHAR은 문자열 1개, VARCHAR(255) 처럼 VARCHAR은 문자열 길이를 조절 가능. 즉, VARCHAR로 더 큰 값으로 자동 캐스팅.
>
> -> 숫자 타입이랑 같은 원리임을 알 수 있음. 



3. 날짜 / 시간 타입

- DATE, TIME, TIMESTAMP는 그대로 유지한다.
- 혼합될 경우 DATETIME을 반환한다.

> DATETIME은 'YYYY-mm-dd- 시간-분-초' 까지 다 나옴. 즉, 제일 자세한 타입



**4. 기타 타입**(이 부분이 제일 헷갈리는 부분이다.)

- SET, ENUM -> VARCHAR
- JSON -> JSON
- GEOMETRY -> GEOMETRY
- BLOB이 포함되면 결과는 BLOB
- 혼합된 경우 기본적으로 VARCHAR을 반환



> SQL에도, ENUM, JSON, BLOB 형식 사용이 가능하다. 
>
> 사용방법은 더 자세히 공부해보고, 다시 올리도록 하겠다. 



---

* **번외**

1. SQL에서 ENUM 활용법

컬럼 정의시에 enum 컬럼에 들어갈 항목들을 정의한다. 

예시로는 다음 DDL 언어로 테이블 생성을 해보는 문법을 작성해보겠다. 

~~~sql
CREATE TABLE Dart_b (
    name VARCHAR(40),
    card_num ENUM('2기', '3기', '4기', '5기')
);
~~~

- enum 컬럼에도 NULL값 갑입 가능함. 
- 데이터 용량을 적게 차지한다는 장점. 문자열이 자동적으로 숫자로 인코딩되어 저장

> Index가 0이 아닌 1부터 시작하는것으로 보임.

- ORDER BY 를 ENUM 컬럼에 대해 하면 쿼리 효율이 너무 떨어진다. 
- 항목 변경하기 위해 스키마 변경이 필요함. 
- 대규모 데이터를 하기에는 트랜잭션의 원리로 따져볼 때 ENUM 컬럼의 사용은 최소화하는 것이 좋아보인다. 

- 다른 DBMS에 ENUM 타입을 받지 못하는 곳도 있어 사용을 안하는 게 좋다.



**요약**

MySQL에서 ENUM타입을 사용할 때는 JAVA의 ENUM 타입과 유사하게 사용하여 컬럼에 대한 정의를 할 때 사용하지만, 성능적인 면, 호환성 측면에서 좋지 않다. 안 사용하는 것이 좋다. 



---

## 비교 함수 및 연산자

### 기본 비교 연산자

비교 연산자는 두 개의 값을 비교해 참(1) 또는 거짓(0)을 반환한다. 다음과 같다. 이는 프로그래밍 언어 연산자랑 동일하다

| 연산자     | 설명                                     |
| ---------- | ---------------------------------------- |
| `>`        | 왼쪽 값이 오른쪽 값보다 크면 참          |
| `>=`       | 왼쪽 값이 오른쪽 값보다 크거나 같으면 참 |
| `<`        | 왼쪽 값이 오른쪽 값보다 작으면 참        |
| `<=`       | 왼쪽 값이 오른쪽 값보다 작거나 같으면 참 |
| `=`        | 두 값이 같으면 참                        |
| `<>`, `!=` | 두 값이 다르면 참                        |



---

### BETWEEN AND

영어 BETWEEN A AND B 와 같이 AND를 기준으로 양 옆의 사이의 값을 사용해 특정 값이 주어진 범위에 포함되는지 확인할 때 사용된다.  사용법은 다음과 같다

~~~sql
SELECT 10 BETWEEN 5 AND 15;  -- 결과: 1 (참)
SELECT 3 BETWEEN 5 AND 10;   -- 결과: 0 (거짓)
~~~

> NOT BETWEEN을 활용하면 참/거짓을 반대로 출력이 가능하다. 



---

### NULL-safe 비교연산자

NULL값을 포함한 비교에서 *=* 연산자는 NULL이 하나라도 표함되면 결과가 NULL값이 표시된다. 그렇기에 NULL 비교에도 명확한 값을 사용하기 위해 이 연산자를 사용한다. 문법은 다음과 같다.

~~~sql
SELECT NULL = NULL;  -- 결과: NULL (비교 불가능)
SELECT NULL <=> NULL;  -- 결과: 1 (NULL도 같다고 판단)
SELECT 1 <=> NULL;  -- 결과: 0 (NULL과 비교 시 항상 거짓)
~~~



---

### IN() 

주어진 값이 리스트 안에 포함되어 있는지 확인하는 연산자이다.

> 파이썬 문법과 같다.

~~~sql
SELECT 5 IN (1, 3, 5, 7);  -- 결과: 1 (참)
SELECT 'apple' IN ('banana', 'grape', 'apple'); -- 결과: 1 (참)
~~~

반대로 리스트 안에 없는지 확인하기 위해서는 NOT IN()을 활용하면 된다. 

- 주의사항

IN() 리스트에 NULL 값이 포함되면, 결과가 NULL이 될 수도 있다. 



---

### EXIST / NOT EXIST

서브쿼리 결과가 한 개 이상이면 참(1), 없으면 거짓(0)을 반환한다.

문법은 다음과 같다. 

~~~sql
SELECT EXISTS (SELECT * FROM users WHERE age > 30); -- 사용자가 있으면 1, 없으면 0
~~~



### COALESCE()

여러 개의 값 중에서 NULL 이 아닌 첫 번째 값을 반환한다. 

~~~sql
SELECT COALESCE(NULL, NULL, 5, 10); -- 결과: 5
SELECT COALESCE(NULL, 'Hello', 'World'); -- 결과: 'Hello'
~~~

- 주의사항

만약 모든 값이 NULL일 때ㅔ는 COALESCE()도 NULL을 반환한다. 



___

### GREATEST() / LEAST()

MAX 와 MIN 집계함수와 동일한 기능을 가지고 있다. 사용법은 다음과 같다

~~~sql
SELECT GREATEST(10, 25, 3, 8); -- 결과: 25
SELECT LEAST(10, 25, 3, 8); -- 결과: 3
~~~

- 주의사항

NULL값이 포함되어 있으면 결과는 NULL이 나오기 때문에 NULL이 있는지 아닌지 확인이 필요함.



---

### STRCMP()

문자열을 비교해서 결과를 반환하는 것이다. 

두 개의 문자열을 비교하는데 , 같으면 0 / 첫 번째 문자열이 작으면 -1 / 두번째 문자열이 작으면 1을 반환한다. 

~~~sql
SELECT STRCMP('apple', 'banana'); -- 결과: -1 ('apple'이 작음)
SELECT STRCMP('grape', 'banana'); -- 결과: 1 ('grape'가 큼)
SELECT STRCMP('apple', 'apple'); -- 결과: 0 (같음)
~~~



- 문자열 비교해서 큰 값 비교

MySQL에서 문자열 비교의 기준은 **사전순(lexicographical order, 사전식 순서)**를 사용한다. 즉, **알파벳 순서와 ASCII 코드 값**을 기반으로 비교가 이루어진다. 



---

## CASE문 & 논리 연산자 문제풀이

### Q1. 삼각형 종류 분류하기

<!-- Q1 이미지 첨가 -->



- 해결방법

삼각형의 판별 조건을 SQL의 CASE문으로 처리하는 부분이다. 단순히 문제에서 주어지는 세 변의 길이가 주어졌을 때 그 변의 길이의 조건을 검사하는 코드를 넣으면 된다. 

처음에 문제에서 출력하는 결과 순서대로 작성을 했지만, CASE - THEN에 대해서 조건 순서가 중요해서 두 번의 오답이 있었다. 

> 이등변 삼각형을 먼저 검사하고 나서 정삼각형을 검사하게 되면 정삼각형의 조건이 이등변 삼각형의 조건도 만족하기 때문에 순서를 잘 분류해야한다.

즉, **삼각형이 아닌 경우(Not A Triangle)** 부터 검사한 이후에, 삼각형에서 제일 작은 단계인 **정삼각형(Equilateral)**을 검사하고, 마지막으로 **이등변삼각형(Isosceles)**를 검사해야한다. 



---

### Q2. find-customer-referee

<!-- Q1 이미지 첨가 -->



- 해결방법

문제는 간단하게 referee_id가 2가 아닌 고객들의 이름을 출력하면 되는 것이였다. 따라서 referee_id가 NULL값이 아닌지 확인이 필요했고, 2가 아니면 되기 때문에 

~~~sql
WHERE referee_id NOT IN (2) OR referee_id IS NULL;
~~~

를 활용해 오답없이 한 번에 풀 수 있었다. 











