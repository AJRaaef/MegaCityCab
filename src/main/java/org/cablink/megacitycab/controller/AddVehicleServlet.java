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
import org.cablink.megacitycab.util.DBConnection;

@WebServlet("/addVehicle")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10,  // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class AddVehicleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String vehicleName = request.getParameter("vehicleName");
        String model = request.getParameter("model");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
        String vehicleType = request.getParameter("vehicleType");
        int driverId = Integer.parseInt(request.getParameter("driverId"));

        String uploadPath = getServletContext().getRealPath("") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // Create the upload directory if it doesn't exist
        }

        String photo1 = "";
        String photo2 = "";
        String photo3 = "";

        // Process file uploads
        for (Part part : request.getParts()) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);

                if (part.getName().equals("photo1")) {
                    photo1 = "uploads/" + fileName;
                } else if (part.getName().equals("photo2")) {
                    photo2 = "uploads/" + fileName;
                } else if (part.getName().equals("photo3")) {
                    photo3 = "uploads/" + fileName;
                }
            }
        }

        // Insert data into the database
        String errorMessage = "";
        try (Connection conn = DBConnection.getConnection()) {
            String query = "INSERT INTO vehicles (vehicle_name, model, capacity, price_per_day, vehicle_type, driver_id, photo1, photo2, photo3, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, vehicleName);
            ps.setString(2, model);
            ps.setInt(3, capacity);
            ps.setDouble(4, pricePerDay);
            ps.setString(5, vehicleType);
            ps.setInt(6, driverId);
            ps.setString(7, photo1);
            ps.setString(8, photo2);
            ps.setString(9, photo3);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                errorMessage = "Vehicle added successfully!";
            } else {
                errorMessage = "Error: Unable to add the vehicle.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Error: Unable to add the vehicle. " + e.getMessage();
        }

        // Set the error message as a request attribute
        request.setAttribute("errorMessage", errorMessage);

        // Forward the request back to the JSP
        request.getRequestDispatcher("addVehicle.jsp").forward(request, response);
    }
}