package org.cablink.megacitycab.model;

import java.util.Date;

public class RegisterBooking {
    private int registerBookingId;
    private int registerCustomerId;
    private int registerVehicleId;
    private int registerDriverId;
    private String registerDestination;
    private String registerStartPlace;
    private Date registerStartDate;
    private Date registerEndDate;
    private int registerTotalDays;
    private double registerTotalAmount;
    private int registerDistance;
    private String registerStatus;

    // Getters and Setters
    public int getRegisterBookingId() { return registerBookingId; }
    public void setRegisterBookingId(int registerBookingId) { this.registerBookingId = registerBookingId; }

    public int getRegisterCustomerId() { return registerCustomerId; }
    public void setRegisterCustomerId(int registerCustomerId) { this.registerCustomerId = registerCustomerId; }

    public int getRegisterVehicleId() { return registerVehicleId; }
    public void setRegisterVehicleId(int registerVehicleId) { this.registerVehicleId = registerVehicleId; }

    public int getRegisterDriverId() { return registerDriverId; }
    public void setRegisterDriverId(int registerDriverId) { this.registerDriverId = registerDriverId; }

    public String getRegisterDestination() { return registerDestination; }
    public void setRegisterDestination(String registerDestination) { this.registerDestination = registerDestination; }

    public String getRegisterStartPlace() { return registerStartPlace; }
    public void setRegisterStartPlace(String registerStartPlace) { this.registerStartPlace = registerStartPlace; }

    public Date getRegisterStartDate() { return registerStartDate; }
    public void setRegisterStartDate(Date registerStartDate) { this.registerStartDate = registerStartDate; }

    public Date getRegisterEndDate() { return registerEndDate; }
    public void setRegisterEndDate(Date registerEndDate) { this.registerEndDate = registerEndDate; }

    public int getRegisterTotalDays() { return registerTotalDays; }
    public void setRegisterTotalDays(int registerTotalDays) { this.registerTotalDays = registerTotalDays; }

    public double getRegisterTotalAmount() { return registerTotalAmount; }
    public void setRegisterTotalAmount(double registerTotalAmount) { this.registerTotalAmount = registerTotalAmount; }

    public int getRegisterDistance() { return registerDistance; }
    public void setRegisterDistance(int registerDistance) { this.registerDistance = registerDistance; }

    public String getRegisterStatus() { return registerStatus; }
    public void setRegisterStatus(String registerStatus) { this.registerStatus = registerStatus; }
}
