-- ToyProject -> script.sql

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

INSERT INTO tblboard (seq, subject, content, id, regdate, readcount) VALUES (seqBoard.nextVal, '게시판샘플', '게시판에 작성한 내용입니다. 푸딩의 효능..');

