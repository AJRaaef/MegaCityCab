package org.cablink.megacitycab.dao;

import org.cablink.megacitycab.model.Customer;
import org.cablink.megacitycab.model.Driver;
import org.cablink.megacitycab.model.User;
import org.cablink.megacitycab.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // Authenticate user and return their details
    public User authenticateUser(String username, String password) {
        String query = "SELECT id, username, password, full_name, email, phone_number, address, created_at, profile_info, profile_picture, 'customer' AS role, NULL AS nic, NULL AS license_number " +
                "FROM customers WHERE username = ? AND password = ? " +
                "UNION " +
                "SELECT id, username, password, full_name, email, phone_number, Null AS address, created_at, profile_info, profile_picture, 'driver' AS role, nic, license_number " +
                "FROM drivers WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, username);
            pst.setString(4, password);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");

                    if ("customer".equals(role)) {
                        Customer customer = new Customer();
                        populateUserFields(customer, rs);
                        return customer;
                    } else if ("driver".equals(role)) {
                        Driver driver = new Driver();
                        populateUserFields(driver, rs);
                        driver.setNic(rs.getString("nic"));
                        driver.setLicenseNumber(rs.getString("license_number"));
                        return driver;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Return null if authentication fails
    }

    // Helper method to populate common user fields
    private void populateUserFields(User user, ResultSet rs) throws SQLException {
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setAddress(rs.getString("address"));
        user.setCreatedAt(rs.getString("created_at"));
        user.setProfileInfo(rs.getString("profile_info"));
        user.setProfilePicture(rs.getString("profile_picture"));
        user.setRole(rs.getString("role"));
    }
}