/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import context.DBContext;
import model.Consultation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Nguyễn Hùng
 */
public class ConsultationDAO {

    // Thêm mới một cuộc tư vấn
    public void insertConsultation(Consultation consultation) {
        String sql = "INSERT INTO Consultations (UserId, CarId) VALUES (?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, consultation.getUserId());
            stmt.setInt(2, consultation.getCarId());

            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách tất cả cuộc tư vấn
    public List<Consultation> getAllConsultations() {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM Consultations";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Consultation c = extractFromResultSet(rs);
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy danh sách cuộc tư vấn theo userId
    public List<Consultation> getConsultationsByUserId(int userId) {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM Consultations WHERE UserId = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Consultation c = extractFromResultSet(rs);
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Hàm hỗ trợ để tạo đối tượng Consultation từ ResultSet
    private Consultation extractFromResultSet(ResultSet rs) throws SQLException {
        Consultation c = new Consultation();

        c.setConsultationId(rs.getInt("ConsultationId"));
        c.setUserId(rs.getInt("UserId"));
        c.setCarId(rs.getInt("CarId"));
        c.setRequestDate(rs.getTimestamp("RequestDate"));

        return c;
    }
}
