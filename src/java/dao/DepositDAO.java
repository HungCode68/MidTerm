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

/**
 *
 * @author Nguyễn Hùng
 */
public class DepositDAO {

    // Thêm mới một đơn đặt cọc
    public void insertDeposit(Deposit deposit) {
        String sql = "INSERT INTO Deposits (UserId, CarId, ColorExterior, ColorInterior, FullName, PhoneNumber, CCCD, Province, ShowroomId, PaymentMethod) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, deposit.getUserId());
            stmt.setInt(2, deposit.getCarId());
            stmt.setString(3, deposit.getColorExterior());
            stmt.setString(4, deposit.getColorInterior());
            stmt.setString(5, deposit.getFullName());
            stmt.setString(6, deposit.getPhoneNumber());
            stmt.setString(7, deposit.getCccd());
            stmt.setString(8, deposit.getProvince());
            stmt.setInt(9, deposit.getShowroomId());
            stmt.setString(10, deposit.getPaymentMethod());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy toàn bộ đơn đặt cọc
    public List<Deposit> getAllDeposits() {
        List<Deposit> list = new ArrayList<>();
        String sql = "SELECT * FROM Deposits";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

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

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

    // Hàm hỗ trợ để lấy dữ liệu từ ResultSet
    private Deposit extractDepositFromResultSet(ResultSet rs) throws SQLException {
        Deposit d = new Deposit();

        d.setDepositId(rs.getInt("DepositId"));
        d.setUserId(rs.getInt("UserId"));
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

        return d;
    }
}