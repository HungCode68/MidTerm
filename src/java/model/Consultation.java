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
    private int userId;
    private int carId;
    private Timestamp requestDate;

    public Consultation() {
    }

    public Consultation(int consultationId, int userId, int carId, Timestamp requestDate) {
        this.consultationId = consultationId;
        this.userId = userId;
        this.carId = carId;
        this.requestDate = requestDate;
    }

    // Getters and Setters

    public int getConsultationId() {
        return consultationId;
    }

    public void setConsultationId(int consultationId) {
        this.consultationId = consultationId;
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

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }
}

