/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import context.DBContext;
import model.ServiceInvoice;
import java.sql.Connection;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.MaintenanceBooking;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 *
 * @author Nguyễn Hùng
 */
public class ServiceInvoiceDAO {

    // Lấy danh sách tất cả hóa đơn
    public List<ServiceInvoice> getAllInvoices() {
        List<ServiceInvoice> list = new ArrayList<>();
        String sql = "SELECT * FROM ServiceInvoices";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ServiceInvoice invoice = extractInvoice(rs);
                list.add(invoice);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   public void insertInvoice(ServiceInvoice invoice) {
    String sqlWithBooking = """
        INSERT INTO ServiceInvoices 
        (UserId, BookingId, TotalAmount, PaymentDate, Status, PhoneNumber, FullName) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

    String sqlWithService = """
        INSERT INTO ServiceInvoices 
        (UserId, ServiceName, TotalAmount, PaymentDate, Status, PhoneNumber, FullName) 
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

    try (Connection conn = DBContext.getConnection()) {
        if (invoice.getUserId() == null) {
            // Trường hợp không có tài khoản => dùng ServiceId (bạn lưu tên dịch vụ từ serviceId)
            // Truy vấn tên dịch vụ từ bảng MaintenanceServices
            String serviceName = getServiceNameById(invoice.getServiceId(), conn);
            try (PreparedStatement stmt = conn.prepareStatement(sqlWithService)) {
                stmt.setNull(1, Types.INTEGER);
                stmt.setString(2, serviceName); // ServiceName là varchar
                stmt.setDouble(3, invoice.getTotalAmount());
                stmt.setTimestamp(4, new Timestamp(invoice.getPaymentDate().getTime()));
                stmt.setString(5, invoice.getStatus());
                stmt.setString(6, invoice.getPhoneNumber());
                stmt.setString(7, invoice.getFullName());
                stmt.executeUpdate();
            }

        } else {
            // Có userId => insert theo BookingId
            try (PreparedStatement stmt = conn.prepareStatement(sqlWithBooking)) {
                stmt.setInt(1, invoice.getUserId());
                stmt.setInt(2, invoice.getBookingId());
                stmt.setDouble(3, invoice.getTotalAmount());
                stmt.setTimestamp(4, new Timestamp(invoice.getPaymentDate().getTime()));
                stmt.setString(5, invoice.getStatus());
                stmt.setString(6, invoice.getPhoneNumber());
                stmt.setString(7, invoice.getFullName());
                stmt.executeUpdate();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}


    public void updateInvoice(ServiceInvoice invoice) {
    String sqlWithBooking = """
        UPDATE ServiceInvoices 
        SET UserId = ?, BookingId = ?, TotalAmount = ?, PaymentDate = ?, Status = ?, 
            PhoneNumber = NULL, FullName = NULL, ServiceName = NULL
        WHERE InvoiceId = ?
    """;

    String sqlWithService = """
        UPDATE ServiceInvoices 
        SET UserId = NULL, BookingId = NULL, ServiceName = ?, TotalAmount = ?, PaymentDate = ?, Status = ?, 
            PhoneNumber = ?, FullName = ?
        WHERE InvoiceId = ?
    """;

    try (Connection conn = DBContext.getConnection()) {
        if (invoice.getUserId() == null) {
            // Không có tài khoản, cập nhật theo service
            String serviceName = getServiceNameById(invoice.getServiceId(), conn);
            try (PreparedStatement stmt = conn.prepareStatement(sqlWithService)) {
                stmt.setString(1, serviceName);
                stmt.setDouble(2, invoice.getTotalAmount());
                stmt.setTimestamp(3, new Timestamp(invoice.getPaymentDate().getTime()));
                stmt.setString(4, invoice.getStatus());
                stmt.setString(5, invoice.getPhoneNumber());
                stmt.setString(6, invoice.getFullName());
                stmt.setInt(7, invoice.getInvoiceId());
                stmt.executeUpdate();
            }

        } else {
            // Có tài khoản => cập nhật theo booking
            try (PreparedStatement stmt = conn.prepareStatement(sqlWithBooking)) {
                stmt.setInt(1, invoice.getUserId());
                stmt.setInt(2, invoice.getBookingId());
                stmt.setDouble(3, invoice.getTotalAmount());
                stmt.setTimestamp(4, new Timestamp(invoice.getPaymentDate().getTime()));
                stmt.setString(5, invoice.getStatus());
                stmt.setInt(6, invoice.getInvoiceId());
                stmt.executeUpdate();
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}


    // Xóa hóa đơn
    public void deleteInvoice(int invoiceId) {
        String sql = "DELETE FROM ServiceInvoices WHERE InvoiceId = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, invoiceId);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

   public List<ServiceInvoice> filterInvoices(String phoneNumber, Date date) {
    List<ServiceInvoice> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder("SELECT * FROM ServiceInvoices WHERE 1=1");
    List<Object> params = new ArrayList<>();

    if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
        sql.append(" AND PhoneNumber LIKE ?");
        params.add("%" + phoneNumber + "%");
    }

    if (date != null) {
        sql.append(" AND CAST(PaymentDate AS DATE) = ?");
        params.add(new java.sql.Date(date.getTime()));
    }

    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            stmt.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ServiceInvoice invoice = extractInvoice(rs);
                list.add(invoice);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
   
   public List<MaintenanceBooking> getBookingsByUserId(int userId) throws Exception {
    List<MaintenanceBooking> list = new ArrayList<>();
    String sql = "SELECT * FROM MaintenanceBooking WHERE userId = ?";

    try (Connection connection = new DBContext().getConnection();
         PreparedStatement stmt = connection.prepareStatement(sql)) {

        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            MaintenanceBooking b = new MaintenanceBooking();
            b.setBookingId(rs.getInt("bookingId"));
            b.setUserId(rs.getInt("userId"));
            b.setServiceName(rs.getString("serviceName")); // đảm bảo có cột này
            list.add(b);
        }
    }

    return list;
}




    // Hàm tiện ích để map ResultSet sang đối tượng ServiceInvoice
    private ServiceInvoice extractInvoice(ResultSet rs) throws SQLException {
        ServiceInvoice invoice = new ServiceInvoice();
        invoice.setInvoiceId(rs.getInt("InvoiceId"));
        invoice.setUserId((Integer) rs.getObject("UserId"));
        invoice.setBookingId(rs.getInt("BookingId"));
        invoice.setTotalAmount(rs.getDouble("TotalAmount"));
        invoice.setPaymentDate(rs.getTimestamp("PaymentDate"));
        invoice.setStatus(rs.getString("Status"));
        invoice.setPhoneNumber(rs.getString("PhoneNumber"));
        invoice.setFullName(rs.getString("FullName"));
        return invoice;
    }
    
    private String getServiceNameById(Integer serviceId, Connection conn) throws SQLException {
    String serviceName = "";
    String sql = "SELECT ServiceName FROM MaintenanceServices WHERE ServiceId = ?";
    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, serviceId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                serviceName = rs.getString("ServiceName");
            }
        }
    }
    return serviceName;
}

}