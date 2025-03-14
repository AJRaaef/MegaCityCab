package org.cablink.megacitycab.dao;

import org.cablink.megacitycab.model.Booking;
import org.cablink.megacitycab.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    public static List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT booking_id, vehicle_id, destination, start_place, start_date, end_date, total_days, total_amount, distance, status, created_at FROM bookings WHERE customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                bookings.add(new Booking(
                        rs.getInt("booking_id"),
                        rs.getInt("vehicle_id"),
                        rs.getString("destination"),
                        rs.getString("start_place"),
                        rs.getString("start_date"),
                        rs.getString("end_date"),
                        rs.getInt("total_days"),
                        rs.getDouble("total_amount"),
                        rs.getDouble("distance"),
                        rs.getString("status"),
                        rs.getString("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}
