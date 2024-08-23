-- DDL(Data Definition Language) : 데이터 정의 언어로
-- 객체를 만들고(CREATE), 수정하고(ALTER), 삭제하는(DROP) 구문

-- ALTER(바꾸다, 변조하다)
-- 수정 가능한 것 : 컬럼(추가/수정/삭제), 제약조건(추가/삭제)
--                  이름변경(테이블, 컬럼, 제약조건)

-- [작성법]
-- 테이블을 수정하는 경우
-- ALTER TABLE 테이블명 ADD|MODIFY|DROP 수정할 내용;

--------------------------------------------------------------------------------
-- 1. 제약조건 추가 / 삭제

-- * 작성법 중 [] 대괄호 : 생략 가능(선택)

-- 제약조건 추가 : 
-- ALTER TABLE 테이블명 
-- ADD [CONSTRAINT 제약조건명] 제약조건(컬럼명) [REFERENCES 테이블명[(컬럼명)]];


-- 제약조건 삭제 : 
-- ALTER TABLE 테이블명
-- DROP CONSTRAINT 제약조건명;


-- 서브쿼리를 이용해서 DEPARTMENT 테이블 복사(DEPT_COPY) --> NOT NULL 제약조건만 복사됨
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT *
FROM DEPT_COPY;

-- DEPT_COPY 테이블에 PK 추가
ALTER TABLE DEPT_COPY 
ADD CONSTRAINT DEPT_COPY_PK PRIMARY KEY(DEPT_ID);


-- DEPT_COPY 테이블의 DEPT_TITLE 컬럼에 UNIQUE 제약조건 추가
-- (DEPT_COPY_TITLE_U)
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);


-- DEPT_COPY 테이블의 LOCATION_ID 컬럼에 CHECK 제약조건 추가
-- 컬럼에 작성할 수 있는 값은 L1, L2, L3, L4, L5 
-- 제약조건명 : LOCATION_ID_CHK
ALTER TABLE DEPT_COPY
ADD CONSTRAINT LOCATION_ID_CHK
CHECK (LOCATION_ID IN ('L1', 'L2', 'L3', 'L4', 'L5'));



-- DEPT_COPY 테이블의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가
-- * NOT NULL 제약조건은 다루는 방법이 다름
-->  NOT NULL을 제외한 제약 조건은 추가적인 조건으로 인식됨.(ADD/DROP)
-->  NOT NULL은 기존 컬럼의 성질을 변경하는 것으로 인식됨.(MODIFY)
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NOT NULL; -- NULL 허용 X

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL; -- NULL 허용



---------------------------

-- DEPT_COPY에 추가한 제약조건 중 PK 빼고 모두 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_U;

ALTER TABLE DEPT_COPY
DROP CONSTRAINT LOCATION_ID_CHK;


-- NOT NULL 제거 시 MODIFY 사용
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL; -- NULL 허용

---------------------------------------------------------------------------------
-- 2. 컬럼 추가/수정/삭제

-- 컬럼 추가 : ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);


-- 컬럼 수정 : ALTER TABLE 테이블명 MOIDFY 컬럼명 데이터타입;   (데이터 타입 변경)
--             ALTER TABLE 테이블명 MOIDFY 컬럼명 DEFAULT '값'; (기본값 변경)

--> ** 데이터 타입 수정 시 컬럼에 저장된 데이터 크기 미만으로 변경할 수 없다.
-- EX) CHAR(3) 짜리 컬럼에 'ABC' 저장된 상태
--     -> CHAR(1) 수정 하려고하면 오류 발생


-- 컬럼 삭제 : ALTER TABLE 테이블명 DROP (삭제할컬럼명);
--             ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;

--> ** 테이블에는 최소 1개 이상의 컬럼이 존재해야 되기 때문에 모든 컬럼 삭제 X

-- 테이블이란? 행과 열로 이루어진 데이터베이스의 가장 기본적인 객체


-- (추가)
-- DEPT_COPY 테이블에 CNAME VARCHAR2(20) 컬럼 추가
-- ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값']);
ALTER TABLE DEPT_COPY
ADD(CNAME VARCHAR2(20));

SELECT * FROM DEPT_COPY;


-- (추가)
-- DEPT_COPY 테이블에 LNAME VARCHAR2(30) 기본값 '한국' 컬럼 추가
ALTER TABLE DEPT_COPY
ADD (LNAME VARCHAR2(30) DEFAULT '한국');

SELECT * FROM DEPT_COPY;
-->  새로 추가된 LNAME 컬럼에 기본값 '한국'이 자동으로 세팅됨


-- (수정)
-- DEPT_COPY 테이블의 DEPT_ID 컬럼의 데이터 타입을 
-- CHAR(2) -> VARCHAR2(3)으로 변경
-- ALTER TABLE 테이블명 MOIDFY 컬럼명 데이터타입;
ALTER TABLE DEPT_COPY
MODIFY DEPT_ID VARCHAR2(3);
--> 테이블 정보에서 확인


-- (수정 에러 상황 : 저장된 값보다 작은 크기로 변환 불가)
-- DEPT_TITLE 컬럼의 데이터타입을 VARCHAR2(10)으로 변경
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(10);
-- ORA-01441: 일부 값이 너무 커서 열 길이를 줄일 수 없음

SELECT 
	DEPT_TITLE, 
	LENGTH(DEPT_TITLE)  "문자열 길이", 
	LENGTHB(DEPT_TITLE) "문자열의 바이트 크기"
FROM DEPT_COPY;


-- (기본값 수정)
-- LNAME 기본값을 '한국' -> '대한민국' 으로 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT '값'; 
ALTER TABLE DEPT_COPY
MODIFY LNAME DEFAULT '대한민국';

SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블의 LNAME 컬럼 값을
-- 기본값인 '대한민국'으로 모두 변경
UPDATE DEPT_COPY
SET 
	LNAME = DEFAULT;

SELECT * FROM DEPT_COPY;

COMMIT;



-- (삭제)
-- DEPT_COPY에 추가한 컬럼(CNAME, LNAME) 삭제
-->  ALTER TABLE 테이블명 DROP(삭제할컬럼명);
ALTER TABLE DEPT_COPY
DROP(CNAME);

-->  ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명;
ALTER TABLE DEPT_COPY
DROP COLUMN LNAME;

SELECT * FROM DEPT_COPY;


-- DEPT_COPY의 모든 컬럼 삭제
ALTER TABLE DEPT_COPY
DROP COLUMN LOCATION_ID;

ALTER TABLE DEPT_COPY
DROP COLUMN DEPT_TITLE;

ALTER TABLE DEPT_COPY
DROP COLUMN DEPT_ID;
-- ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

SELECT * FROM DEPT_COPY;



-- * DDL / DML을 혼용해서 사용할 경우 발생하는 문제점
-- DML을 수행하여 트랜잭션에 변경사항이 저장된 상태에서
-- COMMIT/ROLLBACK 없이 DDL 구문을 수행하게되면
-- DDL 수행과 동시에 선행 DML이 자동으로 COMMIT 되어버림.


SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블에 DEPT_ID 컬럼 값으로 'D0' 추가
-- INSERT(DML) 수행
INSERT INTO DEPT_COPY
VALUES('D0'); -- 1행 삽입

SELECT * FROM DEPT_COPY;

-- ROLLBACK을 수행해서 트랜잭션에 저장된 DML 다 지우기
ROLLBACK;

-- ROLLBACK 결과 확인
SELECT * FROM DEPT_COPY; -- 'D0' 없어짐

--------------------------------
/* DML + DDL 혼용 사용하기 */
INSERT INTO DEPT_COPY
VALUES('D0'); -- 1행 삽입

SELECT * FROM DEPT_COPY; -- 'D0' 추가됨

-- DEPT_COPY 테이블에 컬럼 추가(DDL 수행)
ALTER TABLE DEPT_COPY
ADD (DEPT_TITLE VARCHAR2(30));

SELECT * FROM DEPT_COPY; -- 'DEPT_TITLE' 추가됨

-- ROLLBACK 수행
ROLLBACK;

SELECT * FROM DEPT_COPY; -- 'D0'가 삭제되지 않음!
--> ALTER(DDL) 수행 시 트랜잭션이 자동으로 COMMIT됨!


--> 결론 : DML/DDL 혼용해서 사용하지 말자!!!


-------------------------------------------------------------------------------

-- 3. 테이블 삭제

-- [작성법]
-- DROP TABLE 테이블명 [CASCADE CONSTRAINTS];


-- 일반 삭제(DEPT_COPY)
DROP TABLE DEPT_COPY;

SELECT * FROM DEPT_COPY;
-- 00942: 테이블 또는 뷰가 존재하지 않습니다


-- ** 관계가 형성된 테이블 삭제 **

-- TB1 테이블 생성
CREATE TABLE TB1(
	TB1_PK NUMBER PRIMARY KEY,
	TB1_COL NUMBER
);

-- TB2 테이블 생성(TB1과 관계 설정(FK))
CREATE TABLE TB2(
	TB2_PK NUMBER PRIMARY KEY,
	TB2_COL NUMBER
		REFERENCES TB1(TB1_PK) 	
);


-- TB1(부모) 테이블 삭제
DROP TABLE TB1;
-- ORA-02449: 
-- 외래 키에 의해 참조되는 고유/기본 키가 
-- 테이블에 있습니다
-- ==  PK 컬럼이 다른 테이블에 참조를 당하고 있다


-- 해결 방법1) 참조하는 자식 테이블(TB2)을 삭제하거나 FK 제약조건을 삭제

-- 해결 방법2) CASCADE CONSTRAINTS 옵션 사용하기
--> 테이블 삭제 시 연결되어있는 FK 제약조건을 같이 삭제 시킴
DROP TABLE TB1 CASCADE CONSTRAINTS;
-- TB1 테이블 삭제

--   + TB2 FK 제약 조건도 같이 삭제됨!


---------------------------------------------------------------------------------

-- 4. 컬럼, 제약조건, 테이블 이름 변경(RENAME)

-- 테이블 복사
CREATE TABLE DEPT_COPY 
AS SELECT * FROM DEPARTMENT; 

-- 복사한 테이블에 PK 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_PK PRIMARY KEY(DEPT_ID);

SELECT * FROM DEPT_COPY;

-- 1) 컬럼명 변경 : ALTER TABLE 테이블명 RENAME COLUMN 컬럼명 TO 변경명;
-- DEPT_TITLE -> DEPT_NAME으로 변경
ALTER TABLE DEPT_COPY RENAME COLUMN 
DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_COPY;

-- 2) 제약조건명 변경 : ALTER TABLE 테이블명 RENAME CONSTRAINT 제약조건명 TO 변경명;
-- DEPT_COPY_PK -> PK_DCOPY 로 변경
ALTER TABLE DEPT_COPY RENAME 
CONSTRAINT DEPT_COPY_PK TO PK_DCOPY;


-- 3) 테이블명 변경 : ALTER TABLE 테이블명 RENAME TO 변경명;
-- DEPT_COPY -> DCOPY 변경
ALTER TABLE DEPT_COPY RENAME TO DCOPY;


SELECT * FROM DEPT_COPY;
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다


SELECT * FROM DCOPY; -- 변경 확인












