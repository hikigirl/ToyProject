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
	(SELECT count(*) FROM tblComment WHERE bseq=tblBoard.seq) AS commentCount,
	secret,
	notice
FROM TBLBOARD
	WHERE notice = 0
	ORDER BY seq DESC;
--ORDER BY notice DESC, seq DESC;

CREATE OR REPLACE VIEW vwNotice AS 
SELECT 
	seq, subject, id, readcount, regdate, content,
	(SELECT name FROM tblUser WHERE id = tblBoard.id) AS name,
	(sysdate - regdate) AS isnew,
	(SELECT count(*) FROM tblComment WHERE bseq=tblBoard.seq) AS commentCount,
	secret,
	notice
FROM TBLBOARD
	WHERE notice = 1
	ORDER BY seq DESC;

SELECT * FROM vwboard;
SELECT * FROM vwNotice;

--댓글수정
UPDATE TBLCOMMENT SET content = ? WHERE seq = ?;

--첨부파일 기능
DROP TABLE tblcomment;
DROP TABLE TBLBOARD;

CREATE TABLE tblBoard (
	seq NUMBER PRIMARY KEY, 							--번호(pk)
	subject varchar2(300) NOT NULL, 					--제목
	content varchar2(4000) NOT NULL, 					--내용
	id varchar2(50) NOT NULL REFERENCES tblUser(id), --작성자 아이디(fk)
	regdate DATE DEFAULT sysdate NOT NULL, 			--작성날짜
	readcount NUMBER DEFAULT 0 NOT NULL, 				--조회수
	attach varchar2(300) NULL, 						--첨부파일
	secret NUMBER(1) DEFAULT 0 NOT NULL, 				--비밀글(0-공개, 1-비밀)
	notice number(1) NOT NULL 							--공지글(0-일반, 1-공지) 
);

ALTER TABLE tblBoard ADD (secret NUMBER(1) DEFAULT 0 NOT NULL);
ALTER TABLE tblBoard ADD (notice NUMBER(1) DEFAULT 0 NOT NULL);
SELECT * FROM tblBoard;

INSERT INTO TBLBOARD (seq, subject, content, id, regdate, readcount, attach) VALUES (seqBoard.nextVal, ?, ?, ?, DEFAULT, DEFAULT, ?);


SELECT * FROM tblboard;



--해시 태그 기능
CREATE TABLE tblHashtag(
	seq NUMBER PRIMARY KEY, 				 	--번호(pk)
	hashtag varchar2(100) UNIQUE NOT NULL  --해시태그(UQ)
);

CREATE SEQUENCE seqHashtag;

CREATE TABLE tblTagging(
	seq NUMBER PRIMARY KEY, 							--번호(PK)
	bseq NUMBER NOT NULL REFERENCES tblBoard(seq), 	--글번호(FK)
	hseq NUMBER NOT NULL REFERENCES tblhashtag(seq) 	-- 태그번호(FK)
);

CREATE SEQUENCE seqTagging;
SELECT max(seq) AS seq FROM TBLBOARD;

SELECT seq FROM tblHashtag WHERE hashtag = ?;

INSERT INTO tblHashtag (seq, hashtag) VALUES (seqHashtag.nextVal, ?);

INSERT INTO tbltagging (seq, bseq, hseq) VALUES (seqTagging.nextVal, ?, ?);


SELECT * FROM tblTagging;
SELECT * FROM tblhashtag;

--작성한 해시태그 가져오기
SELECT h.hashtag
FROM tblBoard b 
	INNER JOIN tbltagging t
		ON b.SEQ = t.bseq
	INNER JOIN tblhashtag h
		ON h.SEQ = t.hseq
WHERE b.seq = 362;

SELECT h.hashtag FROM tblBoard b INNER JOIN tbltagging t ON b.SEQ = t.bseq INNER JOIN tblhashtag h ON h.SEQ = t.hseq WHERE b.seq = ?;


SELECT * FROM (SELECT a.*, rownum AS rnum FROM vwBoard a) b INNER JOIN tbltagging t ON b.seq=t.bseq INNER JOIN tblhashtag h ON h.seq=t.hseq WHERE rnum BETWEEN 1 AND 100	AND h.hashtag = '우중충...';

DROP TABLE tblscrapbook;
CREATE TABLE tblScrapBook(
	seq NUMBER PRIMARY KEY,								--번호(PK)
	bseq NUMBER NOT NULL REFERENCES tblBoard(seq),		--게시물번호(FK)
	id varchar2(50) NOT NULL REFERENCES tblUser(id),		--아이디
	regdate DATE DEFAULT sysdate NOT NULL					-- 날짜
);
CREATE SEQUENCE seqScrapBook;

SELECT * FROM tblScrapBook;

SELECT tblBoard.*, (SELECT name FROM tblUser WHERE id = tblBoard.id) AS name,(SELECT count(*) FROM tblscrapbook WHERE bseq=TBLBOARD.seq AND id=?) AS scrapbook FROM tblBoard;


--내가 즐겨찾기한 글
--SELECT * FROM vwboard WHERE 내가 즐겨찾기한 글;
SELECT * FROM vwboard WHERE seq IN (SELECT bseq FROM tblscrapbook WHERE id='hong');



CREATE TABLE tblLog(
	seq NUMBER PRIMARY KEY,
	id varchar2(50) NOT NULL REFERENCES TBLUSER(id),
	regdate DATE DEFAULT sysdate NOT NULL,
	url varchar2(300) NOT NULL
);

CREATE SEQUENCE seqLog;


SELECT * FROM tblLog;

INSERT INTO tblLog(seq, id, regdate, url) VALUES (seqLog.nextVal, ?, DEFAULT, ?);

--로그 출력용 select문
--한달간 로그인한 기록, 날짜별 글쓴 횟수, 날짜별 댓글쓴 횟수
SELECT 
	TO_CHAR(regdate, 'yyyy-mm-dd') AS regdate,
	count(*) AS lcnt, --로그인 기록
	(SELECT count(*) FROM tblBoard WHERE TO_CHAR(regdate, 'yyyy-mm-dd') = TO_CHAR(l.regdate, 'yyyy-mm-dd') AND id = 'hong') AS bcnt,
	(SELECT count(*) FROM tblComment WHERE TO_CHAR(regdate, 'yyyy-mm-dd') = TO_CHAR(l.regdate, 'yyyy-mm-dd') AND id = 'hong') AS ccnt
FROM TBLLOG l
	WHERE TO_CHAR(regdate, 'yyyy-mm') = '2025-09' AND id = 'hong'
	GROUP BY TO_CHAR(regdate, 'yyyy-mm-dd');
COMMIT;



--SELECT TO_CHAR(regdate, 'yyyy-mm-dd') AS regdate, count(*) AS lcnt, (SELECT count(*) FROM tblBoard WHERE TO_CHAR(regdate, 'yyyy-mm-dd') = TO_CHAR(l.regdate, 'yyyy-mm-dd') AND id = 'hong') AS bcnt, (SELECT count(*) FROM tblComment WHERE TO_CHAR(regdate, 'yyyy-mm-dd') = TO_CHAR(l.regdate, 'yyyy-mm-dd') AND id = 'hong') AS ccnt FROM TBLLOG l WHERE TO_CHAR(regdate, 'yyyy-mm') = '2025-09' AND id = 'hong' GROUP BY TO_CHAR(regdate, 'yyyy-mm-dd');


--더미(강아지)
--로그인기록
SELECT * FROM tbllog;
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 30, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 25, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 22, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 20, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 18, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 17, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 12, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 9, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 5, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'dog', sysdate - 3, '/toy/index.do');

INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 30, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 30, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 25, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 22, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 18, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 18, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 5, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 5, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'dog', sysdate - 5, 0, NULL, 0, 0);


SELECT * FROM tblcomment;
SELECT * FROM TBLBOARD;
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 30, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 30, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 25, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 22, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 12, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 12, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 9, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 9, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 5, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'dog', sysdate - 3, 323);



--더미(고양이)

INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'catty', sysdate - 28, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'catty', sysdate - 23, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'catty', sysdate - 14, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'catty', sysdate - 13, '/toy/index.do');

INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'catty', sysdate - 12, '/toy/index.do');
INSERT INTO tblLog(seq, id, regdate, url)
	VALUES (seqLog.nextVal, 'catty', sysdate - 9, '/toy/index.do');


INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 28, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 28, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 28, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 23, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 12, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 12, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 12, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 12, 0, NULL, 0, 0);
INSERT INTO tblboard(seq, subject, content, id, regdate, readcount, attach, secret, notice)
	VALUES (seqBoard.nextVal, '게시판입니다.', '내용', 'catty', sysdate - 9, 0, NULL, 0, 0);


INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 28, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 23, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 12, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 9, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 9, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 9, 323);
INSERT INTO TBLCOMMENT(seq, content, id, regdate, bseq) 
	VALUES (seqComment.nextVal, '댓글입니다.', 'catty', sysdate - 9, 323);


SELECT url, count(*) AS cnt
FROM tbllog 
	WHERE id = 'hong'
	GROUP BY url
	ORDER BY cnt desc;
