/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Timestamp;
/**
 *
 * @author Nguyễn Hùng
 */
public class TestDrive {
    private int testDriveId;
    private int userId;
    private int carId;
    private String fullName;
    private String phoneNumber;
    private String province;
    private String address;
    private Timestamp scheduledTime;
    private Timestamp createdAt;

    public TestDrive() {
    }

    public TestDrive(int testDriveId, int userId, int carId, String fullName, String phoneNumber,
                     String province, String address, Timestamp scheduledTime, Timestamp createdAt) {
        this.testDriveId = testDriveId;
        this.userId = userId;
        this.carId = carId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.province = province;
        this.address = address;
        this.scheduledTime = scheduledTime;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getTestDriveId() {
        return testDriveId;
    }

    public void setTestDriveId(int testDriveId) {
        this.testDriveId = testDriveId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Timestamp getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Timestamp scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
