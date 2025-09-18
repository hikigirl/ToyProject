package com.test.toy.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommentDTO {
	private String seq;
	private String content;
	private String id;
	private String regdate;
	private String bseq;
	
	
	//작성자 이름
	private String name;
}
