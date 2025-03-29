package org.cablink.megacitycab.service;

import org.cablink.megacitycab.dao.BookingDAO;
import org.cablink.megacitycab.model.Booking;

import java.util.List;

public class BookingService {

    private BookingDAO bookingDAO;

    // Constructor
    public BookingService() {
        this.bookingDAO = new BookingDAO();
    }

    // Get all bookings for a customer
    public List<Booking> getBookingsForCustomer(int customerId) {
        return bookingDAO.getBookingsByCustomerId(customerId);
    }
}
