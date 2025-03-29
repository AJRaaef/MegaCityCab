package org.cablink.megacitycab.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.cablink.megacitycab.util.DBConnection;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/AddDriverController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddDriverController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form fields
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String nic = request.getParameter("nic");
        String licenseNumber = request.getParameter("license_number");

        Part filePart = request.getPart("profile_picture"); // Get the uploaded file
        String fileName = null;
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

        // Create upload directory if not exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        if (filePart != null && filePart.getSize() > 0) {
            fileName = new File(filePart.getSubmittedFileName()).getName();
            filePart.write(uploadPath + File.separator + fileName);
        } else {
            request.setAttribute("errorMessage", "Profile picture is required!");
            request.getRequestDispatcher("addDriver.jsp").forward(request, response);
            return;
        }

        // Database connection and insertion
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO drivers (username, password, full_name, email, phone_number, nic, license_number, profile_picture, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'driver')";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, username);
            stmt.setString(2, password); // Store plain password
            stmt.setString(3, fullName);
            stmt.setString(4, email);
            stmt.setString(5, phone);
            stmt.setString(6, nic);
            stmt.setString(7, licenseNumber);
            stmt.setString(8, "uploads/" + fileName);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                request.setAttribute("successMessage", "Driver added successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add driver.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        // Redirect back to the addDriver.jsp page with a success or error message
        request.getRequestDispatcher("addDriver.jsp").forward(request, response);
    }
}
