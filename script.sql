-- ToyProject -> script.sql

--초기화
DROP TABLE tblcomment;
DROP TABLE TBLBOARD;
DROP TABLE tbluser;


-- 첫번째 기능. 회원 테이블
DROP TABLE tblUser;
CREATE TABLE tblUser (
	id varchar2(50) PRIMARY KEY,							--아이디(pk)
	pw varchar2(50) NOT NULL,								--암호
	name varchar2(50) NOT NULL, 							--이름
	email varchar2(100) NOT NULL, 							--이메일
	lv number(1) NOT NULL,									--등급(1-일반, 2-관리자)(보통은 관리자랑 일반회원 테이블 구분하는 편)
	pic varchar2(100) DEFAULT 'pic.png' NOT NULL, 		--프로필사진
	intro varchar2(500) NULL,								--자기소개
	regdate DATE DEFAULT sysdate NOT NULL, 				--가입날짜
	ing number(1) DEFAULT 1 NOT NULL 						--활동유무(1-활동, 0-탈퇴)
);



--일반 계정(테스트용)
INSERT INTO TBLUSER (id, pw, name, email, lv, pic, intro, regdate, ing) VALUES ('hong', '1111', '홍길동', 'hong@gmail.com', 1, DEFAULT, '반갑습니다.', DEFAULT, DEFAULT);

--관리자 계정(테스트용)
INSERT INTO TBLUSER (id, pw, name, email, lv, pic, intro, regdate, ing) VALUES ('tiger', '1111', '호랑이', 'tiger@gmail.com', 2, DEFAULT, '호랑이입니다.', DEFAULT, DEFAULT);

SELECT * FROM tbluser;

COMMIT;

-- 2번째 기능. 게시판 테이블
CREATE TABLE tblBoard (
	seq NUMBER PRIMARY KEY, 							--번호(pk)
	subject varchar2(300) NOT NULL, 					--제목
	content varchar2(4000) NOT NULL, 					--내용
	id varchar2(50) NOT NULL REFERENCES tblUser(id), --작성자 아이디(fk)
	regdate DATE DEFAULT sysdate NOT NULL, 			--작성날짜
	readcount NUMBER DEFAULT 0 NOT NULL 				--조회수
);

CREATE SEQUENCE seqBoard;

INSERT INTO TBLBOARD (seq, subject, content, id, regdate, readcount) VALUES (seqBoard.nextVal, ?, ?, ?, DEFAULT, DEFAULT);

SELECT * FROM TBLBOARD;
SELECT count(*) FROM TBLBOARD;

SELECT seq, subject, id, readcount, regdate FROM TBLBOARD ORDER BY seq DESC;

CREATE OR REPLACE VIEW vwBoard AS 
SELECT 
	seq, subject, id, readcount, regdate, content,
	(SELECT name FROM tblUser WHERE id = tblBoard.id) AS name,
	(sysdate - regdate) AS isnew
FROM TBLBOARD
ORDER BY seq DESC;




UPDATE tblBoard SET regdate = regdate - 5 WHERE seq = 1;
UPDATE tblBoard SET regdate = regdate - 3.5 WHERE seq = 2;
UPDATE tblBoard SET regdate = regdate - 2.3 WHERE seq = 3;
UPDATE tblBoard SET regdate = regdate - 1.4 WHERE seq = 4;

COMMIT;

SELECT * FROM vwboard;

SELECT tblBoard.*, (SELECT name FROM tblUser WHERE id = tblBoard.id) AS name FROM tblBoard WHERE seq = ?;

UPDATE TBLBOARD SET readcount = readcount+1 WHERE seq=?;

UPDATE TBLBOARD SET subject = ?, content = ? WHERE seq = ?;
DELETE FROM TBLBOARD WHERE seq = ?;

-- 회원 탈퇴
-- update문
UPDATE TBLUSER SET (pw = '0000', name = '익명', email = '0000', lv = 1, pic = 'pic.png', intro = '0000', ing = 0) WHERE id = ?;
UPDATE TBLUSER SET 
	(pw = '0000', 
	name = '익명', 
	email = '0000', 
	lv = 1, 
	pic = 'pic.png', 
	intro = '0000', 
	ing = 0) 
WHERE id = ?;


--검색 기능
SELECT * FROM vwboard WHERE 컬럼명 like '%검색어%';

SELECT * FROM vwboard WHERE content LIKE '%셋%';
SELECT * FROM vwboard;


--페이징
--CREATE OR REPLACE VIEW  AS 
SELECT * FROM (SELECT a.*, rownum AS rnum FROM vwBoard a) WHERE rnum BETWEEN 1 AND 10;
SELECT * FROM (SELECT a.*, rownum AS rnum FROM vwBoard a)
	WHERE rnum BETWEEN 11 AND 20;


SELECT count(*) AS cnt FROM VWBOARD;

DELETE FROM tblboard WHERE seq >= 42;

COMMIT;

--댓글 테이블
CREATE TABLE tblComment(
	seq NUMBER PRIMARY KEY, --번호(pk)
	content varchar2(2000) NOT NULL, --댓글내용
	id varchar2(50) NOT NULL REFERENCES tblUser(id), --아이디(FK)
	regdate DATE DEFAULT sysdate NOT NULL, --작성날짜
	bseq NUMBER NOT NULL REFERENCES tblBoard(seq) --부모글(FK)
);

CREATE SEQUENCE seqComment;

SELECT * FROM tblcomment ORDER BY seq DESC;

INSERT INTO tblComment (seq, content, id, regdate, bseq) VALUES (seqComment.nextVal, ? ?, DEFAULT, ?);

SELECT tblcomment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name FROM tblcomment WHERE bseq = ? ORDER BY seq DESC;


SELECT tblComment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name FROM tblComment WHERE seq = (SELECT max(seq) FROM tblcomment);


INSERT INTO tblcomment (seq, content, id, regdate, bseq) VALUES (seqComment.nextVal, ?, ?, DEFAULT, ?);

--댓글 페이징
SELECT * FROM (SELECT
	
	tblComment.*, 
	(SELECT name FROM tblUser WHERE id = tblComment.id) AS name
	FROM tblComment 
	WHERE bseq = 301 
	ORDER BY seq DESC) 
WHERE rownum <= 10;



SELECT * FROM (SELECT	tblComment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name	FROM tblComment WHERE bseq = 301 ORDER BY seq DESC) WHERE rownum <= 10;


--댓글 5개씩 더 불러오기
SELECT * FROM (SELECT a.*, rownum AS rnum FROM (SELECT
	tblComment.*, 
	(SELECT name FROM tblUser WHERE id = tblComment.id) AS name
	FROM tblComment 
	WHERE bseq = 301 
	ORDER BY seq DESC) a) WHERE rnum BETWEEN 1 AND 1 + 4;

SELECT * FROM (SELECT a.*, rownum AS rnum FROM (SELECT tblComment.*, (SELECT name FROM tblUser WHERE id = tblComment.id) AS name FROM tblComment WHERE bseq = 301 ORDER BY seq DESC) a) WHERE rnum BETWEEN 1 AND 1 + 4;


CREATE OR REPLACE VIEW vwBoard AS 
SELECT 
	seq, subject, id, readcount, regdate, content,
	(SELECT name FROM tblUser WHERE id = tblBoard.id) AS name,
	(sysdate - regdate) AS isnew,
	(SELECT count(*) FROM tblComment WHERE bseq=tblBoard.seq) AS commentCount
FROM TBLBOARD
ORDER BY seq DESC;


