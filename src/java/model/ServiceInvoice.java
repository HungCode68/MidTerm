/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Nguyễn Hùng
 */
public class ServiceInvoice {
    private int invoiceId;
    private Integer userId;
    private Integer bookingId;
     private Integer serviceId; 
    private double totalAmount;
    private Date paymentDate;
    private String status;
    private String phoneNumber;
    private String fullName;
    private String serviceName;

    // Constructors
    public ServiceInvoice() {
    }

    public ServiceInvoice(int invoiceId, Integer userId, Integer bookingId, double totalAmount, Date paymentDate, String status, String phoneNumber, String fullName) {
        this.invoiceId = invoiceId;
        this.userId = userId;
        this.bookingId = bookingId;
        this.totalAmount = totalAmount;
        this.paymentDate = paymentDate;
        this.status = status;
        this.phoneNumber = phoneNumber;
        this.fullName = fullName;
    }

    // Getters and Setters
    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }
    
     public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
    
     public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
}
