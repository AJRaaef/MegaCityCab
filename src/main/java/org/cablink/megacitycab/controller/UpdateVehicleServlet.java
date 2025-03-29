package org.cablink.megacitycab.controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.cablink.megacitycab.util.DBConnection;

@WebServlet("/updateVehicle")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10,  // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class UpdateVehicleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String vehicleName = request.getParameter("vehicleName");
        String model = request.getParameter("model");
        String vehicleType = request.getParameter("vehicleType");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));

        // Handle file upload
        String photo1 = null;
        Part filePart = request.getPart("photo1");

        if (filePart != null && filePart.getSize() > 0) {
            // Define the upload directory
            String uploadPath = getServletContext().getRealPath("") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir(); // Create the directory if it doesn't exist
            }

            // Save the uploaded file
            String fileName = new File(filePart.getSubmittedFileName()).getName();
            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);

            // Set the photo path for the database
            photo1 = "uploads/" + fileName;
        }

        // Update the vehicle details in the database
        String errorMessage = "";
        String successMessage = "";
        try (Connection conn = DBConnection.getConnection()) {
            String query;
            if (photo1 != null) {
                // Update query with photo
                query = "UPDATE vehicles SET vehicle_name = ?, model = ?, vehicle_type = ?, capacity = ?, price_per_day = ?, photo1 = ? WHERE id = ?";
            } else {
                // Update query without photo
                query = "UPDATE vehicles SET vehicle_name = ?, model = ?, vehicle_type = ?, capacity = ?, price_per_day = ? WHERE id = ?";
            }

            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, vehicleName);
            pstmt.setString(2, model);
            pstmt.setString(3, vehicleType);
            pstmt.setInt(4, capacity);
            pstmt.setDouble(5, pricePerDay);

            if (photo1 != null) {
                pstmt.setString(6, photo1);
                pstmt.setInt(7, vehicleId);
            } else {
                pstmt.setInt(6, vehicleId);
            }

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                successMessage = "Vehicle updated successfully!";
            } else {
                errorMessage = "Error: Unable to update the vehicle.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Error: Unable to update the vehicle. " + e.getMessage();
        }

        // Set messages as request attributes
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("successMessage", successMessage);

        // Forward the request to a JSP for displaying the result
        request.getRequestDispatcher("updateResult.jsp").forward(request, response);
    }
}