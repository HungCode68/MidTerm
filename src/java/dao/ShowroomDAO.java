/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import context.DBContext;
import model.Showroom;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Nguyễn Hùng
 */
public class ShowroomDAO {

    // Lấy toàn bộ showroom
    public List<Showroom> getAllShowrooms() {
        List<Showroom> list = new ArrayList<>();
        String sql = "SELECT * FROM Showrooms";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Showroom s = new Showroom();
                s.setShowroomId(rs.getInt("ShowroomId"));
                s.setName(rs.getString("Name"));
                s.setAddress(rs.getString("Address"));
                s.setProvince(rs.getString("Province"));
                s.setDistrict(rs.getString("District"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy showroom theo ID
    public Showroom getShowroomById(int id) {
        String sql = "SELECT * FROM Showrooms WHERE ShowroomId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Showroom(
                        rs.getInt("ShowroomId"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getString("Province"),
                        rs.getString("District")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Thêm showroom
    public void insertShowroom(Showroom showroom) {
        String sql = "INSERT INTO Showrooms (Name, Address, Province, District) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, showroom.getName());
            stmt.setString(2, showroom.getAddress());
            stmt.setString(3, showroom.getProvince());
            stmt.setString(4, showroom.getDistrict());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật showroom
    public void updateShowroom(Showroom showroom) {
        String sql = "UPDATE Showrooms SET Name = ?, Address = ?, Province = ?, District = ? WHERE ShowroomId = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, showroom.getName());
            stmt.setString(2, showroom.getAddress());
            stmt.setString(3, showroom.getProvince());
            stmt.setString(4, showroom.getDistrict());
            stmt.setInt(5, showroom.getShowroomId());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá showroom
    public void deleteShowroom(int showroomId) {
        String sql = "DELETE FROM Showrooms WHERE ShowroomId = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, showroomId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

