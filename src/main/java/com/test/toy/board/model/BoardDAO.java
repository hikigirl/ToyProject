package com.test.toy.board.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.test.util.DBUtil;

public class BoardDAO {

	private DBUtil util;
	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;

	public BoardDAO() {
		try {
			util = new DBUtil();
			conn = util.open();
			stat = conn.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int add(BoardDTO dto) {
		// add.do에서 호출하였음
		try {
			String sql = "INSERT INTO tblboard (seq, subject, content, id, regdate, readcount) VALUES (seqBoard.nextVal, ?, ?, ?, DEFAULT, DEFAULT)";

			//현재 장소에 특정 데이터가 없는 경우
			//1. 이 장소에서 특정 데이터를 가져올 수 있는지? -> 스스로
			//2. 현재 객체를 호출한 쪽에서 특정 데이터를 전달해줄 수 있는지? -> 전달
			//로그인한 유저의 아이디 -> 세션에 저장되어 있음
			// - DAO는 세션에 접근할 수 있는가? -> dao는 서블릿이 아니라서 불가능
			// - add.do는 request 객체를 갖고있어서 세션에 접근 가능
			// - -> Add.java에서 세션값을 dto에 넣어서 여기로 가져옴 
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, dto.getSubject());
			pstat.setString(2, dto.getContent());
			pstat.setString(3, dto.getId());

			return pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	public List<BoardDTO> list() {
		//list.do에서 호출하였음
		try {
			
			String sql = "SELECT * FROM vwBoard";
			
			stat = conn.createStatement();
			rs = stat.executeQuery(sql);
			
			List<BoardDTO> list = new ArrayList<BoardDTO>();
			
			while (rs.next()) {
				
				BoardDTO dto = new BoardDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setSubject(rs.getString("subject"));
				dto.setId(rs.getString("id"));
				dto.setReadcount(rs.getString("readcount"));
				dto.setRegdate(rs.getString("regdate"));
				
				dto.setName(rs.getString("name"));
				dto.setIsnew(rs.getDouble("isnew"));
				
				list.add(dto);				
			}	
			
			return list;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		
	}

	public BoardDTO get(String seq) {
		//view.do에서 호출되었음
		try {
			
			String sql = "SELECT tblBoard.*, (SELECT name FROM tblUser WHERE id = tblBoard.id) AS name FROM tblBoard WHERE seq = ?";
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, seq);
			
			rs = pstat.executeQuery();
			
			if (rs.next()) {
				
				BoardDTO dto = new BoardDTO();
				
				dto.setSeq(rs.getString("seq"));
				dto.setSubject(rs.getString("subject"));
				dto.setId(rs.getString("id"));
				dto.setReadcount(rs.getString("readcount"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setContent(rs.getString("content"));
				dto.setName(rs.getString("name"));
				
				return dto;				
			}	
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public void updateReadCount(String seq) {
		//view.do에서 호출되었음
		try {

			String sql = "UPDATE TBLBOARD SET readcount = readcount + 1 WHERE seq=?";

			pstat = conn.prepareStatement(sql);
			pstat.setString(1, seq);

			pstat.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	
	
	

}