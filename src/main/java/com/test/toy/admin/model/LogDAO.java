package com.test.toy.admin.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.test.toy.user.model.UserDTO;
import com.test.util.DBUtil;

public class LogDAO {
	private DBUtil util;
	private Connection conn;
	private Statement stat;
	private PreparedStatement pstat;
	private ResultSet rs;

	public LogDAO() {
		try {
			util = new DBUtil();
			conn = util.open();
			stat = conn.createStatement();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<UserDTO> listUser() {
		try {
			
			String sql = "select * from tblUser order by name asc";
			
			stat = conn.createStatement();
			rs = stat.executeQuery(sql);
			
			ArrayList<UserDTO> list = new ArrayList<UserDTO>();
			
			while (rs.next()) {
				
				UserDTO dto = new UserDTO();
				
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				
				list.add(dto);				
			}	
			
			return list;
			
		} catch (Exception e) {
			System.out.println("LogDAO.listUser");
			e.printStackTrace();
		}
		return null;
	}

	public List<LogDTO> listLog(LogDTO dto) {
		// loadlog.do 에서 호출
		try {
			
			//System.out.println("dto: " + dto);
			
			String sql = "SELECT TO_CHAR(regdate, 'yyyy-mm-dd') AS regdate, count(*) AS lcnt, (SELECT count(*) FROM tblBoard WHERE TO_CHAR(regdate, 'yyyy-mm-dd') = TO_CHAR(l.regdate, 'yyyy-mm-dd') AND id = ?) AS bcnt, (SELECT count(*) FROM tblComment WHERE TO_CHAR(regdate, 'yyyy-mm-dd') = TO_CHAR(l.regdate, 'yyyy-mm-dd') AND id = ?) AS ccnt FROM TBLLOG l WHERE TO_CHAR(regdate, 'yyyy-mm') = ? AND id = ? GROUP BY TO_CHAR(regdate, 'yyyy-mm-dd')";
			
			pstat = conn.prepareStatement(sql);
			pstat.setString(1, dto.getId()); //id
			pstat.setString(2, dto.getId()); //id
			pstat.setString(3, dto.getRegdate()); //날짜
			pstat.setString(4, dto.getId()); //id
			
			rs = pstat.executeQuery();
			
			List<LogDTO> list = new ArrayList<LogDTO>();
			
			while (rs.next()) {
				
				LogDTO result = new LogDTO();
				
				//setter
				result.setLcnt(rs.getString("lcnt"));
				result.setBcnt(rs.getString("bcnt"));
				result.setCcnt(rs.getString("ccnt"));
				result.setRegdate(rs.getString("regdate"));
				
				//System.out.println(result);
				
				list.add(result);				
			}	
			
			return list;
			
		} catch (Exception e) {
			System.out.println("LogDAO.listLog");
			e.printStackTrace();
		}
		
		return null;
	}

}
