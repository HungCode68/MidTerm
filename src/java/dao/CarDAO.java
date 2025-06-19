/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import context.DBContext;
import model.Car;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
/**
 *
 * @author Nguyễn Hùng
 */
public class CarDAO {

    private Connection conn;

  public CarDAO(Connection conn) {
    try {
        this.conn = DBContext.getConnection(); // giả sử DBUtil.getConnection() của bạn hoạt động
    } catch (Exception e) {
        e.printStackTrace();
    }
}


    // Lấy toàn bộ danh sách xe
    public List<Car> getAllCars() throws SQLException {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM Cars";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Car car = new Car(
                rs.getInt("CarId"),
                rs.getString("ModelName"),
                rs.getDouble("Price"),
                rs.getString("ImageUrl"),
                rs.getString("Description"),
                rs.getString("Specifications")
            );
            cars.add(car);
        }
        return cars;
    }

    // Tìm xe theo ID
    public Car getCarById(int carId) throws SQLException {
        String sql = "SELECT * FROM Cars WHERE CarId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, carId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new Car(
                rs.getInt("CarId"),
                rs.getString("ModelName"),
                rs.getDouble("Price"),
                rs.getString("ImageUrl"),
                rs.getString("Description"),
                rs.getString("Specifications")
            );
        }
        return null;
    }

    // Thêm xe mới
    public void addCar(Car car) throws SQLException {
        String sql = "INSERT INTO Cars (ModelName, Price, ImageUrl, Description, Specifications) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, car.getModelName());
        ps.setDouble(2, car.getPrice());
        ps.setString(3, car.getImageUrl());
        ps.setString(4, car.getDescription());
        ps.setString(5, car.getSpecifications());
        ps.executeUpdate();
    }

    // Cập nhật xe
    public void updateCar(Car car) throws SQLException {
        String sql = "UPDATE Cars SET ModelName = ?, Price = ?, ImageUrl = ?, Description = ?, Specifications = ? WHERE CarId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, car.getModelName());
        ps.setDouble(2, car.getPrice());
        ps.setString(3, car.getImageUrl());
        ps.setString(4, car.getDescription());
        ps.setString(5, car.getSpecifications());
        ps.setInt(6, car.getCarId());
        ps.executeUpdate();
    }

    // Xoá xe
    public void deleteCar(int carId) throws SQLException {
        String sql = "DELETE FROM Cars WHERE CarId = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, carId);
        ps.executeUpdate();
    }
    
    public Car getCarByModelName(String modelName) throws SQLException {
    String sql = "SELECT * FROM Cars WHERE ModelName = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, modelName);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        return new Car(
            rs.getInt("CarId"),
            rs.getString("ModelName"),
            rs.getDouble("Price"),
            rs.getString("ImageUrl"),
            rs.getString("Description"),
            rs.getString("Specifications")
        );
    }
    return null;
}

}
