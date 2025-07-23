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
public class Deposit {

    private int depositId;
    private Integer userId;
    private int carId;
    private String colorExterior;
    private String colorInterior;
    private String fullName;
    private String phoneNumber;
    private String cccd;
    private String province;
    private int showroomId;
    private String paymentMethod;
    private Timestamp depositDate;
    private String status;
    private String carName;
    private String showroomName;
    private String userName;

    // Constructors
    public Deposit() {
    }

    public Deposit(int depositId, Integer userId, int carId, String colorExterior, String colorInterior,
            String fullName, String phoneNumber, String cccd, String province,
            int showroomId, String paymentMethod, Timestamp depositDate, String status) {
        this.depositId = depositId;
        this.userId = userId;
        this.carId = carId;
        this.colorExterior = colorExterior;
        this.colorInterior = colorInterior;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.cccd = cccd;
        this.province = province;
        this.showroomId = showroomId;
        this.paymentMethod = paymentMethod;
        this.depositDate = depositDate;
        this.status = status;
    }

    // Getters and Setters
    public int getDepositId() {
        return depositId;
    }

    public void setDepositId(int depositId) {
        this.depositId = depositId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public int getCarId() {
        return carId;
    }

    public void setCarId(int carId) {
        this.carId = carId;
    }

    public String getColorExterior() {
        return colorExterior;
    }

    public void setColorExterior(String colorExterior) {
        this.colorExterior = colorExterior;
    }

    public String getColorInterior() {
        return colorInterior;
    }

    public void setColorInterior(String colorInterior) {
        this.colorInterior = colorInterior;
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

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public int getShowroomId() {
        return showroomId;
    }

    public void setShowroomId(int showroomId) {
        this.showroomId = showroomId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getDepositDate() {
        return depositDate;
    }

    public void setDepositDate(Timestamp depositDate) {
        this.depositDate = depositDate;
    }

    public String getStatus() { // ✅ getter cho status
        return status;
    }

    public void setStatus(String status) { // ✅ setter cho status
        this.status = status;
    }

    public String getCarName() {
        return carName;
    }

    public void setCarName(String carName) {
        this.carName = carName;
    }

    public String getShowroomName() {
        return showroomName;
    }

    public void setShowroomName(String showroomName) {
        this.showroomName = showroomName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

}
