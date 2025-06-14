# [25-5W SQL 스터디] 5주차 공부 

## 정규 표현식 & 비트 연산자 개념정리 

### 정규 표현식

SQL에서 정규 표현식이란, **문자열에서 특정한 규칙(패턴)을 가진 문자를 찾기 위한 표현 방법**이다. 문자열을 필터링 하기 위한 도구라고 생각하면 되고, 원하는 형태로 문자열을 찾거나 치환하거나 추출할 때 사용을 자주한다. 

> SQL에서 정규 표현식이 필요한 이유?

LIKE, IN, = 과 같은 간단한 비교는 잘하지만, **복잡한 패턴을 매칭**하는 부분에서는 어렵다. 

ex) 전화번호 형식, 메일 형식으로 데이터를 찾고 싶다. 몇번째 문자는 대문자인 알파벳이면 좋다. 



#### REGEXP_LIKE()

REGEXP_LIKE() 는 문자열이 정규 표현식과 **일치하는지의 여부**를 검사해서 1또는 0을 반환한다.

- 1은 true 즉 일치를 말하고, 0은 일치하지 않음을 말한다. 
- 인자 중에 하나라도 NULL 값이 존재하면 NULL을 반환한다.

- 형식

  ~~~sql
  REGEXP_LIKE(expr, pattern [, match_type])
  ~~~

- match_type
  - c : 대소문자 구분
  - i : 대소문자 무시
  - m : 여러 줄 모드 (*줄바꿈은 ^,$에서 인식*)
  - n : `.`이 줄바꿈 문자를 포함하도록 설정
  - u : Unix 스타일로 줄바꿈만 인식 



#### REGEXP_REPLACE()

REGEXP_REPLACE()는 문자열에서 정규 표현식에 **일치하는 부분을 다른 문자열로 치환**하는 기능을 한다. 

~~~sql
REGEXP_REPLACE(expr, pattern, replacement [, pos [, occurrence [, match_type]]])
~~~

- pos : 검색의 시작 위치 (지정하지 않는다면 기본 값은 1로 시작)
- occurrence : 몇 번째의 일치를 치환할지 (기본값 0 : 일치하는 모든 값 **전부**)
- match_type : REGEXP_LIKE() 와 동일



#### REGEXP_SUBSTR()

REGEXP_SUBSTR()는 문자열에서 정규 표현식에 **일치하는 부분 문자열을 반환**한다. 

~~~sql
REGEXP_SUBSTR(expr, pattern [, pos [, occurrence [, match_type]]])
~~~

- pos : 검색의 시작 위치 (REGEXP_REPLACE와 동일)
- occurrence : (REGEXP_REPLACE와 동일)
- match_type : REGEXP_LIKE() 와 동일



#### Pattern Syntax

모든 함수에서 사용하는 **정규식 규칙**

| **패턴**  | **의미**                                       |
| --------- | ---------------------------------------------- |
| ^         | 문자열 시작                                    |
| $         | 문자열 끝                                      |
| .         | 임의 문자 (기본적으로 줄바꿈 제외)             |
| *         | 0개 이상 반복                                  |
| +         | 1개 이상 반복                                  |
| ?         | 0개 또는 1개                                   |
| {n}       | 정확히 n개 반복                                |
| {m,n}     | m개 이상 n개 이하 반복                         |
| [abc]     | a 또는 b 또는 c                                |
| [^abc]    | a, b, c를 제외한 문자                          |
| [a-z]     | 소문자 a부터 z까지                             |
| (abc)     | 그룹화                                         |
| `a        | b`                                             |
| [:digit:] | 숫자 클래스 (0-9)                              |
| \\        | 이스케이프 문자 (MySQL에서는 \\를 써야 \가 됨) |



### 비트연산자 

#### AND (`&`)

- 두 숫자의 비트가 **모두 1일 때만 1**, 아니면 0 
- 즉 공통된 비트만 남긴다. 

- 예시 

  ~~~mysql
  SELECT 29 & 15; -- 결과: 13
  -- 29: 11101
  -- 15: 01111
  -- AND: 01101 => 13
  ~~~



#### OR(`|`)

- 두 숫자의 비트 중에 **하나라도 1이면 1, 둘 다 0일때만 0을 반환**

- 예시

  ~~~mysql
  SELECT 29 | 15; -- 결과: 31
  -- 29: 11101
  -- 15: 01111
  -- OR : 11111 => 31
  ~~~



#### XOR(`^`)

- 두 숫자의 비트가 **다르면 1, 같으면 0** 을 반환

- 서로 다른 비트만 남긴다. 

- 예시

  ~~~mysql
  SELECT 11 ^ 3; -- 결과: 8
  -- 11: 1011
  --  3: 0011
  -- XOR: 1000 => 8
  ~~~



#### Left Shift(`<<`)

- 비트를 왼쪽으로 **N칸 이동** (오른쪽은 0으로 채움)

- 즉, 밑의 값만큼 곱한 효과가 나옴. 
  $$
  원래 비트 * 2^n
  $$

- 예시

  ~~~mysql
  SELECT 4 << 2; -- 결과: 16
  -- 4: 0100 → 왼쪽으로 2칸 → 0001 0000 → 16
  ~~~



#### Right Shift(`>>`)

- 비트를 오른쪽으로 **N칸 이동** (왼쪽은 0으로 채움)
- Left Shift 와 반대로 2의 n제곱만큼 나누는 효과

- 예시

  ~~~mysql
  SELECT 4 >> 2; -- 결과: 1
  -- 4: 0100 → 오른쪽으로 2칸 → 0001 → 1
  ~~~



---

## 정규 표현식 & 비트 연산자 문제풀이

### Q1. 서울에 위치한 식당 목록 출력하기

![alt text](../../image/Week5_1.png)

- 해결방법

서울에 위치한 식당들의 ID, 이름, 음식 종류, 즐겨찾기 수 ,주소, 평균 리뷰 점수를 구하되, 주소가 "서울"으로 시작하는 식당만 조회하도록 하는 내용이었다. 그래서 문제의 조건에 맞게 다 출력을 하되, 소수점 둘 째 짜리까지만 반올림하게 하기 위해 집계함수와 ROUND 함수를 두개를 사용했다. (아래에 ORDER BY를 사용해야함. )

그리고, 정규 표현식을 사용하기 위해 REGEXP_LIKE를 사용해서 주소가 서울로 시작하는 식당만 필터링할 수 있도록 했다. 

> 처음에는 문제의 예시에 서울특별시라고 하길래, 서울특별시를 입력했지만 지워보니 바로 실행이 되었었다. 

그 이후 단위의 그룹을 묶어주고, 정렬을 문제의 조건에 맞게 해주어 해결했다. 



### Q2. 부모의 형질을 모두 가지는 대장균 찾기 
![alt text](../../image/Week5_2.png)


- 해결방법

여기에서 주목해야 할 부분은 아래의 코드이다. 

`WHERE (e.GENOTYPE | d.GENOTYPE) = e.GENOTYPE`

문제에서 자식 균주의 GENOTYPE이 부모 균주의 형질을 모두 가져야 했다고 했기 때문에, 부모의 형질은 포함하면서 더 있을 수도 있기 때문에 OR 연산을 사용하여 부모 유전자형이 자식 유전자형의 부분집합인지를 판단하기 위한 조건을 제시했다. 그 이후에는 자식의 ID 기준으로 문제에 맞게 정렬하며 끝냈다. 

예를 들면 부모의 GENO TYPE이 0101(5) 이고, 자식이 1101(13) 이면 자식과 부모의 OR연산을 진행할 때 나오는 결과는 1101 이다. 즉 자식의 GENOTYPE과 동일하기 때문에 모두 포함하는지를 확인이 가능하다. 









