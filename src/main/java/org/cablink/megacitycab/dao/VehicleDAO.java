package org.cablink.megacitycab.dao;

import org.cablink.megacitycab.model.Vehicle;
import org.cablink.megacitycab.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    // Method to get all vehicles
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String query = "SELECT * FROM vehicles";  // Query to get all vehicles

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("Database connection established, executing query: " + query);

            while (rs.next()) {
                // Create Vehicle object from database result
                Vehicle vehicle = new Vehicle(
                );
                vehicles.add(vehicle);
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in getAllVehicles: " + e.getMessage());
            e.printStackTrace();
        }

        return vehicles;
    }

    // Method to get a specific vehicle by its ID
    public Vehicle getVehicleById(int id) {
        Vehicle vehicle = null;
        String query = "SELECT * FROM vehicles WHERE id = ?";  // Query to fetch specific vehicle

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, id);  // Set the vehicle ID in the query

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    vehicle = new Vehicle(
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in getVehicleById: " + e.getMessage());
            e.printStackTrace();
        }

        return vehicle;
    }

    // Method to update a vehicle in the database
    public boolean updateVehicle(Vehicle vehicle) {
        boolean updated = false;
        String query = "UPDATE vehicles SET vehicle_name = ?, model = ?, capacity = ?, price_per_day = ?, " +
                "status = ?, driver_id = ?, photo1 = ?, photo2 = ?, photo3 = ?, vehicle_type = ? WHERE id = ?";  // Update query

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, vehicle.getName());  // Set the updated fields
            pstmt.setString(2, vehicle.getModel());
            pstmt.setInt(3, vehicle.getCapacity());
            pstmt.setDouble(4, vehicle.getPricePerDay());
            pstmt.setInt(6, vehicle.getDriverId());
            pstmt.setString(7, vehicle.getPhoto1());
            pstmt.setString(8, vehicle.getPhoto2());
            pstmt.setString(9, vehicle.getPhoto3());
            pstmt.setString(10, vehicle.getVehicleType());
            pstmt.setInt(11, vehicle.getId());  // Set the ID of the vehicle being updated

            int rowsAffected = pstmt.executeUpdate();  // Execute the update query
            if (rowsAffected > 0) {
                updated = true;
                System.out.println("Vehicle with ID " + vehicle.getId() + " updated successfully.");
            } else {
                System.out.println("No vehicle found with ID " + vehicle.getId());
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in updateVehicle: " + e.getMessage());
            e.printStackTrace();
        }

        return updated;  // Return true if the vehicle was updated
    }

    // Method to delete a vehicle
    public boolean deleteVehicle(int id) {
        boolean deleted = false;
        String query = "DELETE FROM vehicles WHERE id = ?";  // Delete query

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, id);  // Set the vehicle ID to delete

            int rowsAffected = pstmt.executeUpdate();  // Execute the delete query
            if (rowsAffected > 0) {
                deleted = true;
                System.out.println("Vehicle with ID " + id + " deleted successfully.");
            } else {
                System.out.println("No vehicle found with ID " + id);
            }
        } catch (SQLException e) {
            System.err.println("SQL Exception in deleteVehicle: " + e.getMessage());
            e.printStackTrace();
        }

        return deleted;  // Return true if the vehicle was deleted
    }
}
