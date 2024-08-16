-- 함수 : 컬럼값 | 지정된값을 읽어 연산한 결과를 반환하는 것

-- 단일행 함수 : N개의 행의 컬럼 값을 전달하여 N개의 결과가 반환

-- 그룹 함수  : N개의 행의 컬럼 값을 전달하여 1개의 결과가 반환
--			  (그룹의 수가 늘어나면 그룹의 수 만큼 결과를 반환)

-- 함수는 SELECT절, WHERE절, ORDER BY절
--      GROUP BY절, HAVING절에서 사용 가능



/********************* 단일행 함수 *********************/

-- <문자열 관련 함수>

-- LENGTH(문자열|컬럼명) : 문자열의 길이 반환
SELECT 'HELLO WORLD', LENGTH('HELLO WORLD') 
FROM DUAL; -- DUMMY TABLE(가상/가짜 테이블)

-- EMPLOYEE 테이블에서
-- 사원명, 이메일, 이메일 길이 조회
-- 단, 이메일 길이가 12 이하인 행만 
-- 이메일 길이 오름차순 조회 
SELECT EMP_NAME, EMAIL, LENGTH(EMAIL)
FROM EMPLOYEE
WHERE LENGTH(EMAIL) <= 12
ORDER BY LENGTH(EMAIL) ASC;

----------------------------------------------------------

-- INSTR(문자열 | 컬럼명, '찾을 문자열' [, 찾을 시작 위치 [, 순번]]) 

-- 찾을 시작 위치부터 지정된 순번째 찾은 문자열의 시작 위치를 반환

-- 문자열에서 맨 앞에있는 'B'의 위치를 조회
SELECT 'AABAACAABBAA', INSTR('AABAACAABBAA', 'B') 
FROM DUAL; -- 3 (INDEX 아님, 1부터 시작하는 COUNT 개념)

-- 문자열에서 5번 부터 검색 시작해서 처음 찾은 'B'의 위치 조회
SELECT 'AABAACAABBAA', 
			 INSTR('AABAACAABBAA', 'B', 5)
FROM DUAL; -- 9


-- 문자열에서 5번 부터 검색 시작해서 두번째로 찾은 'B'의 위치 조회
SELECT 'AABAACAABBAA', 
			 INSTR('AABAACAABBAA', 'B', 5, 2)
FROM DUAL; -- 10

-----------------------------------------------------------

-- SUBSTR(문자열 | 컬럼명, 시작위치 [,길이])

-- 문자열을 시작 위치부터 지정된 길이 만큼 잘라내서 반환
-- 길이 미작성 시 시작 위치 부터 끝까지 잘라내서 반환

-- 시작 위치 + 길이 지정
SELECT SUBSTR('ABCDEFG', 2, 3)
FROM DUAL; -- BCD

-- 시작위치만 지정
SELECT SUBSTR('ABCDEFG', 4)
FROM DUAL; -- DEFG


-- SUBSTR() + INSTR() 같이 사용하기

-- EMPLOYEE 테이블에서 
-- 사원명, 이메일 아이디 (@ 앞에까지 문자열)를
-- 이메일 아이디 오름차순으로 조회
SELECT 
	EMP_NAME,
	SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) "이메일 아이디"
FROM EMPLOYEE
ORDER BY "이메일 아이디" ASC;

---------------------------------------------------------

-- TRIM([ [옵션] 문자열 | 컬럼명 FROM ] 문자열 | 컬럼명)
-- 주어진 문자열의 앞쪽|뒤쪽|양쪽에 존재하는 지정된 문자열을 제거

-- 옵션 : LEADING(앞쪽), TRAILING(뒤쪽), BOTH(양쪽, 기본값)

-- 문자열 앞/뒤/양쪽 공백 제거
SELECT '   기  준   ',
	TRIM(LEADING  ' ' FROM '   기  준   '),
	TRIM(TRAILING ' ' FROM '   기  준   '),
	TRIM(BOTH     ' ' FROM '   기  준   ')
FROM DUAL;

-- 문자열 앞/뒤/양쪽 특정 문자 제거
SELECT '##@기  준@##',
	TRIM(LEADING  '#' FROM '##@기  준@##'),
	TRIM(TRAILING '#' FROM '##@기  준@##'),
	TRIM(BOTH     '#' FROM '##@기  준@##')
FROM DUAL;

---------------------------------------------------

-- REPLACE(문자열 | 컬럼명, 찾을 문자열, 바꿀 문자열)

SELECT 
	NATIONAL_NAME, 
	REPLACE(NATIONAL_NAME, '한국', '대한민국')
FROM "NATIONAL";  -- "테이블명" == 이름이 "테이블명"과 같은 테이블

--------------------------------------------------------
--------------------------------------------------------
--------------------------------------------------------

-- <숫자 관련 함수>

-- MOD(숫자 | 컬럼명, 나눌 값) : 결과로 나머지 반환
SELECT MOD(105, 100) FROM DUAL; -- 5

-- ABS(숫자 | 컬럼명) : 절대 값
SELECT ABS(10), ABS(-10) FROM DUAL; -- 10, 10

-- CEIL(숫자 | 컬럼명)  : 올림 -> 정수 형태로 반환
-- FLOOR(숫자 | 컬럼명) : 내림 -> 정수 형태로 반환
SELECT CEIL(1.1), FLOOR(1.9) FROM DUAL; -- 2, 1

-- ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
-- 소수점 위치 지정 x : 소수점 첫째 자리에서 반올림 -> 정수 표현
-- 소수점 위치 지정 O
 -- 1) 양수 : 지정된 위치의 소수점 자리까지 표현
 -- 2) 음수 : 지정된 위치의 정수 자리까지 표현

SELECT
	123.456,
	ROUND(123.456),  -- 123
	ROUND(123.456, 0),  -- 123 (0이 ROUND 기본값)
	ROUND(123.456, 1),  -- 123.5
	ROUND(123.456, 2),  -- 123.46
	ROUND(123.456, -1), -- 120
	ROUND(123.456, -2)  -- 100
FROM DUAL;



-- TRUNC(숫자 | 컬럼명 [,소수점 위치]) : 버림 (잘라내기)
SELECT 
	123.456,
	TRUNC(123.456), -- 123
	TRUNC(123.456, 1) -- 123.4  (둘째 자리부터 버림)
FROM DUAL;


-- 버림(TRUNC), 내림(FLOOR) 차이점
SELECT 
	-123.5,
	TRUNC(-123.5), -- -123
	FLOOR(-123.5)  -- -124
FROM DUAL;


---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

-- <날짜 관련 함수>
-- SYSDATE : 현재 시간 (시스템, DB가 설치된 컴퓨터 기준)
-- SYSTIMESTAMP : 현재 시간 (ms 포함, 표준시간대)

-- CURRENT_DATE (접속한 계정)
-- CURRENT_TIMESTAMP
SELECT 
	SYSDATE, SYSTIMESTAMP,
	CURRENT_DATE, CURRENT_TIMESTAMP	
FROM DUAL;


-- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜 사이의 개월 수를 반환
--> 반환 값 중 정수 부분은 차이나는 개월 수

SELECT 
	MONTHS_BETWEEN( TO_DATE('2024-09-16', 'YYYY-MM-DD'), 
									CURRENT_DATE)
FROM DUAL; -- 1(달)

-- ** ORACLE은 자료형이 맞지 않은 상황이라도
--    작성된 값의 형태가 요구하는 자료형의 형태를 띄고 있으면
--    자동으로 형변환(PARSING)을 진행한다!!

SELECT
	MONTHS_BETWEEN('2024-12-06', '2024-06-24'),
	(TO_DATE('2024-12-06') - TO_DATE('2024-06-24')) / 30
FROM DUAL; -- 5.42 == 5개월 13일

/* MONTH_BETWEEN이 지정되 두 날짜 사이의 차를 계산할 때 
 * 훨씬 좋다!!(더 정확함)
 * -> 달 마다 길이(28, 29, 30, 31)가 다 다르기 때문에
 *    직접 계산하면 오차가 있을 수 있는데
 * 		MONTH_BETWEEN을 이용하면 이런 부분까지 모두
 *    자동으로 적용되어 계산된다!!
 * */

-- EMPLOYEE 테이블에서
-- 모든 사원의 이름, 입사일, N년차 조회
SELECT 
	EMP_NAME, 
	HIRE_DATE,
	CEIL( MONTHS_BETWEEN(CURRENT_DATE, HIRE_DATE) / 12 ) 
	|| '년차' AS "N년차"
FROM EMPLOYEE;

----------------------------------------

-- ADD_MONTHS(날짜, 숫자) : 날짜를 숫자만큼의 개월 수를 더하여 반환
SELECT 
	CURRENT_DATE,      -- 8/16
	CURRENT_DATE + 31, -- 9/16
	CURRENT_DATE + 61,  -- 10/16
	ADD_MONTHS(CURRENT_DATE, 1), -- 9/16
	ADD_MONTHS(CURRENT_DATE, 2)  -- 10/16
FROM DUAL;


-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 반환
SELECT 
	LAST_DAY(CURRENT_DATE),
	LAST_DAY('2024-09-01')
FROM DUAL;

-- 다음달 1일, 다음달 말일, 다음달 일 수 조회하기
SELECT 
	LAST_DAY(CURRENT_DATE) + 1 "다음달 1일",
	LAST_DAY( ADD_MONTHS(CURRENT_DATE, 1) ) "다음달 말일",
	
	LAST_DAY( ADD_MONTHS(CURRENT_DATE, 1) )
		- LAST_DAY(CURRENT_DATE)
FROM DUAL;

------------------------------------------------

-- EXTRACT(YEAR | MONTH | DAY  FROM  날짜)

-- (EXTRACT : 뽑아내다, 추출하다)

-- 지정된 날짜의 년 | 월 | 일을 추출하여 정수로 반환

SELECT
	EXTRACT(YEAR  FROM CURRENT_DATE) 년, 
	EXTRACT(MONTH FROM CURRENT_DATE) 월, 
	EXTRACT(DAY   FROM CURRENT_DATE) 일
FROM DUAL;

-- EMPLOYEE에서
-- 2010년대에 입사한 사원의
-- 사번, 이름, 입사일을 입사일 내림차순으로 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
--WHERE HIRE_DATE BETWEEN '2010-01-01' AND '2019-12-31'
WHERE EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 2010 AND 2019
ORDER BY HIRE_DATE DESC; -- 10행 조회


---------------------------------------------------------

-- <형변환(Parsing) 함수>

-- 문자열(CHAR, VARCHAR2) <-> 숫자(NUMBER)
-- 문자열(CHAR, VARCHAR2) <-> 날짜(DATE)
-- 숫자(NUMBER) --> 날짜(DATE)


/* TO_CHAR(날짜 | 숫자 [, 포맷]) : 문자열로 변환
 * 
 * 숫자 -> 문자열
 * 포맷 
 * 1) 9 : 숫자 한 칸을 의미, 오른쪽 정렬
 * 2) 0 : 숫자 한 칸을 의미, 오른쪽 정렬, 빈 칸에 0을 추가
 * 3) L : 현재 시스템이나 DB에 설정된 나라의 화폐 기호
 * 4) , : 숫자의 자릿수 구분
 * */


-- 숫자 -> 문자열 변환 확인
SELECT 1234, TO_CHAR(1234) FROM DUAL;

-- 지정된 칸 내부에서 문자열로 변환하기
SELECT 1234, TO_CHAR(1234, '999999999')
FROM DUAL; -- '    1234'

SELECT 1234, TO_CHAR(1234, '000000000')
FROM DUAL; -- '000001234'

/* 숫자 -> 문자열 변환 시 발생할 수 있는 문제 상황 */
--> 지정된 포맷의 칸 수가 변환하려는 숫자 자릿수 보다 적은 경우 
--  모든 숫자가 #으로 변환되서 출력

SELECT 1234, TO_CHAR(1234, '999') -- ####
FROM DUAL;

-- 자릿수 구분(,)
SELECT 123456789, TO_CHAR(123456789, '999,999,999')
FROM DUAL;

-- 화폐 기호 + 자릿수 구분
SELECT 
	123456789, 
	TO_CHAR(123456789, 'L999,999,999'),
	TO_CHAR(123456789, '$999,999,999')
FROM DUAL;

-- 모든 사원의 연봉을
-- \OOO,OOO,OOO으로 조회
SELECT 
	EMP_NAME,
	TO_CHAR(SALARY * 12, 'L999,999,999') 연봉
FROM EMPLOYEE;

------------------------------------------------

/* 날짜 -> 문자열
 * 
 * YY    : 년도(짧게) EX) 24
 * YYYY  : 년도(길게) EX) 2024
 * 
 * RR    : 년도(짧게) EX) 24
 * RRRR  : 년도(길게) EX) 2024
 * 
 * MM : 월
 * DD : 일
 * 
 * AM/PM : 오전/오후
 * 
 * HH   : 시간 (12시간)
 * HH24 : 시간 (24시간)
 * MI   : 분
 * SS   : 초
 * 
 * DAY : 요일(전체) EX) 월요일, MONDAY
 * DY  : 요일(짧게) EX) 월, MON
 * */


-- 오늘 날짜 YYYY/MM/DD 문자열로 변환
SELECT TO_CHAR(CURRENT_DATE, 'YYYY/MM/DD')
FROM DUAL;

-- '2024-08-16 금요일'
SELECT TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD DAY')
FROM DUAL;

-- '2024.08.16 (금) 오후 14:10:12'
SELECT TO_CHAR(CURRENT_DATE, 'YYYY.MM.DD (DY) PM HH24:MI:SS')          
FROM DUAL;


--  /, (), :, - 는 일반적으로 날짜 표기 시 사용하는 기호
--> 패턴으로 인식되어 오류가 발생하지 않음!

-- '24년 08월 16일 금요일 오후 2시 15분 30초'
SELECT
	TO_CHAR(CURRENT_DATE,
		'YY"년" MM"월" DD"일" DAY PM HH"시" MI"분" SS"초"')
FROM DUAL;
-- SQL Error [1821] [22008]: ORA-01821:
--  날짜 형식이 부적합합니다
--> 년,월,일,시,분,초는 시간 관련 기호로 인식되지 않아서 오류 발생!!

--> [해결방법] : ""로 감싸서 패턴을 나타내는 기호가 아닌
--             있는 그대로 출력하는 글자임을 명시


------------------------------------------------------


-- TO_DATE(문자열 | 숫자 [, 포맷])

-- 문자열 또는 숫자를 날짜 형식으로 변환

SELECT 
	'2024-08-16' 문자열,
	TO_DATE('2024-08-16') 날짜
FROM DUAL;
-- TO_DATE에 매개 변수가 한 개만 작성될 수 있는 경우
  --> () 내부 문자열이 일반적인 날짜/시간 형식일 경우에만 가능

-- 일반적인 형식이 아닌 경우 포맷 지정 필수!!!
SELECT TO_DATE('16082024', 'DDMMYYYY')
FROM DUAL;


SELECT 
	TO_DATE('24년 08월 16일 금요일 오후 2시 15분 30초',
		'YY"년" MM"월" DD"일" DAY PM HH"시" MI"분" SS"초"')
FROM DUAL;


/*** 연도 패턴  Y, R 차이점 ***/

-- 연도가 두 자리만 작성되어있는 경우
-- 50 미만 : Y,R 둘 다 누락된 연도 앞부분에 현재 세기(21C == 2000년대) 추가
-- 50 이상 : Y : 현재 세기(2000년대) 추가
--		      R : 이전 세기(1900년대) 추가

-- 50 미만 확인
SELECT 
	TO_DATE('49-12-25', 'YY-MM-DD'), -- 2049
	TO_DATE('49-12-25', 'RR-MM-DD')  -- 2049
FROM DUAL;

-- 50 이상 확인
SELECT 
	TO_DATE('50-12-25', 'YY-MM-DD'), -- 2050
	TO_DATE('50-12-25', 'RR-MM-DD')  -- 1950
FROM DUAL;

-------------------------------------------------


-- TO_NUMBER(문자열 [,패턴]) : 문자열 -> 숫자 변환

SELECT TO_NUMBER('$1,500', '$9,999')
FROM DUAL;

-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------

-- <NULL 처리 연산> : IS NULL / IS NOT NULL


-- <NULL 처리 함수>
-- NVL(컬럼명, 컬럼 값이 NULL일 경우 변경할 값)

-- EMPLOYEE 테이블에서
-- 사번, 이름, 전화번호 조회
-- 단, 전화번호가 없다면(NULL) '없음' 으로 조회
SELECT 
	EMP_ID, 
	EMP_NAME, 
	NVL(PHONE, '없음') AS PHONE
FROM 
	EMPLOYEE;


/* NULL과 산술 연산 시 결과는 무조건 NULL!!! */

-- EMPLOYEE 테이블에서
-- 이름, 급여, 보너스, 급여 * 보너스 조회
-- 단, 보너스가 없다면 0으로 계산
SELECT 
	EMP_NAME,
	SALARY,
	NVL(BONUS, 0) AS BONUS,
	SALARY * NVL(BONUS, 0) AS 곱셈결과
FROM 
	EMPLOYEE;


-------------------------------------------------

-- NVL2(컬럼명, NULL이 아닌 경우 변경할 값, 
--             NULL인 경우 변경할 값)

-- EMPLOYEE 테이블에서
-- 사번, 이름, 전화번호 조회
-- 전화 번호가 없으면 '없음'
-- 전화 번호가 있으면 '010********' 형식으로 변경해서 조회

-- RPAD(문자열, 길이, 바꿀문자)
--  : 문자열 전체에서 오른쪽을 지정된 길이 만큼 다른 문자로 변경\
SELECT
	EMP_ID,
	EMP_NAME,
	NVL2(PHONE, 
		   RPAD(SUBSTR(PHONE,1,3), LENGTH(PHONE), '*'), 
		  '없음') AS "전화번호"
FROM EMPLOYEE;


------------------------------------------------------

-- <선택 함수>
-- 여러 가지 경우에 따라 알맞은 결과를 선택하는 함수
-- (if, switch문과 비슷)


-- DECODE(컬럼명 | 계산식, 조건1, 결과1, 조건2, 결과2, ... [,아무것도 만족 X])

-- 컬럼명 | 계산식의 값이 일치하는 조건이 있으면
-- 해당 조건 오른쪽에 작성된 결과가 반환된다.


-- EMPLOYEE 테이블에서 
-- 모든 사원의 이름, 주민등록번호, 성별 조회
SELECT
	EMP_NAME,
	EMP_NO,	
	DECODE( SUBSTR(EMP_NO, 8, 1), 
		'1', '남자', '2', '여자') AS "성별"
FROM EMPLOYEE; 


-- EMPLOYEE 테이블에서
-- 직급코드가 'J7'인 직원은 급여 + 급여의 10%
-- 직급코드가 'J6'인 직원은 급여 + 급여의 15%
-- 직급코드가 'J5'인 직원은 급여 + 급여의 20%
-- 나머지 직급코드의 직원은 급여 + 급여의 5%  지급
-- 사원명, 직급코드, 기존급여, 지급급여 조회

SELECT 
	EMP_NAME,
	JOB_CODE,
	SALARY "기존급여",
	DECODE(JOB_CODE,
		'J7', SALARY * 1.1, 
		'J6', SALARY * 1.15,
		'J5', SALARY * 1.2,
		      SALARY * 1.05
	) "지급급여"
FROM EMPLOYEE;

---------------------------------------------

-- CASE 
--	  WHEN 조건1 THEN 결과1
--	  WHEN 조건2 THEN 결과2
--	  WHEN 조건3 THEN 결과3
--	  ELSE 결과
-- END

-- DECODE는 계산식|컬럼 값이 딱 떨어지는 경우에만 사용 가능.
-- CASE는 계산식|컬럼 값을 범위로 지정할 수 있다. 


-- EMPLOYEE 테이블에서 사번, 이름, 급여, 구분을 조회
-- 구분은 받는 급여에 따라 초급, 중급, 고급으로 조회
-- 급여 600만 이상 = '고급'
-- 급여 400만 이상 ~ 600만 미만 = '중급'
-- 급여 400미만 = '초급'
-- 단, 부서코드가 D6, D9인 사원만 직급코드 오름차순으로 조회

SELECT
	EMP_ID 사번,
	EMP_NAME 이름,
	SALARY 급여,
	CASE
		WHEN SALARY >= 6000000 THEN '고급'
		WHEN SALARY >= 4000000 THEN '중급'
		ELSE '초급'
	END 구분
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6', 'D9')
ORDER BY JOB_CODE ASC;


-------------------------------------------------------------

/************* 그룹 함수 *************/

--  N개의 행의 컬럼 값을 전달하여 1개의 결과가 반환
--	(그룹의 수가 늘어나면 그룹의 수 만큼 결과를 반환)

-- SUM(숫자가 기록된 컬럼명) : 그룹의 합계를 반환

-- 모든 사원의 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE;
-- 94096240


-- 부서 코드가 'D6'인 사원의 급여 합 조회
SELECT SUM(SALARY) 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';
-- 13100000


-----------------------------------------

-- AVG(숫자만 기록된 컬럼) : 그룹의 평균

-- 모든 사원의 급여 평균 조회
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE;
-- 4091140

--------------------------------------------
-- MAX(컬럼명) : 최대값
-- MIN(컬럼명) : 최소값

-- 부서 코드가 'D6'인 사원들 중 
-- 제일 많은 급여와, 제일 적은 급여 조회
SELECT MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- 날짜 대소 비교 : 과거 < 미래
-- 문자열 대소 비교 : 유니코드순서  (문자열 순서  A < Z)

/* 그룹 함수는 여러 개를 동시에 조회할 수 있다 */
--> TIP. SELECT 결과 집합인 RESULT SET이
--       찌그러지지 않은 직각 사각형 형태일 때만 조회 가능!!


-- 모든 사원 중
-- 가장 빠른 입사일, 최근 입사일
-- 이름 오름차순에서 제일 먼저 작성되는 이름, 마지막에 작성되는 이름

SELECT
	MIN(HIRE_DATE) "가장 빠른 입사일",
	MAX(HIRE_DATE) "최근 입사일",
	MIN(EMP_NAME) "제일 먼저 작성되는 이름",
	MAX(EMP_NAME) "마지막에 작성되는 이름"
FROM EMPLOYEE;


--------------------------------------------

-- COUNT(* | [DISTINCT] 컬럼명) : 조회된 행의 개수를 반환

-- COUNT(*) : 조회된 모든 행의 개수를 반환

-- COUNT(컬럼명) : 지정된 컬럼 값이 NULL이 아닌 행의 개수를 반환
-- 					(NULL인 행 미포함)

-- COUNT(DISTINCT 컬럼명) : 
	-- 지정된 컬럼에서 중복 값을 제외한 행의 개수를 반환
	-- EX) A A B C D D D E : 5개 (중복은 한 번만 카운트)


-- EMPLOYEE 테이블의 모든 행의 개수 조회
SELECT COUNT(*) FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 부서 코드가 'D5'인 사원의 수 
SELECT COUNT(*) 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6

-- 전화번호가 등록된 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE PHONE IS NOT NULL; -- 20

-- 전체 조회 결과 행 중에서
-- PHONE 컬럼에 값이 작성된 행만 개수 카운트해서 반환
SELECT COUNT(PHONE)
FROM EMPLOYEE; -- 20


-- EMPLOYEE 테이블에 존재하는 부서코드의 수를 조회
-- (EMPLOYEE 테이블에 부서코드가 몇 종류?)
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE; -- 6


-- EMPLOYEE 테이블에 존재하는 여자, 남자 사원의 수
SELECT
	COUNT( DECODE(SUBSTR(EMP_NO, 8, 1), '2', '여자') ) "여자",
	COUNT( DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남자') ) "남자"
FROM EMPLOYEE;








