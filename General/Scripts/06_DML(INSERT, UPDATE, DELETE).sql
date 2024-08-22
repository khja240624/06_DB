--- *** DML(Data Manipulation Language) : 데이터 조작 언어

-- 테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제(DELETE)하는 구문

-- SELECT도 DML에 포함되긴 하지만 DQL이라는 것으로 분리해서 보기도 한다!!
	--> DQL(Data Query Language : 데이터 질의 언어)

-- 주의 : 혼자서 COMMIT, ROLLBACK 하지 말것!

-- 테스트용 테이블 생성
CREATE TABLE EMPLOYEE2 AS SELECT * FROM EMPLOYEE;
CREATE TABLE DEPARTMENT2 AS SELECT * FROM DEPARTMENT;

SELECT * FROM EMPLOYEE2; 
SELECT * FROM DEPARTMENT2;

--------------------------------------------------------------------------------------------------------------------

-- 1. INSERT

-- 테이블에 새로운 행을 추가하는 구문

SELECT COUNT(*) -- 전체 행의 개수 23행 카운트
FROM EMPLOYEE2;

-- 1)  INSERT INTO 테이블명 VALUES(데이터, 데이터, ...)
-- 테이블에 모든 컬럼에 대한 값을 INSERT할 때 사용
-- INSERT하고자 하는 컬럼이 모든 컬럼인 경우 컬럼명 생략 가능. 
-- 단, 컬럼의 순서를 지켜서 VALUES에 값을 기입해야 함

-- 900, '장채현', '001123-2345678', 'jang_ch@kh.or.kr', '01012341234','D1', 'J7', 'S3', 4300000, 0.2, 200, SYSDATE, NULL, 'N'
        
INSERT INTO EMPLOYEE2
VALUES(900, '장채현', '001123-2345678', 
		'jang_ch@kh.or.kr', '01012341234',
		'D1', 'J7', 'S3', 
		4300000, 0.2, 200, SYSDATE, NULL, 'N');

-- 전체 행 개수 증가 확인
SELECT COUNT(*)
FROM EMPLOYEE2; -- 24행

-- 사번이 '900'인 사원 조회
SELECT *
FROM EMPLOYEE2
WHERE EMP_ID = 900;


ROLLBACK;
--> COMMIT 되지 않은 DML(INSERT,UPDATE,DELET) 취소하기
 -- == DML 수행 전으로 되돌리기

SELECT *
FROM EMPLOYEE2
WHERE EMP_ID = 900;


---------------------------------------

-- 2)  INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명,...)
-- VALUES (데이터1, 데이터2, 데이터3, ...);
-- 테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때 사용
-- 선택안된 컬럼은 값이 NULL이 들어감

-- EMP_NAME, EMP_ID, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY
-- '장채현', 900, '001123-2345678', 'jang_ch@kh.or.kr', '01012341234', 'D1', 'J7', 'S3', 4300000

INSERT INTO EMPLOYEE2(
	EMP_NAME, EMP_ID, EMP_NO, 
	EMAIL, PHONE, DEPT_CODE, 
	JOB_CODE, SAL_LEVEL, SALARY)
	
VALUES('장채현', 900, '001123-2345678', 
	'jang_ch@kh.or.kr', '01012341234', 'D1', 
	'J7', 'S3', 4300000);

SELECT * 
FROM EMPLOYEE2
WHERE EMP_ID = 900;



---------------------------------------

-- (참고) INSERT시 VALUES 대신 서브쿼리 사용 가능
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

-- 서브 쿼리를 이용해서 여러 행 INSERT하기
--> 서브쿼리 결과(RESULT SET)를 통째로 삽입하기
INSERT INTO EMP_01
(SELECT
	EMP_ID,
	EMP_NAME,
	DEPT_TITLE
FROM EMPLOYEE2
LEFT JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID)
);



SELECT * FROM EMP_01;

--------------------------------------------------------------------------------------------------------------------

-- 2. UPDATE

-- 테이블에 기록된 컬럼의 값을 수정하는 구문

-- [작성법]
-- UPDATE 테이블명 SET 컬럼명 = 바꿀값 [WHERE 컬럼명 비교연산자 비교값];


-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 부서 정보 조회
SELECT *
FROM DEPARTMENT2
WHERE DEPT_ID = 'D9'; -- D9 / 총무부 / L1


-- DEPARTMENT2 테이블에서 DEPT_ID가 'D9'인 행의 
-- DEPT_TITLE을 '전략기획팀' 으로 수정
UPDATE DEPARTMENT2
SET
	DEPT_TITLE = '전략기획팀'
WHERE 
	DEPT_ID = 'D9';


-- UPDATE 확인
SELECT *
FROM DEPARTMENT2
WHERE DEPT_ID = 'D9'; -- D9	전략기획팀	L1

ROLLBACK;



-- EMPLOYEE2 테이블에서 BONUS를 받지 않는 사원의 
-- BONUS를 0.1로 변경
SELECT EMP_NAME, BONUS
FROM EMPLOYEE2;

UPDATE EMPLOYEE2
SET
	BONUS = 0.1
WHERE
	BONUS IS NULL; 

-- 결과 확인
SELECT EMP_NAME, BONUS
FROM EMPLOYEE2;

ROLLBACK;


---------------------------------------

-- * 조건절을 설정하지 않고 UPDATE 구문 실행 시 모든 행의 컬럼 값 변경.

-- DEPARTMENT2 테이블의 모든 부서명을 
-- '인사팀'으로 수정

SELECT *
FROM DEPARTMENT2;

UPDATE DEPARTMENT2
SET
	DEPT_TITLE = '인사팀';
-- 9행 수정

-- 결과 확인
SELECT *
FROM DEPARTMENT2;

ROLLBACK;


---------------------------------------


-- * 여러 컬럼을 한번에 수정할 시 콤마(,)로 컬럼을 구분하면됨.
-- D9 / 총무부  -> D0 / 전략기획2팀으로 수정

UPDATE DEPARTMENT2
SET
	DEPT_ID = 'D0',
	DEPT_TITLE = '전략기획2팀'
WHERE 
	DEPT_ID = 'D9'
	AND
	DEPT_TITLE = '총무부';

-- 결과 확인
SELECT * FROM DEPARTMENT2;
-- D0	전략기획2팀	L1

---------------------------------------

-- * UPDATE시에도 서브쿼리를 사용 가능

-- [작성법]
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)

-- EMPLOYEE2 테이블에서
-- 평상시 유재식 사원을 부러워하던 방명수 사원의
-- 급여와 보너스율을 유재식 사원과 동일하게 변경해 주기로 했다.
-- 이를 반영하는 UPDATE문을 작성하시오.

UPDATE EMPLOYEE2
SET
	SALARY = (
		SELECT SALARY 
		FROM EMPLOYEE2
		WHERE EMP_NAME = '유재식'
	),
	
	BONUS  = (
		SELECT BONUS 
		FROM EMPLOYEE2
		WHERE EMP_NAME = '유재식'
	)
WHERE
	EMP_NAME = '방명수';


-- 결과 확인
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE2
WHERE EMP_NAME IN('유재식', '방명수');

ROLLBACK;
   
---------------------------------------


-- * 다중열 서브쿼리를 이용한 UPDATE문

-- EMPLOYEE2 테이블에서
-- 방명수 사원의 급여 인상 소식을 전해들은 다른 멤버들이
-- 단체로 파업을 진행했다.
-- 노옹철, 전형돈, 정중하, 하동운 사원의 급여와 보너스를
-- 유재식 사원의 급여와 보너스와 같게 변경하는 UPDATE문을 작성하시오.
UPDATE EMPLOYEE2
SET
	(SALARY, BONUS) = ( -- 다중열 서브쿼리로 수정
		SELECT SALARY, BONUS
		FROM EMPLOYEE2
		WHERE EMP_NAME = '유재식'
	)
WHERE
	EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');
-- 4행 수정됨


-- 결과 확인
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE2
WHERE EMP_NAME IN ('노옹철', '전형돈', '정중하', '하동운');

ROLLBACK;



-- EMPLOYEE2 테이블에서 아시아지역에 근무하는 직원의 보너스를 0.3으로 변경


-- 1) 아시아 지역에 근무하는 직원
SELECT EMP_NAME, LOCAL_NAME, BONUS
FROM EMPLOYEE2
JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION    ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';


-- 2) 아시아 지역 근무 직원 보너스 0.3으로 변경
UPDATE EMPLOYEE2
SET
	BONUS = 0.3
WHERE 
	EMP_ID IN (
		SELECT EMP_ID
		FROM EMPLOYEE2
		JOIN DEPARTMENT2 ON (DEPT_CODE = DEPT_ID)
		JOIN LOCATION    ON (LOCATION_ID = LOCAL_CODE)
		WHERE LOCAL_NAME LIKE 'ASIA%'
	);

-- 1번 SELECT 실행해서 결과 확인

--------------------------------------------------------------------------------------------------------------------

-- 3. MERGE(병합) (참고만 하세요!)

-- 구조가 같은 두 개의 테이블을 하나로 합치는 기능.
-- 테이블에서 지정하는 조건의 값이 존재하면 UPDATE == KEY값 중복 시 VALUE 수정
-- 조건의 값이 없으면 INSERT됨

CREATE TABLE EMP_M01
AS SELECT * FROM EMPLOYEE; -- 23행

CREATE TABLE EMP_M02
AS SELECT * FROM EMPLOYEE
   WHERE JOB_CODE = 'J4'; -- 4행
   
INSERT INTO EMP_M02
VALUES (999, '곽두원', '561016-1234567', 'kwack_dw@kh.or.kr',
        '01011112222', 'D9', 'J4', 'S1', 9000000, 0.5, NULL,
        SYSDATE, NULL, DEFAULT);
       
SELECT * FROM EMP_M01; -- 23행
SELECT * FROM EMP_M02; -- 5행 
	--> EMP_M02는 
	--	M01 테이블과 4개의 행이 중복되고
	--  1개의 행이 다름

UPDATE EMP_M02 SET SALARY = 0;


SELECT * FROM EMP_M02;


MERGE INTO EMP_M01 
USING EMP_M02 ON(EMP_M01.EMP_ID = EMP_M02.EMP_ID) -- 중복 확인용 KEY
WHEN MATCHED THEN -- 중복 확인용 KEY가 매치되면(일치하면)
UPDATE SET -- 수정하겠다
EMP_M01.EMP_NAME = EMP_M02.EMP_NAME,
EMP_M01.EMP_NO = EMP_M02.EMP_NO,
EMP_M01.EMAIL = EMP_M02.EMAIL,
EMP_M01.PHONE = EMP_M02.PHONE,
EMP_M01.DEPT_CODE = EMP_M02.DEPT_CODE,
EMP_M01.JOB_CODE = EMP_M02.JOB_CODE,
EMP_M01.SAL_LEVEL = EMP_M02.SAL_LEVEL,
EMP_M01.SALARY = EMP_M02.SALARY,
EMP_M01.BONUS = EMP_M02.BONUS,
EMP_M01.MANAGER_ID = EMP_M02.MANAGER_ID,
EMP_M01.HIRE_DATE = EMP_M02.HIRE_DATE,
EMP_M01.ENT_DATE = EMP_M02.ENT_DATE,
EMP_M01.ENT_YN = EMP_M02.ENT_YN
WHEN NOT MATCHED THEN -- 중복이 되지 않으면
INSERT -- 삽입 하겠다
	VALUES (EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO,
               EMP_M02.EMAIL, EMP_M02.PHONE, EMP_M02.DEPT_CODE,
               EMP_M02.JOB_CODE, EMP_M02.SAL_LEVEL, EMP_M02.SALARY,
               EMP_M02.BONUS, EMP_M02.MANAGER_ID, EMP_M02.HIRE_DATE,
               EMP_M02.ENT_DATE, EMP_M02.ENT_YN);

SELECT * FROM EMP_M01; 


--------------------------------------------------------------------------------------------------------------------

-- 4. DELETE
-- 테이블의 행을 삭제하는 구문

-- [작성법]
-- DELETE FROM 테이블명 WHERE 조건설정
-- 만약 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제됨

COMMIT;

-- EMPLOYEE2 테이블에서 '장채현'사원 정보 조회
SELECT * 
FROM EMPLOYEE2
WHERE EMP_NAME = '장채현';

-- EMPLOYEE2 테이블에서 이름이 '장채현'인 사원 정보 삭제
DELETE
FROM EMPLOYEE2
WHERE EMP_NAME = '장채현';

-- 삭제 확인
SELECT * 
FROM EMPLOYEE2
WHERE EMP_NAME = '장채현'; -- 조회 결과 없음

COMMIT; -- DML 수행 결과를 데이터베이스에 반영

-- EMPLOYEE2 테이블 전체 삭제
DELETE FROM EMPLOYEE2;

SELECT * FROM EMPLOYEE2; -- 조회 결과 없음

ROLLBACK;
SELECT * FROM EMPLOYEE2; 

---------------------------------------------------------------------------------------------


-- 5. TRUNCATE (DDL 입니다! DML 아닙니다!)
-- 테이블의 전체 행을 삭제하는 DDL
-- DELETE보다 수행속도가 더 빠르다.
-- ROLLBACK을 통해 복구할 수 없다.

-- TRUNCATE 테스트용 테이블 생성
CREATE TABLE EMPLOYEE3
AS SELECT * FROM EMPLOYEE2;

-- 생성 확인
SELECT * FROM EMPLOYEE3;

-- DELETE로 모든 데이터 삭제
DELETE FROM EMPLOYEE3;

-- 삭제 확인
SELECT * FROM EMPLOYEE3;

ROLLBACK;

-- 롤백 후 복구 확인
SELECT * FROM EMPLOYEE3;

-- TRUNCATE로 삭제
TRUNCATE TABLE EMPLOYEE3;

-- 삭제 확인
SELECT * FROM EMPLOYEE3;

ROLLBACK;
-- 롤백 후 복구 확인 -> 복구 안됨을 확인!
SELECT * FROM EMPLOYEE3;