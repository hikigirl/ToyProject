package com.test.toy.board.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardDTO {
	private String seq;
	private String subject;
	private String content;
	private String id;
	private String regdate;
	private String readcount;
	
	private String name;
	private double isnew; //최신글인지 구별하는 용도
	private String commentCount; //댓글 수 확인
	private String attach; //첨부파일
	private List<String> hashtag; //해시태그
	private String secret; //비밀글
	private String notice; //공지글
	private String scrapbook; //즐겨찾기 유무
	
	
}