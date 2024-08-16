/* SELECT (조회)
 * 
 * - 지정된 테이블에서 원하는 데이터가 존재하는 행을
 *   선택해서 조회하는 SQL(구조적 질의 언어)
 * 
 * - 작성된 구문에 맞는 행, 열 데이터가 조회됨
 *   -> 조회 결과 행의 집합 == RESULT SET  (중요!!)
 * 
 * - 조회 결과는 0행 이상 (조건에 맞는 행이 없을 수 있다!)
 */

/* [SELECT 작성법 - 1]
 * 
 * 2) SELECT 컬럼명, 컬럼명, ....
 * 1) FROM 테이블명;
 * 
 * - 지정된 테이블의 모든 행에서
 *   특정 컬럼만 조회하기
 * */


-- EMPLOYEE 테이블에서 
-- 모든 행의 이름(EMP_NAME), 급여(SALARY) 컬럼 조회
SELECT EMP_NAME, SALARY 
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서
-- 모든 행의 사번, 이름, 급여, 입사일 조회

SELECT 
	EMP_ID, 
	EMP_NAME, 
	SALARY, 
	HIRE_DATE 
FROM 
	EMPLOYEE;


-- EMPLOYEE 테이블에 존재하는 모든 행, 모든 컬럼 조회
-- * (asterisk) : "모든", 포함을 나타내는 기호
SELECT * FROM EMPLOYEE;


-- DEPARTMENT 테이블에서 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;


------------------------------------------------------------

/* 컬럼 값 산술 연산 */

/* 컬럼 값 : 행과 열이 교차되는 한 칸에 작성된 값
 * 
 * - SELECT문 작성 시
 *   컬럼명에 산술 연산을 작성하면
 *   조회 결과(RESULT SET)에서
 *   모든 행에 산술 연산이 적용된 결과 값이 조회된다!!
 * */

-- EMPLOYEE 테이블에서
-- 모든 사원의 이름, 급여, 급여 + 100만 조회
SELECT EMP_NAME, SALARY, SALARY + 1000000
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서
-- 모든 사원의 이름, 급여, 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY, SALARY * 12
FROM EMPLOYEE;


------------------------------------------------

/* SYSDATE/CURRENT_DATE , SYSTIMESTAMP/CURRENT_TIMESTAMP */

/* * DB는 날짜/시간 관련 데이터를 다루기 굉장히 편하다!!!
 * 
 * - SYSDATE : 시스템이 나타내고 있는 현재 시간
 * - CURRENT_DATE : 현재 세션(사용자 기반) 시간
 * 
 * - SYSTIMESTAMP : 시스템이 나타내고 있는 현재 시간
 * 		              ms 단위 + 지역 포함
 * - CURRENT_TIMESTAMP : 현재 세션(사용자 기반) 시간
 * 		              ms 단위 + 지역 포함
 * */

SELECT SYSDATE, CURRENT_DATE,
			SYSTIMESTAMP, CURRENT_TIMESTAMP 
FROM DUAL;

/* DUAL (DUmmy tAbLe)
 * - 가짜 테이블(임시 테이블)
 * - 조회하려는 데이터가 실제 테이블에 존재하는 데이터가 아닌 경우에 사용
 * */


/* 날짜 데이터 연산하기 ( + , - 만 가능!!!) */

-- 날짜 + 1  == 1일 증가
-- 날짜 - 1  == 1일 감소
--> 정수 연산은 일 단위로 연산된다!!

-- 현재 시간, 어제, 내일, 모레 조회
SELECT 
	CURRENT_DATE,
	CURRENT_DATE - 1,
	CURRENT_DATE + 1,
	CURRENT_DATE + 2
FROM DUAL;


/* 알아두면 도움됨!!! */
-- 현재 시간, 한 시간 후, 1분 후, 10초 후 조회
SELECT 
	CURRENT_DATE,
	CURRENT_DATE + 1/24,
	CURRENT_DATE + 1/24/60,
	CURRENT_DATE + 1/24/60/60 * 10
FROM DUAL;


/* 날짜 끼리 연산하기 ( - 만 가능!! )*/
--> 연산 결과는 일 단위 ( 1 == 1일 )

-- TO_DATE('날짜문자열', '패턴');
--  -> '날짜문자열'을 '패턴' 형식으로 해석하여 
--      DATE 타입으로 변환하는 함수

SELECT '2024-08-15', 
			 TO_DATE('2024-08-15', 'YYYY-MM-DD')
FROM DUAL;

-- 2024년 12월 6일 - 2024년 8월 14
-- == 종강까지 남은 일자
SELECT
	TO_DATE('2024-12-06', 'YYYY-MM-DD') 
	- TO_DATE('2024-08-14', 'YYYY-MM-DD')
FROM DUAL;

-- 점심 시간 - 현재 시간 == 점심까지 남은 시간(초 단위)
SELECT
	(TO_DATE('2024-08-14 12:50', 'YYYY-MM-DD HH24:MI')
	- CURRENT_DATE) * 24 * 60 * 60
FROM DUAL;

-- CEIL(숫자) : 소수점 올림 처리

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재 까지 근무 일수, N년차 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE,
	CURRENT_DATE - HIRE_DATE,
	CEIL( (CURRENT_DATE - HIRE_DATE) / 365 )
FROM EMPLOYEE;

---------------------------------------------------------

/* 컬럼명 별칭 지정하기 */

/* - 별칭 지정 방법
 * 1) 컬럼명 AS 별칭   : 문자 O, 띄어쓰기 X, 특수문자 X
 * 
 * 2) 컬럼명 AS "별칭" : 문자 O, 띄어쓰기 O, 특수문자 O
 * 
 *   -> AS는 생략 가능!!
 * 
 * - ORACLE 에서 ""의 의미
 *  -> "" 내부에 작성된 글자 그대로를 인식해라!!!
 *    EX)  -  : 빼기
 *        "-" : - 모양의 글자
 *    
 * ** ORACLE에서 문자열은 '' (홑따옴표)
 * */



-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재 까지 근무 일수, N년차 조회
SELECT 
	EMP_ID AS 사번, -- 컬럼명 AS 별칭
	EMP_NAME 이름,  -- 컬럼명 별칭 (AS 생략)
	HIRE_DATE AS "입사한 날짜", -- 컬럼명 AS "별칭"
	CURRENT_DATE - HIRE_DATE  "@근무 일수@",
	CEIL( (CURRENT_DATE - HIRE_DATE) / 365 )  "N년째 근무중..."
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 급여(원), 연봉(급여*12) 조회
-- 단, 컬럼명은 모두 별칭 사용
SELECT
	EMP_ID 사번,
	EMP_NAME 이름,
	SALARY "급여(원)",
	SALARY * 12 "연봉(급여*12)"
FROM EMPLOYEE;

-----------------------------------------------------

/* 연결 연산자 (||) 
 * - 두 컬럼을 이어서 하나의 컬럼으로 조회할 때 사용 */

SELECT EMP_ID, EMP_NAME,   -- 200,	선동일
			 EMP_ID || EMP_NAME  -- 200선동일
FROM EMPLOYEE;

--------------------------------------------

/* SELECT절에 컬럼명이 아닌 리터럴(값) 작성하는 경우 
 * 
 * - 조회 결과에 작성된 리터럴 컬럼이 추가되고, 
 *   모든 행에 리터럴이 작성되어 있음
 * */

SELECT SALARY, '원', 100
FROM EMPLOYEE;

SELECT SALARY || '원' AS 급여
FROM EMPLOYEE;

--------------------------------------

/* DISTINCT(별개의, 전혀 다른) 
 * 
 * - 조회 결과 집합(RESULT SET)에서
 *   DISTINCT가 지정된 컬럼 중 중복되는 값이 존재할 경우
 *   중복을 제거하고 한 번만 표시할 때 사용하는 구문(연산자)
 *  */

-- EMPLOYEE 테이블에서
-- 모든 사원의 부서 코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE; -- 23행 조회

-- 사원이 있는 부서의 부서코드 조회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; -- 7행 조회(중복 제거)


-- EMPLOYE 테이블에 존재하는 직급코드(JOB_CODE) 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

---------------------------------------------------

/******************/
/**** WHERE 절 ****/
/******************/

-- 테이블에서 조건을 충족하는 행을 조회할 때 사용
-- WHERE절에는 조건식(true/false)만 작성

-- 비교 연산자 : >, <, >=, <=, = (같다), !=, <> (같지 않다)
-- 논리 연산자 : AND, OR, NOT

/* [SELECT 작성법 - 2]
 * 
 * 3) SELECT 컬럼명, ...
 * 1) FROM 테이블명
 * 2) WHERE 조건식;
 * 
 * 1>> 특정 테이블에서
 * 2>> 조건식을 만족하는 행을 추려놓고
 * 3>> 추려진 결과 행에서 원하는 컬럼만 조회
 * */

-- EMPLOYEE 테이블에서
-- 급여가 400만원을 초과하는 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > 4000000; -- 8행 조회


-- EMPLOYEE 테이블에서
-- 급여가 500만원 이하인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY <= 5000000; -- 19행 


-- EMPLOYEE 테이블에서 
-- 연봉이 5천만원 이하인 사원의
-- 이름, 연봉 조회
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE
WHERE SALARY * 12 <= 50000000; -- 15행 조회


-- 이름이 '노옹철' 인 사원의
-- 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- 같다(=, 등호 1개!!!)

-- 부서 코드(DEPT_CODE) 가 'D9'이 아닌 사원의
-- 이름, 부서 코드 조회
SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE <> 'D9'; --  <> 또는 != -> 같지 않음을 의미

----------------------------------------------------

----------------------
/* NULL 비교 연산 */
----------------------
/* 컬럼명 = NULL  ,  컬럼명 != NULL  (X)
 * 
 *  -> = , != 비교 연산은 
 *     컬럼에 저장된 값을 비교하는 연산이다!!!
 * 
 *  -> ORACLE DB에서 NULL은 값이 아니라
 *     값이 존재하지 않는다는(빈칸) 의미
 *      == 저장된 값이 없다
 * 
 * ****************************************
 * 컬럼명 IS NULL  /  컬럼명 IS NOT NULL   (O)
 *   -> 지정된 컬럼에 값이 존재하지 않는 경우 / 존재하는 경우 
 *     (값의 유무를 따짐)
 * ****************************************
 * */


-- EMPLOYEE 테이블에서 DEPT_CODE가 없는 사원 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE != NULL; -- 결과 없음(잘못된 연산)
WHERE DEPT_CODE IS NULL;  -- 하동운, 이오리 2행 조회


-- EMPLOYEE 테이블에서
-- BONUS 컬럼에 값이 있는 사원 조회
SELECT EMP_NAME, BONUS
FROM EMPLOYEE 
WHERE BONUS IS NOT NULL; -- 9행

--------------------------------------------

/* 논리 연산자(AND/OR) */

-- AND(그리고) : 두 조건식의 결과가 TRUE인 경우만 TRUE
	--> 두 조건을 모두 만족하는 행만 조회 결과에 포함

-- OR(또는)   : 두 조건 중 하나라도 TRUE인 경우에 TRUE
	--> 두 조건 중 하나라도 만족하는 행만 조회 결과에 포함

-- EMPLOYEE 테이블에서
-- 부서 코드가 'D6'인 사원 중
-- 급여가 400만을 초과하는 사원의
-- 이름, 부서 코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE , SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
  AND SALARY > 4000000; -- 유재식, 정중하
  
-- EMPLOYEE 테이블에서
-- 급여가 300만 이상 500만 미만인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000
  AND SALARY <  5000000; -- 16행 조회
  
-- EMPLOYEE 테이블에서
-- 급여가 300만 미만 또는 500만 이상인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY <  3000000
   OR SALARY >= 5000000; -- 7행 조회

----------------------------------------------------------
/* 컬럼명 BETWEEN (A) AND (B)*/
-- 컬럼 값이 "A 이상", "B 이하"인 경우 TRUE(조회 하겠다)
----------------------------------------------------------

-- EMPLOYEE 테이블에서
-- 급여가 400만 이상 600만 이하인 사원의
-- 이름, 급여 조회

-- 1) AND 버전
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000
  AND SALARY <= 6000000;

-- 2) BETWEEN 버전
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 4000000 AND 6000000; -- 6행


----------------------------------------------------------
/* 컬럼명 NOT BETWEEN (A) AND (B)*/
-- 컬럼 값이 "A 이상", "B 이하"가 아닌 경우 TRUE(조회 하겠다)
  -- == A 미만, B 초과
----------------------------------------------------------
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 4000000 AND 6000000; -- 17행



/* 날짜도 범위 비교 가능!!! */
-- EMPLOYEE 테이블에서
-- 2010년대(10.1.1 ~ 19.12.31) 입사한 사원의 
-- 사번, 이름, 입사일 조회

SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE >= TO_DATE('2010-01-01', 'YYYY-MM-DD')
  AND HIRE_DATE <= TO_DATE('2019-12-31', 'YYYY-MM-DD');
-- 10행 조회
 
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE 
	BETWEEN
	TO_DATE('2010-01-01', 'YYYY-MM-DD')
  AND 
  TO_DATE('2019-12-31', 'YYYY-MM-DD');

-----------------------------------------------------------
 
/* 일치하는 값만 조회 */

-- EMPLOYEE 테이블에서
-- 부서코드가 'D5', 'D6', 'D9'인 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
   OR DEPT_CODE = 'D6' 
   OR DEPT_CODE = 'D9';  -- 12행 조회


------------------------------------------------------
/* 컬럼명 IN (값1, 값2, 값3, ...) */
-- 컬럼 값이 IN () 내에 존재하면 TRUE --> 조회 결과에 포함
--   == 연속으로 OR 연산을 작성한 것과 같은 효과
------------------------------------------------------
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9'); -- 12행


------------------------------------------------------
/* 컬럼명 NOT IN (값1, 값2, 값3, ...) */
-- 컬럼 값이 IN () 내에 존재하지 "않으면" TRUE --> 조회 결과에 포함
------------------------------------------------------

-- 부서 코드가 'D5', 'D6', 'D9'이 아닌 사원 조회(NULL 미포함)
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D5', 'D6', 'D9'); -- 9행


-- 부서 코드가 'D5', 'D6', 'D9'이 아닌 사원 조회(NULL 포함)
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D5', 'D6', 'D9')
   OR DEPT_CODE IS NULL ; -- 11행 조회


-------------------------------------------------------------------------

/* ***** LIKE(같은, 비슷한) *****
 * 
 * - 비교하려는 값이 특정한 패턴을 만족 시키면 조회하는 연산자
 * 
 * [작성법]
 * 
 * WHERE 컬럼명 LIKE '패턴'
 * 
 * - LIKE에 사용되는 패턴(와일드 카드)
 * 
 * '%' (포함)
 * 
 * - '%A' : 문자열 앞부분은 어떤 문자든 포함할 수 있지만
 *          마지막은 A로 끝나는 문자열
 * 				
 * - 'A%' : A로 시작하는 문자열
 * 
 * - '%A%' : A가 포함된 문자열
 * 
 * 
 * '_' (글자 수)
 * 
 * - 'A___' : A로 시작하고 그 뒤에 3글자만 있는 문자열 
 * 		      EX) ABCD (o) ,  ABCDE(X)
 * 
 * - '___A' : 앞에 3글자만 있고 A로 끝나는 문자열
 * */ 
 
   
-- EMPLOYEE 테이블에서 성이 '전' 씨인 사원의
-- 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';
   
-- EMPLOYEE 테이블에서 이름이 '수'로 끝나는 사원의
-- 사번, 이름 조회  
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%수';

-- EMPLOYEE 테이블에서 이름에 '하' 가 포함된 사원의
-- 사번, 이름 조회  
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';


-- EMPLOYEE 테이블에서 
-- 전화번호가 '010'으로 시작하는 사원의
-- 이름, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
--WHERE PHONE LIKE '010%';
WHERE PHONE LIKE '010________';
   
   
-- EMPLOYEE 테이블에서
-- EMAIL의 아이디의 글자 수가 5글자인 사원의
-- 사번, 이름, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '_____@%'; -- 4행 조회

 
-- EMPLOYEE 테이블에서
-- EMAIL의 아이디 중 '_' 앞쪽 글자 수가 3글자인 사원의
-- 사번, 이름, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%';

/* '_' 와일드 카드 사용 시 문제점!!!
 
  - 작성되는 문자열의 '_' 기호가
    LIKE '_' 와일드 카드와 
    똑같이 인식되서 구분이 안되는 문제가 발생!!!!
    
  [해결방법]
  - LIKE의 ESACAPE OPTION 사용
  
  ESACAPE OPTION  : 와일드 카드가 아닌 단순 문자열로 인식
  -> 지정된 특수문자 뒤 "한 글자"에만 적용된다!!
  
  EX)  WHERE 컬럼명 LIKE '__#_' ESCAPE '#'; 
   -> # 뒤에 '_' 는 일반 문자열로 인식된다!
*/

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___$_%' ESCAPE '$';  -- 12행
   
---------------------------------------------------

/* ***** ORDER BY 절 *****
 * 
 * - SELECT 조회 결과 집합(RESULT SET)을
 *   원하는 순서로 정렬할 때 사용하는 구문
 * 
 * [작성법]
 * 3) SELECT 컬럼명... 	(특정 컬럼만 선택해서 볼꺼야)
 * 1) FROM 테이블명  		(어떤 테이블에서)
 * 2) WHERE 조건식   		(조건을 만족하는 행만 선택(조회))
 * 4) ORDER BY      	(조회된 결과를 정렬할꺼야)
 *    컬럼명 | 별칭 | 컬럼순서(숫자)
 *    [ASC / DESC]        (오름차순/내림차순)
 *    [NULLS FIRST / NULLS LAST]  (NULL 위치 지정)
 * 
 * *** ORDER BY절은 무조건 SELECT 마지막에 수행된다 !!! ***
 * */

-- 오름차순(ASCENDING)  : 점점 커지는 순서
 -- EX) 1 -> 10 / 가 -> 하 / A -> Z / 과거 -> 미래

-- 내림차순(DESCENDING) : 점점 작아지는 순서

-- EMPLOYEE 테이블에 존재하는 모든 사원을
-- 이름 오름차순으로 조회
SELECT EMP_NAME
FROM EMPLOYEE
ORDER BY EMP_NAME ASC;

-- EMPLOYEE 테이블에 존재하는 모든 사원의
-- 이름, 급여를
-- 급여 내림차순 순서로 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;


-- EMPLOYEE 테이블에서
-- 부서코드가 'D5', 'D6', 'D9' 인 사원의
-- 사번, 이름, 부서코드를
-- 부서코드 오름차순으로 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5', 'D6', 'D9')
ORDER BY DEPT_CODE ASC;


/* 컬럼 순서를 이용해서 정렬 */
-- 급여가 400만 이상, 600만 이하인 사원의
-- 사번, 이름, 급여를 급여 내림차순으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 4000000 AND 6000000
--ORDER BY SALARY DESC;
ORDER BY 3 DESC;
 --> 먼저 해석된 SELECT절에 작성된 컬럼 순서를 이용해
 --  정렬 기준이될 컬럼을 지정할 수 있다


/* 별칭을 이용해서 정렬 */
-- 직급 코드가 'J4', 'J5', 'J6'인 사원을 
-- 사번, 이름, 직급코드 조회 하기
-- 단, 이름 오름차순으로 조회
SELECT 
	EMP_ID "사번",  
	EMP_NAME "이름", 
	JOB_CODE "직급코드"
FROM EMPLOYEE
WHERE JOB_CODE IN ('J4', 'J5', 'J6')
ORDER BY "이름" ASC;

-- WHERE "직급코드" IN ('J4', 'J5', 'J6') 안되는 이유
--> WHERE절은 SELECT절보다 먼저 해석되는데
--  별칭은 SELECT절이 해석되어야 등록되기 때문에
--  WHERE절에서는 별칭 사용 불가능!!


/* ORDER BY절에 수식 적용 */
-- 모든 사원의 이름, 연봉을
-- 연봉 내림차순으로 조회
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE
ORDER BY SALARY * 12 DESC;

-- 별칭 이용
SELECT EMP_NAME, SALARY * 12 "연봉"
FROM EMPLOYEE
ORDER BY "연봉" DESC;

/* SELECT절에 작성되지 않은 컬럼을 이용해서 정렬하기 */
-- 모든 사원 사번, 이름을
-- 부서코드 오름차순으로 조회
SELECT EMP_ID, EMP_NAME /*, DEPT_CODE*/
FROM EMPLOYEE
ORDER BY DEPT_CODE ASC;

--> SELECT절에 작성되지 않아도
--  이전에 FROM절이 해석되어있기 때문에 정렬 가능!!!


/* NULLS FIRST / NULLS LAST  확인 */

/* 오름 차순 - NULLS LAST 기본 값*/
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
ORDER BY DEPT_CODE ASC NULLS FIRST;

/* 내림 차순 - NULLS FIRST 기본 값 */
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
ORDER BY DEPT_CODE DESC NULLS LAST;


/* 정렬 기준 "중첩" 작성 */
-- 먼저 작성된 큰 그룹부터 정렬하고
-- 큰 그룹의 정렬이 깨지지 않는 선에서
-- 이후 작성된 작은 그룹을 정렬


-- EMPLOYEE 테이블에서
-- 이름, 부서코드, 급여를
-- 부서코드 오름차순, 급여 내림차순으로 정렬해서 조회
 --> 같은 부서코드끼리 모아 놓고
 --  그 안에서 급여 내림차순 정렬
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
ORDER BY DEPT_CODE ASC, SALARY DESC;


-- EMPLOYEE 테이블에서
-- 이름, 부서코드, 직급코드(JOB_CODE)를
-- 부서코드 오름차순, 직급코드 내림차순, 이름 오름차순으로 조회
SELECT
	EMP_NAME 이름, 
	DEPT_CODE 부서코드, 
	JOB_CODE 직급코드
FROM 
	EMPLOYEE
ORDER BY 
	부서코드 ASC, 
	직급코드 DESC,
	이름 ASC;


   
  
