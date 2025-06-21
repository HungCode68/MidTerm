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
public class MaintenanceBooking {
    private int bookingId;
    private int userId;
    private String carModel;
    private String licensePlate;
    private int kilometer;
    private int serviceId;
    private String province;
    private String district;
    private Timestamp scheduledTime;
    private Timestamp createdAt;
    private String phoneNumber;
    private String fullName;

    // Constructors
    public MaintenanceBooking() {}

    public MaintenanceBooking(int bookingId, int userId, String carModel, String licensePlate,
                              int kilometer, int serviceId, String province, String district,
                              Timestamp scheduledTime, Timestamp createdAt, String phoneNumber, String fullName) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.carModel = carModel;
        this.licensePlate = licensePlate;
        this.kilometer = kilometer;
        this.serviceId = serviceId;
        this.province = province;
        this.district = district;
        this.scheduledTime = scheduledTime;
        this.createdAt = createdAt;
        this.phoneNumber = phoneNumber;
        this.fullName = fullName;
    }

    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getKilometer() {
        return kilometer;
    }

    public void setKilometer(int kilometer) {
        this.kilometer = kilometer;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
}
