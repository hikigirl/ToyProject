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
- __com.test.toy.user.model__
  - UserDAO.java
  - UserDTO.java
- __com.test.toy.board(게시판 패키지)__
  - List.java
  - View.java
  - Add.java
  - Edit.java
  - Del.java
  - Dummy.java: 더미데이터용
- __com.test.toy.board.model__
  - BoardDAO.java
  - BoardDTO.java
  - CommentDTO.java
  - ~~CommentDAO.java~~
- __com.test.toy.filter__
  - EncodingFilter.java(인코딩 처리를 위한 필터)
  - AuthFilter.java
- __com.test.toy.comment__ : Ajax 응답용 서블릿
  - AddComment.java
  - DelComment.java
  - EditComment.java
  - MoreComment.java

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
- webapp/asset/place
  - 첨부파일 저장용도

---

### 게시판 정책

1. 목록보기, 상세보기 -> 로그인, 비로그인 모두
2. 글쓰기, 수정하기, 삭제하기, 가입정보 -> 로그인 유저만, 노출 제어 방식으로
3. 수정, 삭제하기 -> 로그인 + 글 쓴 본인만 가능
4. 수정, 삭제하기 -> 관리자는 모든 글에 대해 가능

---

## 필터

### EncodingFilter.java

- javax.servlet 패키지의 Filter 인터페이스를 상속받는다.
- __`doFilter()`__, `init()`, `destroy()` 메서드를 오버라이딩
- 톰캣 차원에서 관리한다
- 사용하기 전에 등록이 필요 → 톰캣에게 알려줘야 함(web.xml)
- `web.xml`에 구현한 필터 순서 = 필터 실행 순서

---

#### 글 제목이나 내용에 태그가 작성될 때

textarea나 input 태그에 작성한 내용이 태그라면 그대로 실행되므로 escape 시켜줘야한다. <br>
escape하는 시점은?
1. ~~DB에 입력할 때부터 바꾸기~~ -> 원본은 훼손하지 않는다
2. **원본은 두고 꺼낼 때 바꾸기**
   1. 원본을 저장할 때에는 사용자가 입력한 값 그대로 DB에 저장한다.
   2. 사용할 때에 조작해서 사용한다.
   
#### 조회수 정책

사이트마다 정책이 조금씩 다름

#### 페이징

- 게시물을 일정 개수만큼 가져오는 기법
- 페이지 길어짐(네트워크 트래픽, 성능 저하)
- 페이지 개념 -> 오라클(rownum, fetch)
- 1페이지당 10개씩 보여줄 예정

#### 댓글 작성, 수정, 삭제 및 댓글 페이징

- ajax로 처리
- 댓글 페이징 -> 더보기 버튼 눌러서 더 불러오는 식으로...

#### 첨부파일 기능
- input type="file"에서..
  - accept 속성에 mime타입을 적어서 첨부파일을 필터링하는 것이 가능하다
- 파일에 저장된 메타 정보를 읽어오기(GPS 정보 등등)

#### 해시태그 기능

- tagify 라이브러리 사용

#### 비밀글 기능
1. 그냥글 - 모두 공개
2. 비밀글 - 작성자가 로그인 시 작성자에게만 공개
3. 비밀글 - 작성자가 아닌 사람 로그인 시 클릭 막기