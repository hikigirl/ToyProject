package com.test.toy.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import com.test.util.DBUtil;

public class Dummy {
	
	private static DBUtil util;
	private static Connection conn;
	private static Statement stat;
	private static PreparedStatement pstat;
	private static ResultSet rs;

	static {
		try {
			util = new DBUtil();
			conn = util.open();
			stat = conn.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		//m1();
		//m2();
	}

	private static void m2() {
		// 댓글 여러개 등록
		try {

			String sql = "INSERT INTO tblcomment (seq, content, id, regdate, bseq) VALUES (seqComment.nextVal, ?, ?, DEFAULT, ?)";
			pstat = conn.prepareStatement(sql);
			pstat.setString(2, "catty");
			pstat.setString(3, "301");
			
			for (int i=0; i<45; i++) {
				pstat.setString(1, "댓글 페이징 " + i);

				pstat.executeUpdate();
				
			}
			
			System.out.println("m2 완료");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void m1() {
		// 게시물 여러개 등록
		try {

			String sql = "INSERT INTO tblboard (seq, subject, content, id, regdate, readcount) VALUES (seqBoard.nextVal, ?, ?, ?, DEFAULT, DEFAULT)";
			pstat = conn.prepareStatement(sql);
			pstat.setString(2, "내용");
			pstat.setString(3, "catty");
			
			for (int i=0; i<250; i++) {
				pstat.setString(1, "게시판 페이징" + i);

				pstat.executeUpdate();
				
			}
			
			System.out.println("m1 완료");

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}
