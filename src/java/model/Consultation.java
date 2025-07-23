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
public class Consultation {

    private int consultationId;
    private Integer userId;
    private int carId;
    private Timestamp requestDate;
    private String userName;
    private String carModelName;
    private String phoneNumber;
    private String fullName;

    public Consultation() {
    }

    public Consultation(int consultationId, Integer userId, int carId, String fullName, String phoneNumber, Timestamp requestDate) {
        this.consultationId = consultationId;
        this.userId = userId;
        this.carId = carId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.requestDate = requestDate;
    }

    // Getters and Setters
    public int getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(int consultationId) {
        this.consultationId = consultationId;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getCarModelName() {
        return carModelName;
    }

    public void setCarModelName(String carModelName) {
        this.carModelName = carModelName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
}
