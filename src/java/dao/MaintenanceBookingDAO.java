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
                     "Province, District, ScheduledTime, PhoneNumber, FullName) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getUserId());
            ps.setString(2, booking.getCarModel());
            ps.setString(3, booking.getLicensePlate());
            ps.setInt(4, booking.getKilometer());
            ps.setInt(5, booking.getServiceId());
            ps.setString(6, booking.getProvince());
            ps.setString(7, booking.getDistrict());
            ps.setTimestamp(8, booking.getScheduledTime());
            ps.setString(9, booking.getPhoneNumber());
            ps.setString(10, booking.getFullName());
            ps.executeUpdate();
        }
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

    // Lấy tất cả lịch bảo dưỡng (Admin xem)
    public List<MaintenanceBooking> getAllBookings() throws SQLException {
        List<MaintenanceBooking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceBookings";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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
        booking.setUserId(rs.getInt("UserId"));
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
        return booking;
    }
}