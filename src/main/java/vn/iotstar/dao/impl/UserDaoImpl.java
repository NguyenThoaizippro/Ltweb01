package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import vn.iotstar.connection.DBConnection;
import vn.iotstar.dao.UserDao;
import vn.iotstar.model.User;

public class UserDaoImpl extends DBConnection implements UserDao {

	public Connection conn = null;
	public PreparedStatement ps = null;
	public ResultSet rs = null;

	private User mapUser(ResultSet rs) throws Exception {
		User user = new User();
		user.setId(rs.getInt("id"));
		user.setEmail(rs.getString("email"));
		user.setUserName(rs.getString("username"));
		user.setFullName(rs.getString("fullname"));
		user.setPassWord(rs.getString("password"));
		user.setAvatar(rs.getString("avatar"));
		user.setRoleid(rs.getInt("roleid"));
		user.setPhone(rs.getString("phone"));
		user.setCreatedDate(rs.getDate("createdDate"));
		try {
			user.setIsActive(rs.getInt("isActive"));
		} catch (Exception e) {
			user.setIsActive(1); // fallback if column not present yet
		}
		return user;
	}

	@Override
	public User get(String username) {
		String sql = "SELECT * FROM [User] WHERE username = ?";
		try {
			conn = super.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, username);
			rs = ps.executeQuery();
			if (rs.next()) {
				return mapUser(rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception e) { /* ignored */ }
			try { if (ps != null) ps.close(); } catch (Exception e) { /* ignored */ }
			try { if (conn != null) conn.close(); } catch (Exception e) { /* ignored */ }
		}
		return null;
	}

	@Override
	public User getByEmail(String email) {
		String sql = "SELECT * FROM [User] WHERE email = ?";
		try {
			conn = super.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, email);
			rs = ps.executeQuery();
			if (rs.next()) {
				return mapUser(rs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try { if (rs != null) rs.close(); } catch (Exception e) { /* ignored */ }
			try { if (ps != null) ps.close(); } catch (Exception e) { /* ignored */ }
			try { if (conn != null) conn.close(); } catch (Exception e) { /* ignored */ }
		}
		return null;
	}

	@Override
	public void insert(User user) {
		String sqlWithActive = "INSERT INTO [User](email, username, fullname, password, avatar, roleid, phone, createdDate, isActive) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
		String sqlFallback = "INSERT INTO [User](email, username, fullname, password, avatar, roleid, phone, createdDate) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			conn = super.getConnection();
			try {
				ps = conn.prepareStatement(sqlWithActive);
				ps.setString(1, user.getEmail());
				ps.setString(2, user.getUserName());
				ps.setString(3, user.getFullName() != null ? user.getFullName() : user.getUserName());
				ps.setString(4, user.getPassWord());
				ps.setString(5, user.getAvatar() != null ? user.getAvatar() : "avatar.png");
				ps.setInt(6, user.getRoleid() > 0 ? user.getRoleid() : 3);
				ps.setString(7, user.getPhone() != null ? user.getPhone() : "");
				ps.setDate(8, user.getCreatedDate() != null ? user.getCreatedDate() : new java.sql.Date(System.currentTimeMillis()));
				ps.setInt(9, user.getIsActive());
				ps.executeUpdate();
			} catch (Exception ex) {
				// If column isActive does not exist in schema yet, fallback
				if (ps != null) ps.close();
				ps = conn.prepareStatement(sqlFallback);
				ps.setString(1, user.getEmail());
				ps.setString(2, user.getUserName());
				ps.setString(3, user.getFullName() != null ? user.getFullName() : user.getUserName());
				ps.setString(4, user.getPassWord());
				ps.setString(5, user.getAvatar() != null ? user.getAvatar() : "avatar.png");
				ps.setInt(6, user.getRoleid() > 0 ? user.getRoleid() : 3);
				ps.setString(7, user.getPhone() != null ? user.getPhone() : "");
				ps.setDate(8, user.getCreatedDate() != null ? user.getCreatedDate() : new java.sql.Date(System.currentTimeMillis()));
				ps.executeUpdate();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try { if (ps != null) ps.close(); } catch (Exception e) { /* ignored */ }
			try { if (conn != null) conn.close(); } catch (Exception e) { /* ignored */ }
		}
	}

	@Override
	public void updateActiveByEmail(String email, int isActive) {
		String sql = "UPDATE [User] SET isActive = ? WHERE email = ?";
		try {
			conn = super.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setInt(1, isActive);
			ps.setString(2, email);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try { if (ps != null) ps.close(); } catch (Exception e) { /* ignored */ }
			try { if (conn != null) conn.close(); } catch (Exception e) { /* ignored */ }
		}
	}

	@Override
	public void updatePassword(User user) {
		String sql = "UPDATE [User] SET password = ? WHERE email = ? OR username = ?";
		try {
			conn = super.getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, user.getPassWord());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getUserName());
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try { if (ps != null) ps.close(); } catch (Exception e) { /* ignored */ }
			try { if (conn != null) conn.close(); } catch (Exception e) { /* ignored */ }
		}
	}
}
