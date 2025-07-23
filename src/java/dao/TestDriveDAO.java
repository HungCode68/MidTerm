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
        if (td.getUserId() != null) {
            ps.setInt(1, td.getUserId());
        } else {
            ps.setNull(1, java.sql.Types.INTEGER);
        }

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

    // Cập nhật lịch lái thử
    public void updateTestDrive(TestDrive td) throws SQLException {
        String sql = "UPDATE TestDrives SET UserId = ?, CarId = ?, FullName = ?, PhoneNumber = ?, Province = ?, Address = ?, ScheduledTime = ? WHERE TestDriveId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        if (td.getUserId() != null) {
            ps.setInt(1, td.getUserId());
        } else {
            ps.setNull(1, java.sql.Types.INTEGER);
        }
        ps.setInt(2, td.getCarId());
        ps.setString(3, td.getFullName());
        ps.setString(4, td.getPhoneNumber());
        ps.setString(5, td.getProvince());
        ps.setString(6, td.getAddress());
        ps.setTimestamp(7, td.getScheduledTime());
        ps.setInt(8, td.getTestDriveId());
        ps.executeUpdate();
    }

// Lọc theo số điện thoại hoặc ngày (yyyy-MM-dd)
    public List<TestDrive> getFilteredTestDrives(String phone, String date) throws SQLException {
        List<TestDrive> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM TestDrives WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (phone != null && !phone.trim().isEmpty()) {
            sql.append(" AND PhoneNumber LIKE ?");
            params.add("%" + phone.trim() + "%");
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND CONVERT(DATE, ScheduledTime) = ?");
            params.add(Date.valueOf(date)); // cần format date đúng kiểu yyyy-MM-dd
        }

        sql.append(" ORDER BY ScheduledTime DESC");

        PreparedStatement ps = conn.prepareStatement(sql.toString());
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

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

// Lấy danh sách lịch lái thử kèm tên xe
    public List<TestDrive> getAllTestDrivesWithCarName() throws SQLException {
        List<TestDrive> list = new ArrayList<>();
        String sql = "SELECT td.*, c.ModelName FROM TestDrives td JOIN Cars c ON td.CarId = c.CarId ORDER BY td.ScheduledTime DESC";
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
            td.setCarName(rs.getString("ModelName")); // Thêm dòng này (yêu cầu TestDrive có thuộc tính carName)
            list.add(td);
        }
        return list;
    }

    // Xóa lịch lái thử theo ID
    public void deleteTestDrive(int id) throws SQLException {
        String sql = "DELETE FROM TestDrives WHERE TestDriveId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }
}
