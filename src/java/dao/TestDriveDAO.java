/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import model.TestDrive;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Nguyễn Hùng
 */
public class TestDriveDAO {
    private Connection conn;

    public TestDriveDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy danh sách toàn bộ lịch lái thử
    public List<TestDrive> getAllTestDrives() throws SQLException {
        List<TestDrive> list = new ArrayList<>();
        String sql = "SELECT * FROM TestDrives ORDER BY ScheduledTime DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            TestDrive td = new TestDrive(
                rs.getInt("TestDriveId"),
                rs.getInt("UserId"),
                rs.getInt("CarId"),
                rs.getString("FullName"),
                rs.getString("PhoneNumber"),
                rs.getString("Province"),
                rs.getString("Address"),
                rs.getTimestamp("ScheduledTime"),
                rs.getTimestamp("CreatedAt")
            );
            list.add(td);
        }
        return list;
    }

    // Thêm lịch lái thử mới
    public void insertTestDrive(TestDrive td) throws SQLException {
        String sql = "INSERT INTO TestDrives (UserId, CarId, FullName, PhoneNumber, Province, Address, ScheduledTime) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, td.getUserId());
        ps.setInt(2, td.getCarId());
        ps.setString(3, td.getFullName());
        ps.setString(4, td.getPhoneNumber());
        ps.setString(5, td.getProvince());
        ps.setString(6, td.getAddress());
        ps.setTimestamp(7, td.getScheduledTime());
        ps.executeUpdate();
    }

    // Tìm lịch lái thử theo ID
    public TestDrive getTestDriveById(int id) throws SQLException {
        String sql = "SELECT * FROM TestDrives WHERE TestDriveId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new TestDrive(
                rs.getInt("TestDriveId"),
                rs.getInt("UserId"),
                rs.getInt("CarId"),
                rs.getString("FullName"),
                rs.getString("PhoneNumber"),
                rs.getString("Province"),
                rs.getString("Address"),
                rs.getTimestamp("ScheduledTime"),
                rs.getTimestamp("CreatedAt")
            );
        }
        return null;
    }

    // Xóa lịch lái thử theo ID
    public void deleteTestDrive(int id) throws SQLException {
        String sql = "DELETE FROM TestDrives WHERE TestDriveId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }
}
