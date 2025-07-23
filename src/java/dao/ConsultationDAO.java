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
   public void insertConsultation(Consultation consultation) throws SQLException, Exception {
    String sql = "INSERT INTO Consultations (UserId, FullName, PhoneNumber, CarId, RequestDate) VALUES (?, ?, ?, ?, ?)";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        if (consultation.getUserId() != null) {
            ps.setInt(1, consultation.getUserId());
        } else {
            ps.setNull(1, java.sql.Types.INTEGER);
        }
        ps.setString(2, consultation.getFullName());
        ps.setString(3, consultation.getPhoneNumber());
        ps.setInt(4, consultation.getCarId());
        ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
        ps.executeUpdate();
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
    
    // Cập nhật cuộc tư vấn
public void updateConsultation(Consultation consultation) {
    String sql = "UPDATE Consultations SET UserId = ?, CarId = ?, FullName = ? WHERE ConsultationId = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        if (consultation.getUserId() != null) {
            stmt.setInt(1, consultation.getUserId());
        } else {
            stmt.setNull(1, java.sql.Types.INTEGER);
        }

        stmt.setInt(2, consultation.getCarId());
        stmt.setString(3, consultation.getFullName());
        stmt.setInt(4, consultation.getConsultationId());

        stmt.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}


// Xóa cuộc tư vấn
public void deleteConsultation(int consultationId) {
    String sql = "DELETE FROM Consultations WHERE ConsultationId = ?";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, consultationId);
        stmt.executeUpdate();

    } catch (Exception e) {
        e.printStackTrace();
    }
}

 public List<Consultation> getFilteredConsultations(String phoneNumber, String date) {
    List<Consultation> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder("SELECT c.* FROM Consultations c LEFT JOIN Users u ON c.UserId = u.UserId WHERE 1=1");

    if (phoneNumber != null && !phoneNumber.isEmpty()) {
        sql.append(" AND (u.PhoneNumber LIKE ? OR (c.UserId IS NULL AND c.PhoneNumber LIKE ?))");
    }

    if (date != null && !date.isEmpty()) {
        sql.append(" AND CONVERT(date, c.RequestDate) = ?");
    }

    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

        int index = 1;
        if (phoneNumber != null && !phoneNumber.isEmpty()) {
            stmt.setString(index++, "%" + phoneNumber + "%");
            stmt.setString(index++, "%" + phoneNumber + "%");
        }

        if (date != null && !date.isEmpty()) {
            stmt.setString(index++, date);
        }

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
    
    // Kiểm tra UserId có NULL không
    int userId = rs.getInt("UserId");
    if (!rs.wasNull()) {
        c.setUserId(userId);
    }

    c.setCarId(rs.getInt("CarId"));
    c.setRequestDate(rs.getTimestamp("RequestDate"));

    // ✅ Thêm đọc các cột còn thiếu
    c.setFullName(rs.getString("FullName"));
    c.setPhoneNumber(rs.getString("PhoneNumber"));

    return c;
}

}
