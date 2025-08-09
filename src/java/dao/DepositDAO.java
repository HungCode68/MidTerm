/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import context.DBContext;
import model.Deposit;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author Nguyễn Hùng
 */
public class DepositDAO {

    // Thêm mới một đơn đặt cọc
    public void insertDeposit(Deposit deposit) {
        String sql = "INSERT INTO Deposits (UserId, CarId, ColorExterior, ColorInterior, FullName, PhoneNumber, CCCD, Province, ShowroomId, PaymentMethod, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (deposit.getUserId() != null) {
                stmt.setInt(1, deposit.getUserId());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }

            stmt.setInt(2, deposit.getCarId());
            stmt.setString(3, deposit.getColorExterior());
            stmt.setString(4, deposit.getColorInterior());
            stmt.setString(5, deposit.getFullName());
            stmt.setString(6, deposit.getPhoneNumber());
            stmt.setString(7, deposit.getCccd());
            stmt.setString(8, deposit.getProvince());
            stmt.setInt(9, deposit.getShowroomId());
            stmt.setString(10, deposit.getPaymentMethod());
            stmt.setString(11, deposit.getStatus() != null ? deposit.getStatus() : "pending");

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật đơn đặt cọc (bao gồm cả status)
    public void updateDeposit(Deposit deposit) {
        String sql = "UPDATE Deposits SET UserId = ?, CarId = ?, ColorExterior = ?, ColorInterior = ?, "
                + "FullName = ?, PhoneNumber = ?, CCCD = ?, Province = ?, ShowroomId = ?, PaymentMethod = ?, Status = ? "
                + "WHERE DepositId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (deposit.getUserId() != null) {
                stmt.setInt(1, deposit.getUserId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }

            stmt.setInt(2, deposit.getCarId());
            stmt.setString(3, deposit.getColorExterior());
            stmt.setString(4, deposit.getColorInterior());
            stmt.setString(5, deposit.getFullName());
            stmt.setString(6, deposit.getPhoneNumber());
            stmt.setString(7, deposit.getCccd());
            stmt.setString(8, deposit.getProvince());
            stmt.setInt(9, deposit.getShowroomId());
            stmt.setString(10, deposit.getPaymentMethod());
            stmt.setString(11, deposit.getStatus());
            stmt.setInt(12, deposit.getDepositId());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá đơn đặt cọc theo id
    public void deleteDeposit(int depositId) {
        String sql = "DELETE FROM Deposits WHERE DepositId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, depositId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy toàn bộ đơn đặt cọc
    public List<Deposit> getAllDeposits() {
        List<Deposit> list = new ArrayList<>();
        String sql = "SELECT * FROM Deposits";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Deposit d = extractDepositFromResultSet(rs);
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy các đơn đặt cọc theo userId
    public List<Deposit> getDepositsByUserId(int userId) {
        List<Deposit> list = new ArrayList<>();
        String sql = "SELECT * FROM Deposits WHERE UserId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Deposit d = extractDepositFromResultSet(rs);
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Deposit> getAllDepositsWithNames() {
        List<Deposit> list = new ArrayList<>();
        String sql = "SELECT d.*, c.ModelName AS CarName, s.Name AS ShowroomName, u.FullName AS UserName "
                + "FROM Deposits d "
                + "JOIN Cars c ON d.CarId = c.CarId "
                + "JOIN Showrooms s ON d.ShowroomId = s.ShowroomId "
                + "LEFT JOIN Users u ON d.UserId = u.UserId";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Deposit d = new Deposit();
                d.setDepositId(rs.getInt("DepositId"));
                d.setUserId(rs.getObject("UserId") != null ? rs.getInt("UserId") : null);
                d.setCarId(rs.getInt("CarId"));
                d.setColorExterior(rs.getString("ColorExterior"));
                d.setColorInterior(rs.getString("ColorInterior"));
                d.setFullName(rs.getString("FullName"));
                d.setPhoneNumber(rs.getString("PhoneNumber"));
                d.setCccd(rs.getString("CCCD"));
                d.setProvince(rs.getString("Province"));
                d.setShowroomId(rs.getInt("ShowroomId"));
                d.setPaymentMethod(rs.getString("PaymentMethod"));
                d.setDepositDate(rs.getTimestamp("DepositDate"));
                d.setStatus(rs.getString("Status"));
                d.setCarName(rs.getString("CarName"));
                d.setShowroomName(rs.getString("ShowroomName"));
                d.setUserName(rs.getString("UserName"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Deposit> getFilteredDeposits(String phone, String status) {
        List<Deposit> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT d.*, c.ModelName AS CarName, s.Name AS ShowroomName, u.FullName AS UserName "
                + "FROM Deposits d "
                + "JOIN Cars c ON d.CarId = c.CarId "
                + "JOIN Showrooms s ON d.ShowroomId = s.ShowroomId "
                + "LEFT JOIN Users u ON d.UserId = u.UserId "
                + "WHERE 1=1 "
        );

        if (phone != null && !phone.isEmpty()) {
            sql.append("AND d.PhoneNumber LIKE ? ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND d.Status = ? ");
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (phone != null && !phone.isEmpty()) {
                ps.setString(index++, "%" + phone + "%");
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Deposit d = new Deposit();
                    d.setDepositId(rs.getInt("DepositId"));
                    d.setUserId(rs.getObject("UserId") != null ? rs.getInt("UserId") : null);
                    d.setCarId(rs.getInt("CarId"));
                    d.setColorExterior(rs.getString("ColorExterior"));
                    d.setColorInterior(rs.getString("ColorInterior"));
                    d.setFullName(rs.getString("FullName"));
                    d.setPhoneNumber(rs.getString("PhoneNumber"));
                    d.setCccd(rs.getString("CCCD"));
                    d.setProvince(rs.getString("Province"));
                    d.setShowroomId(rs.getInt("ShowroomId"));
                    d.setPaymentMethod(rs.getString("PaymentMethod"));
                    d.setDepositDate(rs.getTimestamp("DepositDate"));
                    d.setStatus(rs.getString("Status"));
                    d.setCarName(rs.getString("CarName"));
                    d.setShowroomName(rs.getString("ShowroomName"));
                    d.setUserName(rs.getString("UserName"));
                    list.add(d);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<Deposit> getFilteredDeposits(String phone, String status, Integer day, Integer month, Integer year) throws Exception {
    List<Deposit> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT d.*, c.modelName, s.name as showroomName FROM Deposits d " +
                                          "JOIN Cars c ON d.carId = c.carId " +
                                          "JOIN Showrooms s ON d.showroomId = s.showroomId WHERE 1=1 ");

    List<Object> params = new ArrayList<>();

    if (phone != null && !phone.trim().isEmpty()) {
        sql.append(" AND d.phoneNumber LIKE ?");
        params.add("%" + phone + "%");
    }

    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND d.status = ?");
        params.add(status);
    }

    if (day != null) {
        sql.append(" AND DAY(d.depositDate) = ?");
        params.add(day);
    }

    if (month != null) {
        sql.append(" AND MONTH(d.depositDate) = ?");
        params.add(month);
    }

    if (year != null) {
        sql.append(" AND YEAR(d.depositDate) = ?");
        params.add(year);
    }

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Deposit d = extractDepositFromResultSet(rs);
            list.add(d);
        }
    }

    return list;
}
    
    public List<Deposit> getFilteredDepositsWithNames(String phone, String status, Integer day, Integer month, Integer year) throws Exception {
    List<Deposit> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder();
    List<Object> params = new ArrayList<>();

    sql.append("SELECT d.*, u.fullName, u.phoneNumber, c.modelName, s.name AS showroomName ");
    sql.append("FROM Deposits d ");
    sql.append("LEFT JOIN Users u ON d.userId = u.userId ");
    sql.append("LEFT JOIN Cars c ON d.carId = c.carId ");
    sql.append("LEFT JOIN Showrooms s ON d.showroomId = s.showroomId ");
    sql.append("WHERE 1 = 1 ");

    if (phone != null && !phone.trim().isEmpty()) {
        sql.append(" AND u.phoneNumber LIKE ? ");
        params.add("%" + phone.trim() + "%");
    }

    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND d.status = ? ");
        params.add(status.trim());
    }

    if (day != null) {
        sql.append(" AND DAY(d.depositDate) = ? ");
        params.add(day);
    }

    if (month != null) {
        sql.append(" AND MONTH(d.depositDate) = ? ");
        params.add(month);
    }

    if (year != null) {
        sql.append(" AND YEAR(d.depositDate) = ? ");
        params.add(year);
    }

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Deposit d = extractDepositFromResultSet(rs);
            d.setFullName(rs.getString("fullName"));
            d.setPhoneNumber(rs.getString("phoneNumber"));
            d.setCarName(rs.getString("modelName"));
            d.setShowroomName(rs.getString("showroomName"));
            list.add(d);
        }
    }

    return list;
}



    // Hàm hỗ trợ để lấy dữ liệu từ ResultSet
    private Deposit extractDepositFromResultSet(ResultSet rs) throws SQLException {
        Deposit d = new Deposit();

        d.setDepositId(rs.getInt("DepositId"));
        int userId = rs.getInt("UserId");
        d.setUserId(rs.wasNull() ? 0 : userId); // Gán 0 nếu là null
        d.setCarId(rs.getInt("CarId"));
        d.setColorExterior(rs.getString("ColorExterior"));
        d.setColorInterior(rs.getString("ColorInterior"));
        d.setFullName(rs.getString("FullName"));
        d.setPhoneNumber(rs.getString("PhoneNumber"));
        d.setCccd(rs.getString("CCCD"));
        d.setProvince(rs.getString("Province"));
        d.setShowroomId(rs.getInt("ShowroomId"));
        d.setPaymentMethod(rs.getString("PaymentMethod"));
        d.setDepositDate(rs.getTimestamp("DepositDate"));
        d.setStatus(rs.getString("Status"));
        
        

        return d;
    }
}
