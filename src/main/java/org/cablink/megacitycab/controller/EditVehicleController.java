package org.cablink.megacitycab.controller;



import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.cablink.megacitycab.util.DBConnection;
import java.io.File;
import jakarta.servlet.http.Part;

@WebServlet("/editVehicle")
public class EditVehicleController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sessionObj = request.getSession(false);


        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String errorMessage = "";

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                errorMessage = "Error: Unable to connect to the database.";
            } else {
                String vehicleQuery = "SELECT * FROM vehicles WHERE id = ?";
                ps = conn.prepareStatement(vehicleQuery);
                ps.setInt(1, vehicleId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    request.setAttribute("vehicleId", vehicleId);
                    request.setAttribute("vehicleName", rs.getString("vehicle_name"));
                    request.setAttribute("model", rs.getString("model"));
                    request.setAttribute("capacity", rs.getInt("capacity"));
                    request.setAttribute("pricePerDay", rs.getDouble("price_per_day"));
                    request.setAttribute("vehicleType", rs.getString("vehicle_type"));
                    request.setAttribute("driverId", rs.getInt("driver_id"));
                    request.setAttribute("photo1", rs.getString("photo1"));
                    request.setAttribute("photo2", rs.getString("photo2"));
                    request.setAttribute("photo3", rs.getString("photo3"));
                } else {
                    errorMessage = "Error: Vehicle not found.";
                }
            }
        } catch (SQLException e) {
            errorMessage = "Error: Unable to fetch vehicle details.";
            e.printStackTrace();
        }

        if (!errorMessage.isEmpty()) {
            request.setAttribute("errorMessage", errorMessage);
        }
        request.getRequestDispatcher("editVehicle.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Debug: Print all parameters
        System.out.println("Vehicle ID: " + request.getParameter("vehicleId"));
        System.out.println("Vehicle Name: " + request.getParameter("vehicleName"));
        System.out.println("Model: " + request.getParameter("model"));
        System.out.println("Vehicle Type: " + request.getParameter("vehicleType"));
        System.out.println("Capacity: " + request.getParameter("capacity"));
        System.out.println("Price Per Day: " + request.getParameter("pricePerDay"));

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
            // Debug: Print file details
            System.out.println("File Name: " + filePart.getSubmittedFileName());
            System.out.println("File Size: " + filePart.getSize());

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

            // Debug: Print the SQL query
            System.out.println("Executing Query: " + pstmt.toString());

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
