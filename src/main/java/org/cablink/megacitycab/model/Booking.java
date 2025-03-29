package org.cablink.megacitycab.model;

public class Booking {
    private int bookingId;
    private int vehicleId;
    private String destination;
    private String startPlace;
    private String startDate;
    private String endDate;
    private int totalDays;
    private double totalAmount;
    private double distance;
    private String status;
    private String createdAt;

    // Constructor
    public Booking(int bookingId, int vehicleId, String destination, String startPlace, String startDate,
                   String endDate, int totalDays, double totalAmount, double distance, String status, String createdAt) {
        this.bookingId = bookingId;
        this.vehicleId = vehicleId;
        this.destination = destination;
        this.startPlace = startPlace;
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalDays = totalDays;
        this.totalAmount = totalAmount;
        this.distance = distance;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters
    public int getBookingId() { return bookingId; }
    public int getVehicleId() { return vehicleId; }
    public String getDestination() { return destination; }
    public String getStartPlace() { return startPlace; }
    public String getStartDate() { return startDate; }
    public String getEndDate() { return endDate; }
    public int getTotalDays() { return totalDays; }
    public double getTotalAmount() { return totalAmount; }
    public double getDistance() { return distance; }
    public String getStatus() { return status; }
    public String getCreatedAt() { return createdAt; }
}
