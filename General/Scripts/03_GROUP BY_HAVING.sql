/* SELECT문 해석 순서
  5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식
  1 : FROM 참조할 테이블명
  2 : WHERE 컬럼명 | 함수식 비교연산자 비교값
  3 : GROUP BY 그룹을 묶을 컬럼명
  4 : HAVING 그룹함수식 비교연산자 비교값
  6 : ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [NULLS FIRST | LAST];
*/

-----------------------------------------------------------------------------------------------------------------------------------------

-- * GROUP BY절 : 같은 값들이 여러 개 기록된 컬럼을 가지고 같은 값들을
--              하나의 그룹으로 묶음

-- GROUP BY 컬럼명 | 함수식, ....
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함

-- 그룹 함수는 단 한개의 결과 값만 산출하기 때문에 그룹이 여러 개일 경우 오류 발생
-- 여러 개의 결과 값을 산출하기 위해 그룹 함수가 적용된 그룹의 기준을 ORDER BY절에 기술하여 사용



-- EMPLOYEE 테이블에서 부서코드, 부서(그룹) 별 급여 합계 조회
/*3*/SELECT DEPT_CODE, SUM(SALARY)
/*1*/FROM EMPLOYEE
/*2*/GROUP BY DEPT_CODE; -- 같은 DEPT_CODE 끼리 묶음(그룹)
-- D9, D6, D5, D8, NULL, D1, D2



-- EMPLOYEE 테이블에서 
-- 부서코드, 부서 별 급여의 합계, 부서 별 급여의 평균(정수처리), 
-- 인원 수를 조회하고 
-- 부서 코드 순으로 정렬
SELECT 
	DEPT_CODE, 
	SUM(SALARY), 
	AVG(SALARY), 
	COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;



-- EMPLOYEE 테이블에서 
-- 부서코드와 부서별 보너스를 받는 사원의 수를 조회하고 
-- 부서코드 순으로 정렬

SELECT DEPT_CODE, COUNT(*)	-- 4.조회 결과에 포함될 컬럼 지정
FROM EMPLOYEE								-- 1.어떤 테이블에서
WHERE BONUS IS NOT NULL			-- 2.어떤 행만 조회할지 지정
GROUP BY DEPT_CODE					-- 3.WHERE 결과에서 그룹 구분
ORDER BY DEPT_CODE ASC;			-- 5.조회 결과 정렬


-- EMPLOYEE 테이블에서
-- 성별과 성별 별 급여 평균(정수처리), 급여 합계, 인원 수 조회하고
-- 인원 수로 내림차순 정렬
SELECT
	DECODE( SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여' ) "성별",
	FLOOR(AVG(SALARY)) "급여 평균",
	SUM(SALARY) "급여 합계",
	COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY DECODE( SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여' )
ORDER BY "인원 수" DESC;




-- * WHERE절 GROUP BY절을 혼합하여 사용
--> WHERE절은 각 컬럼 값에 대한 조건 (SELECT문 해석 순서를 잘 기억하는 것이 중요!!)


-- EMPLOYEE 테이블에서 부서코드가 'D5', 'D6'인 부서의 평균 급여 조회
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE;


-- EMPLOYEE 테이블에서 직급 별 2010년도 이후 입사자들의 급여 합을 조회
SELECT JOB_CODE, SUM(SALARY) "급여 합"
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2010
GROUP BY JOB_CODE;


-- * 여러 컬럼을 묶어서 그룹으로 지정 가능
-- *** GROUP BY 사용시 주의사항
--> SELECT문에 GROUP BY절을 사용할 경우
--  SELECT절에 명시한 조회할려면 컬럼 중
--  그룹함수가 적용되지 않은 컬럼을 
--  모두 GROUP BY절에 작성해야함.

-- EMPLOYEE 테이블에서 부서 별로 같은 직급인 사원의 급여 합계를 조회하고
-- 부서 코드 오름차순으로 정렬

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- 1) 부서별 그룹 후 2) 직급별 그룹
ORDER BY DEPT_CODE ASC;

-- EMPLOYEE 테이블에서 부서 별로 급여 등급(SAL_LEVEL)이 같은 직원의 수를 조회하고
-- 부서코드, 급여 등급 오름차순으로 정렬
SELECT DEPT_CODE, SAL_LEVEL, COUNT(*)
FROM EMPLOYEE 
GROUP BY DEPT_CODE, SAL_LEVEL
ORDER BY DEPT_CODE ASC, SAL_LEVEL ASC;




--------------------------------------------------------------------------------------------------------------------------

-- * HAVING 절 : 그룹함수로 구해 올 그룹에 대한 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

/* WHERE와 HAVING의 차이
 * 
 * WHERE  : FROM절에서 지정된 테이블 전체 행 중
 * 			조건에 맞는 행만 골라내는 구문
 * 
 * HAVING : GROUP BY를 통해 만들어진 그룹 중
 * 			조건에 맞는 그룹만 골라내는 구문
 * 
 * */


-- 부서별 평균 급여 3500000원 이상인 부서를 조회하여 
-- 부서코드 오름차순으로 정렬
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE SALARY >= 3500000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;
--> 개인 급여가 350만 이상인 사람들의 부서별 평균 (잘못된 SQL)


SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3500000
ORDER BY DEPT_CODE ASC;
--> EMPLOYEE 테이블에서 DEPT_CODE 기준으로 만들어진 그룹 중
--  그룹별 급여 평균이 350만 이상인 그룹만 조회 (맞는 SQL)


-- 부서별 그룹의 급여 합계 중 
-- 1천만원을 초과하는 부서코드와 급여 합계 조회
-- 부서 코드 순으로 정렬

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 10000000
ORDER BY DEPT_CODE ASC;




                      
------ 연습 문제 ------

-- 1. EMPLOYEE 테이블에서 각 부서별 가장 높은 급여, 가장 낮은 급여를 조회하여
-- 부서 코드 오름차순으로 정렬하세요.
SELECT DEPT_CODE, MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE ASC;


-- 2.EMPLOYEE 테이블에서 각 직급별 보너스를 받는 사원의 수를 조회하여
-- 직급코드 오름차순으로 정렬하세요
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY JOB_CODE
ORDER BY JOB_CODE ASC; -- 4행 조회(0명은 조회 결과에 포함 X)

/* 통계적인 측면에서는 아래 방법이 더 좋다! */
--> COUNT(컬럼명) : 해당 컬럼에 값이 행이 몇개인지 카운트
----> NULL이면 카운트에서 제외
SELECT JOB_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE ASC;



-- 3.EMPLOYEE 테이블에서 
-- 부서별 80년대생의 급여 평균이 400만 이상인 부서를 조회하여
-- 부서 코드 오름차순으로 정렬하세요
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "급여 평균"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 1, 1) = '8'
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 4000000
ORDER BY DEPT_CODE ASC;
               
                      
                      
--------------------------------------------------------------------------------------------------------------                     

-- 집계함수(ROLLUP, CUBE)
-- 그룹 별 산출한 결과 값의 집계를 계산하는 함수
-- GOURP BY 절에만 작성하는 함수


-- ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수
-- 그룹별로 묶여진 값에 대한 '중간 집계'와 '총 집계'를 계산하여 자동으로 추가하는 함수
-- * 인자로 전달받은 그룹중에서 가장 먼저 지정한 그룹별 합계와 총 합계를 구하는 함수

-- EMPLOYEE 테이블에서 
-- 각 부서에 소속된 직급 별 급여합, 
-- 부서 별 급여 합,
-- 전체 직원 급여 총합 조회

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;


------------------------------------------------


-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수이다.
-- * 그룹으로 지정된 모든 그룹에 대한 집계와 총 합계를 구하는 함수

-- EMPLOYEE 테이블에서 각 부서 마다 직급별 급여합,
-- 부서 전체 급여 합,

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- ROLLUP 결과에 아래 두 SQL문의 결과가 추가됨
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;


---------------------------------------------------------------------------------------------------------------------------------


-- * SET OPERATION(집합 연산)
-- 여러 개의 SELECT 결과물을 하나의 쿼리로 만드는 연산자
-- 여러가지의 조건이 있을 때 그에 해당하는 여러개의 결과값을 결합시키고 싶을때 사용
-- 초보자들이 사용하기 쉽다.(조건들을 어떻게 엮어야 되는지 덜 생각해도 되니깐)
-- (주의) 집합 연산에 사용되는 SELECT문은 SELECT절이 동일해야함

-- UNION은 OR 같은 개념 (합집합) --> 중복 제거
-- INTERSECT는 AND 같은 개념 (교집합)
-- UNION ALL은 OR 결과 값에 AND 결과값이 더해진거(합집합 + 교집합) --> 중복 미제거
-- MINUS는 차집합 개념 


-- UNION : 여러개의 쿼리 결과를 하나로 합치는 연산자
-- 중복된 영역을 제외하여 하나로 합친다.

-- 'D5', 'D6' 사원 조회

-- 부서 코드가 'D5'인 사원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

-- 부서 코드가 'D6'인 사원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';



-- INTERSECT : 여러개의 SELECT한 결과에서 공통 부분만 결과로 추출 (교집합)


-- 부서코드가 'D5'인 사원의 이름, 부서코드, 급여 조회
--> 박나라, 하이유, 김해술, 심봉선, 윤은해, 대북혼
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

-- 급여가 400만 초과하는 사원의 이름, 부서코드, 급여 조회
--> 선동일, 송종기, 노옹철, 유재식, 정중하, 심봉선, 대북혼, 전지연
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 4000000;




-- UNION ALL : 여러개의 쿼리 결과를 하나로 합치는 연산자
-- UNION과의 차이점은 중복영역을 모두 포함시킨다. (합집합 +  교집합)

--> 심봉선, 대북혼이 2행씩 조회됨
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 4000000;



-- MINUS : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분만 추출(차집합)
-- 부서 코드 D5 중 급여가 400만 초과인 직원 제외

--> 교집합인 심봉선, 대북혼을 제외한 
--  앞쪽 SELECT의 RESULT SET이 조회됨
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 4000000;








