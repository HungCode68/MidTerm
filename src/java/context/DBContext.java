/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package context;
import java.sql.Connection;
import java.sql.DriverManager;
/**
 *
 * @author Nguyễn Hùng
 */
public class DBContext {
    
    
    private static final String DB_HOST = System.getProperty("db.host", detectHost());
    private static final String DB_PORT = "1433";
    private static final String DB_NAME = "VinfastSystem";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "123";
    
    /**
     * Tự động detect host dựa trên môi trường
     */
    private static String detectHost() {
        // Kiểm tra nếu đang chạy trong Docker
        if (System.getenv("HOSTNAME") != null && System.getenv("HOSTNAME").length() > 12) {
            return "host.docker.internal"; // Docker environment
        }
        return "localhost"; // Local environment
    }
    
    /**
     * Lấy kết nối database
     */
    public static Connection getConnection() throws Exception {
        String url = String.format(
            "jdbc:sqlserver://%s:%s;databaseName=%s;encrypt=true;trustServerCertificate=true;loginTimeout=30",
            DB_HOST, DB_PORT, DB_NAME
        );
        
        // Log thông tin kết nối (ẩn password)
        System.out.println("🔌 Connecting to: " + url.replaceAll("password=[^;]*", "password=***"));
        System.out.println("🏠 Detected host: " + DB_HOST);
        
        try {
            // Load driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Tạo kết nối
            Connection conn = DriverManager.getConnection(url, DB_USER, DB_PASSWORD);
            
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database connected successfully!");
                return conn;
            } else {
                throw new Exception("Connection is null or closed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
            System.err.println("🔍 Check:");
            System.err.println("   - SQL Server is running");
            System.err.println("   - TCP/IP is enabled");
            System.err.println("   - Port 1433 is open");
            System.err.println("   - Database 'VinfastSystem' exists");
            e.printStackTrace();
            throw e;
        }
    }
    
    /**
     * Test kết nối
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
