/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import model.User;
import java.sql.*;
import java.util.*;
import context.DBContext;
/**
 *
 * @author Nguyễn Hùng
 */
public class UserDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Đăng ký người dùng mới
    public boolean registerUser(User user) {
        String query = "INSERT INTO Users (FullName, PhoneNumber, Email, PasswordHash, Role, CCCD) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhoneNumber());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getCccd());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeAll();
        }
    }

    // Đăng nhập: Tìm user theo Email và Mật khẩu
   public User getUserByEmail(String email) {
    User user = null;
    String sql = "SELECT * FROM Users WHERE Email = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            user = new User();
            user.setUserId(rs.getInt("UserId"));
            user.setFullName(rs.getString("FullName"));
            user.setPhoneNumber(rs.getString("PhoneNumber"));
            user.setEmail(rs.getString("Email"));
            user.setPasswordHash(rs.getString("PasswordHash"));
            user.setRole(rs.getString("Role"));
            user.setCccd(rs.getString("CCCD"));
            user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return user;
}


    // Kiểm tra email đã tồn tại chưa
    public boolean isEmailExists(String email) {
        String query = "SELECT UserId FROM Users WHERE Email = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll();
        }
        return false;
    }

    // Lấy User theo ID
    public User getUserById(int userId) {
        String query = "SELECT * FROM Users WHERE UserId = ?";
        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll();
        }
        return null;
    }

    // Helper: Chuyển từ ResultSet sang User
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("UserId"));
        user.setFullName(rs.getString("FullName"));
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setEmail(rs.getString("Email"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setRole(rs.getString("Role"));
        user.setCccd(rs.getString("CCCD"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return user;
    }

    // Đóng kết nối JDBC
    private void closeAll() {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
}
