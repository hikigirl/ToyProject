# ToyProject
### 새 프로젝트 만들기
- New dynamic web project
  - project name: ToyProject
  - context root: toy
  - web.xml 체크

## 프로젝트 설계 및 진행 과정

1. 주제 - 미정
2. 요구분석
   1. 회원관리(가입,로그인, 탈퇴)
   2. 게시판
   3. 기타등등
3. 페이지 구성(관계도)
   1. draw.io
4. 화면설계도 & 스토리보드 - 생략
5. DB설계
   1. ERD
6. 스크립트
   1. DDL, DML
7. 구현
   1. 패키지+서블릿
   2. jsp

### 파일, 라이브러리 세팅
#### 라이브러리
- ojdbc.jar
- myutil.jar
- lombok.jar
- json-simple.jar
- jstl.jar
- cos.jar

#### 패키지, 서블릿
- com.test.toy(메인 패키지)
  - Index.java
  - Template.java
- __com.test.toy.user(회원 패키지)__
  - Register.java: 회원가입폼+처리
  - Unregister.java: 회원탈퇴
  - Login.java: 로그인
  - Logout.java: 로그아웃
  - Info.java: 회원정보
- com.test.toy.user.model
  - UserDAO.java
  - UserDTO.java
- __com.test.toy.board(게시판 패키지)__
  - List.java
  - View.java
  - Add.java
  - Edit.java
  - Del.java
- com.test.toy.board.model
  - BoardDAO.java
  - BoardDTO.java
- __com.test.toy.filter__
  - EncodingFilter.java(인코딩 처리를 위한 필터)

#### JSP

- WEB-INF/views
  - index.jsp
  - template.jsp
- views/user
  - register.jsp
  - unregister.jsp
  - login.jsp
  - ~~logout.jsp~~
  - info.jsp
- views/board
  - list.jsp
  - view.jsp
  - add.jsp
  - edit.jsp
  - del.jsp

#### 공통 리소스

- script.sql
- views/inc(조각페이지)
  - asset.jsp
  - header.jsp
- webapp/asset/css
  - main.css
- webapp/asset/js
  - main.js
- webapp/asset/images
- webapp/asset/pic
  - 프로필 사진...

---

## 필터

### EncodingFilter.java

- javax.servlet 패키지의 Filter 인터페이스를 상속받는다.
- __`doFilter()`__, `init()`, `destroy()` 메서드를 오버라이딩
- 톰캣 차원에서 관리한다
- 사용하기 전에 등록이 필요 -> 톰캣에게 알려줘야 함(web.xml)
- 