# ToyProject
### 새 프로젝트 만들기
- New dynamic web project
  - project name: ToyProject
  - context root: toy
  - web.xml 체크

## 프로젝트 설계
1. 주제 - 미정
2. 요구분석
   1. 회원관리(가입,로그인, 탈퇴)
   2. 게시판
   3. 기타등등
3. 페이지 구성(관계도)
4. 

### 파일, 라이브러리 세팅
#### 라이브러리
- ojdbc.jar
- myutil.jar
- lombok.jar
- json-simple.jar
- jstl.jar
  
#### 파일
- script.sql
- map 프로젝트에 있는 marker 폴더 복사
  
#### 패키지
- com.test.place(일반 페이지)
  - Index.java
- views
  - index.jsp
- com.test.place.data (ajax 처리용)
  - ListPlace.java
  - AddPlace.java
  - DelPlace.java
- com.test.place.model(DB 처리용)
  - PlaceDAO.java
  - CategoryDTO.java
  - PlaceDTO.java