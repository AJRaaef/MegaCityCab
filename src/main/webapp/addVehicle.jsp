<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%





    // Initialize database connection and variables
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String errorMessage = "";

    try {
        // Establish database connection
        conn = DBConnection.getConnection();
        if (conn == null) {
            errorMessage = "Error: Unable to connect to the database.";
        } else {
            // Query for getting all drivers
            String driverQuery = "SELECT id, full_name FROM drivers WHERE id NOT IN (SELECT driver_id FROM vehicles WHERE driver_id IS NOT NULL)";

            ps = conn.prepareStatement(driverQuery);
            rs = ps.executeQuery();
        }
    } catch (SQLException e) {
        e.printStackTrace();
        errorMessage = "Error: Unable to fetch driver details.";
    }

    // Handle form submission for adding vehicle
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String vehicleName = request.getParameter("vehicleName");
        String model = request.getParameter("model");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        double pricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));
        String vehicleType = request.getParameter("vehicleType");
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        String photo1 = "", photo2 = "", photo3 = "";

        try {
            // Handle file uploads and form data
            String uploadPath = application.getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir(); // Create the upload directory if it doesn't exist
            }

            // Process each part of the form
            for (Part part : request.getParts()) {
                String fieldName = part.getName();

                if (fieldName.equals("photo1") && part.getSize() > 0) {
                    String fileName = new File(part.getSubmittedFileName()).getName();
                    String filePath = uploadPath + File.separator + fileName;
                    part.write(filePath);
                    photo1 = "uploads/" + fileName;
                } else if (fieldName.equals("photo2") && part.getSize() > 0) {
                    String fileName = new File(part.getSubmittedFileName()).getName();
                    String filePath = uploadPath + File.separator + fileName;
                    part.write(filePath);
                    photo2 = "uploads/" + fileName;
                } else if (fieldName.equals("photo3") && part.getSize() > 0) {
                    String fileName = new File(part.getSubmittedFileName()).getName();
                    String filePath = uploadPath + File.separator + fileName;
                    part.write(filePath);
                    photo3 = "uploads/" + fileName;
                }
            }

            // Insert new vehicle into the vehicles table
            String vehicleInsertQuery = "INSERT INTO vehicles (vehicle_name, model, capacity, price_per_day, vehicle_type, driver_id, photo1, photo2, photo3, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            ps = conn.prepareStatement(vehicleInsertQuery);
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
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Vehicle</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-container {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mt-4">Add New Vehicle</h2>

    <% if (!errorMessage.isEmpty()) { %>
    <div class="alert alert-info">
        <%= errorMessage %>
    </div>
    <% } %>

    <div class="form-container">
        <h3>Vehicle Details</h3>
        <form action="addVehicle" method="post" enctype="multipart/form-data">
        <div class="mb-3">
                <label for="vehicleName">Vehicle Name:</label>
                <input type="text" id="vehicleName" name="vehicleName" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="model">Model:</label>
                <input type="text" id="model" name="model" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="capacity">Capacity:</label>
                <input type="number" id="capacity" name="capacity" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="pricePerDay">Price Per Day:</label>
                <input type="number" step="0.01" id="pricePerDay" name="pricePerDay" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="vehicleType">Vehicle Type:</label>
                <select id="vehicleType" name="vehicleType" class="form-control" required>
                    <option value="Car">Car</option>
                    <option value="Van">Van</option>
                    <option value="Bus">Bus</option>
                    <option value="Truck">Truck</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="driverId">Driver:</label>
                <select id="driverId" name="driverId" class="form-control" required>
                    <%
                        boolean hasDrivers = false;
                        while (rs.next()) {
                            hasDrivers = true;
                    %>
                    <option value="<%= rs.getInt("id") %>">
                        <%= rs.getString("full_name") %>
                    </option>
                    <%
                        }
                        if (!hasDrivers) {
                    %>
                    <option value="">No drivers available</option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div class="mb-3">
                <label for="photo1">Photo 1:</label>
                <input type="file" id="photo1" name="photo1" class="form-control" accept="image/*">
            </div>
            <div class="mb-3">
                <label for="photo2">Photo 2:</label>
                <input type="file" id="photo2" name="photo2" class="form-control" accept="image/*">
            </div>
            <div class="mb-3">
                <label for="photo3">Photo 3:</label>
                <input type="file" id="photo3" name="photo3" class="form-control" accept="image/*">
            </div>
            <button type="submit" class="btn btn-primary">Add Vehicle</button>
        </form>
    </div>
</div>
</body>
</html>
