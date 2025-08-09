/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.MaintenanceBooking;
import context.DBContext;
/**
 *
 * @author Nguyễn Hùng
 */
public class MaintenanceBookingDAO {
    private Connection conn;

    public MaintenanceBookingDAO(Connection conn) {
        this.conn = conn;
    }

    // Thêm lịch bảo dưỡng mới
    public void insertBooking(MaintenanceBooking booking) throws SQLException {
        String sql = "INSERT INTO MaintenanceBookings (UserId, CarModel, LicensePlate, Kilometer, ServiceId, " +
                     "Province, District, ScheduledTime, PhoneNumber, FullName, Status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (booking.getUserId() != null) {
                ps.setInt(1, booking.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, booking.getCarModel());
            ps.setString(3, booking.getLicensePlate());
            ps.setInt(4, booking.getKilometer());
            ps.setInt(5, booking.getServiceId());
            ps.setString(6, booking.getProvince());
            ps.setString(7, booking.getDistrict());
            ps.setTimestamp(8, booking.getScheduledTime());
            ps.setString(9, booking.getPhoneNumber());
            ps.setString(10, booking.getFullName());
            ps.setString(11, "in progress"); // default status
            ps.executeUpdate();
        }
    }
    
     public void updateBooking(MaintenanceBooking booking) throws SQLException {
        String sql = "UPDATE MaintenanceBookings SET CarModel=?, LicensePlate=?, Kilometer=?, " +
                     "ServiceId=?, Province=?, District=?, ScheduledTime=?, PhoneNumber=?, FullName=?, Status=? " +
                     "WHERE BookingId=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, booking.getCarModel());
            ps.setString(2, booking.getLicensePlate());
            ps.setInt(3, booking.getKilometer());
            ps.setInt(4, booking.getServiceId());
            ps.setString(5, booking.getProvince());
            ps.setString(6, booking.getDistrict());
            ps.setTimestamp(7, booking.getScheduledTime());
            ps.setString(8, booking.getPhoneNumber());
            ps.setString(9, booking.getFullName());
            ps.setString(10, booking.getStatus());
            ps.setInt(11, booking.getBookingId());
            ps.executeUpdate();
        }
    }

    // Xoá booking theo ID
    public void deleteBooking(int bookingId) throws SQLException {
        String sql = "DELETE FROM MaintenanceBookings WHERE BookingId=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.executeUpdate();
        }
    }
    
     public List<MaintenanceBooking> getFilteredBookings(String phone, Date day) throws SQLException {
    List<MaintenanceBooking> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder("""
        SELECT b.*, s.ServiceName 
        FROM MaintenanceBookings b 
        LEFT JOIN MaintenanceServices s ON b.ServiceId = s.ServiceId 
        WHERE 1=1
    """);
    List<Object> params = new ArrayList<>();

    if (phone != null && !phone.trim().isEmpty()) {
        sql.append(" AND b.PhoneNumber LIKE ?");
        params.add("%" + phone.trim() + "%");
    }

    if (day != null) {
        sql.append(" AND CAST(b.ScheduledTime AS DATE) = ?");
        params.add(day);
    }

    sql.append(" ORDER BY b.ScheduledTime DESC");

    try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            MaintenanceBooking booking = mapResultSetToBooking(rs);
            booking.setServiceName(rs.getString("ServiceName")); // <-- thêm dòng này
            list.add(booking);
        }
    }

    return list;
}


    public List<MaintenanceBooking> getAllBookings() throws SQLException {
        List<MaintenanceBooking> list = new ArrayList<>();
        String sql = """
                     SELECT b.*, s.ServiceName 
                     FROM MaintenanceBookings b 
                     LEFT JOIN MaintenanceServices s ON b.ServiceId = s.ServiceId
                     ORDER BY b.CreatedAt DESC
                     """;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MaintenanceBooking booking = mapResultSetToBooking(rs);
                // Dòng này được thêm vào để lấy ServiceName từ ResultSet
                booking.setServiceName(rs.getString("ServiceName")); 
                list.add(booking);
            }
        }
        return list;
    }


    // Lấy tất cả lịch bảo dưỡng theo UserId
    public List<MaintenanceBooking> getBookingsByUserId(int userId) throws SQLException {
        List<MaintenanceBooking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceBookings WHERE UserId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceBooking booking = mapResultSetToBooking(rs);
                bookings.add(booking);
            }
        }
        return bookings;
    }

    

    // Hàm tiện ích để map từ ResultSet sang đối tượng
    private MaintenanceBooking mapResultSetToBooking(ResultSet rs) throws SQLException {
        MaintenanceBooking booking = new MaintenanceBooking();
        booking.setBookingId(rs.getInt("BookingId"));
        int userId = rs.getInt("UserId");
        booking.setUserId(rs.wasNull() ? null : userId);
        booking.setCarModel(rs.getString("CarModel"));
        booking.setLicensePlate(rs.getString("LicensePlate"));
        booking.setKilometer(rs.getInt("Kilometer"));
        booking.setServiceId(rs.getInt("ServiceId"));
        booking.setProvince(rs.getString("Province"));
        booking.setDistrict(rs.getString("District"));
        booking.setScheduledTime(rs.getTimestamp("ScheduledTime"));
        booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
        booking.setPhoneNumber(rs.getString("PhoneNumber"));
        booking.setFullName(rs.getString("FullName"));
         booking.setStatus(rs.getString("Status"));
        booking.setServiceName(rs.getString("ServiceName"));
        return booking;
    }
}