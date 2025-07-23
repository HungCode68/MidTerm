/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Nguyễn Hùng
 */
public class Showroom {
    private int showroomId;
    private String name;
    private String address;
    private String province;
    private String district;

    // Constructors
    public Showroom() {
    }

    public Showroom(int showroomId, String name, String address, String province, String district) {
        this.showroomId = showroomId;
        this.name = name;
        this.address = address;
        this.province = province;
        this.district = district;
    }

    // Getters and Setters
    public int getShowroomId() {
        return showroomId;
    }

    public void setShowroomId(int showroomId) {
        this.showroomId = showroomId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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
}

