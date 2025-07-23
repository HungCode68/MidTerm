/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.MaintenanceService;
import context.DBContext;

/**
 *
 * @author Nguyễn Hùng
 */
public class MaintenanceServiceDAO {

    private Connection conn;

    public MaintenanceServiceDAO(Connection conn) {
        try {
            this.conn = DBContext.getConnection(); // giả sử DBUtil.getConnection() của bạn hoạt động
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy tất cả dịch vụ bảo dưỡng
    public List<MaintenanceService> getAllServices() {
        List<MaintenanceService> list = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceServices";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MaintenanceService service = new MaintenanceService(
                        rs.getInt("ServiceId"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getDouble("Price")
                );
                list.add(service);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Thêm mới dịch vụ
    public void addService(MaintenanceService service) {
        String sql = "INSERT INTO MaintenanceServices (ServiceName, Description, Price) VALUES (?, ?, ?)";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setDouble(3, service.getPrice());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật dịch vụ
    public void updateService(MaintenanceService service) {
        String sql = "UPDATE MaintenanceServices SET ServiceName = ?, Description = ?, Price = ? WHERE ServiceId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getDescription());
            ps.setDouble(3, service.getPrice());
            ps.setInt(4, service.getServiceId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xóa dịch vụ theo ID
    public void deleteService(int serviceId) {
        String sql = "DELETE FROM MaintenanceServices WHERE ServiceId = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy dịch vụ theo ID
    public MaintenanceService getServiceById(int serviceId) {
        String sql = "SELECT * FROM MaintenanceServices WHERE ServiceId = ?";
        MaintenanceService service = null;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                service = new MaintenanceService(
                        rs.getInt("ServiceId"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getDouble("Price")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return service;
    }

    public List<MaintenanceService> searchByName(String keyword) {
        List<MaintenanceService> list = new ArrayList<>();
        String sql = "SELECT * FROM MaintenanceServices WHERE ServiceName LIKE ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceService service = new MaintenanceService(
                        rs.getInt("ServiceId"),
                        rs.getString("ServiceName"),
                        rs.getString("Description"),
                        rs.getDouble("Price")
                );
                list.add(service);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
