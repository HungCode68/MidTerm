/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import model.Statistic;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;
/**
 *
 * @author Nguyễn Hùng
 */
public class StatisticDAO {
    private Connection conn;

    public StatisticDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Statistic> getConsultationStats() throws SQLException {
        String sql = "SELECT c.ModelName, COUNT(*) AS Count FROM Consultations co JOIN Cars c ON co.CarId = c.CarId GROUP BY c.ModelName ORDER BY Count DESC";
        return getStats(sql);
    }

    public List<Statistic> getTestDriveStats() throws SQLException {
        String sql = "SELECT c.ModelName, COUNT(*) AS Count FROM TestDrives td JOIN Cars c ON td.CarId = c.CarId GROUP BY c.ModelName ORDER BY Count DESC";
        return getStats(sql);
    }

    public List<Statistic> getDepositStats() throws SQLException {
        String sql = "SELECT c.ModelName, COUNT(*) AS Count, SUM(c.Price) AS TotalAmount FROM Deposits d JOIN Cars c ON d.CarId = c.CarId GROUP BY c.ModelName ORDER BY Count DESC";
        return getStats(sql, true);
    }

    public List<Statistic> getServiceStats() throws SQLException {
        String sql = "SELECT s.ServiceName, COUNT(*) AS Count FROM MaintenanceBookings mb JOIN MaintenanceServices s ON mb.ServiceId = s.ServiceId GROUP BY s.ServiceName ORDER BY Count DESC";
        return getStats(sql);
    }

    public List<Statistic> getInvoiceIncomeStats() throws SQLException {
        String sql = "SELECT FORMAT(PaymentDate, 'yyyy-MM') AS Month, COUNT(*) AS Count, SUM(TotalAmount) AS TotalAmount FROM ServiceInvoices GROUP BY FORMAT(PaymentDate, 'yyyy-MM') ORDER BY Month";
        return getStats(sql, true);
    }

    private List<Statistic> getStats(String sql) throws SQLException {
        return getStats(sql, false);
    }

    private List<Statistic> getStats(String sql, boolean withAmount) throws SQLException {
        List<Statistic> stats = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String name = rs.getString(1);
                int count = rs.getInt(2);
                BigDecimal total = withAmount ? rs.getBigDecimal(3) : null;
                stats.add(new Statistic(name, count, total));
            }
        }
        return stats;
    }
}
