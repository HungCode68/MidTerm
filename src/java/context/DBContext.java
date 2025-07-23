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
    public static Connection getConnection() throws Exception {
        String url = "jdbc:sqlserver://host.docker.internal:1433;databaseName=VinfastSystem;encrypt=true;trustServerCertificate=true";
        String user = "sa";
        String password = "123";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, password);
    }
}
