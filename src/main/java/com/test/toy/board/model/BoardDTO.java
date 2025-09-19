package com.test.toy.board.model;

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
}