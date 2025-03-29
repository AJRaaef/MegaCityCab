package org.cablink.megacitycab.dao;

import org.cablink.megacitycab.model.RegisterBooking;
import org.cablink.megacitycab.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegisterBookingDAO {
    public boolean saveRegisterBooking(RegisterBooking registerBooking) {
        boolean isSaved = false;
        String sql = "INSERT INTO bookings (customer_id, vehicle_id, driver_id, destination, start_place, start_date, end_date, total_days, total_amount, distance, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, registerBooking.getRegisterCustomerId());
            ps.setInt(2, registerBooking.getRegisterVehicleId());
            ps.setInt(3, registerBooking.getRegisterDriverId());
            ps.setString(4, registerBooking.getRegisterDestination());
            ps.setString(5, registerBooking.getRegisterStartPlace());
            ps.setDate(6, new java.sql.Date(registerBooking.getRegisterStartDate().getTime()));
            ps.setDate(7, new java.sql.Date(registerBooking.getRegisterEndDate().getTime()));
            ps.setInt(8, registerBooking.getRegisterTotalDays());
            ps.setDouble(9, registerBooking.getRegisterTotalAmount());
            ps.setInt(10, registerBooking.getRegisterDistance());
            ps.setString(11, registerBooking.getRegisterStatus());

            isSaved = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSaved;
    }
}
