<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection, java.io.File, jakarta.servlet.http.Part" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Initialize variables for vehicle and driver details
    String errorMessage = "";
    String successMessage = "";

    int vehicleId = 0;
    String vehicleName = "";
    String model = "";
    String vehicleType = "";
    int capacity = 0;
    double pricePerDay = 0.0;
    String status = "";
    int driverId = 0;
    String photo1 = "";
    String photo2 = "";
    String photo3 = "";

    String driverUsername = "";
    String driverFullName = "";
    String driverEmail = "";
    String driverPhoneNumber = "";
    String driverNic = "";
    String driverLicenseNumber = "";

    // Check if the vehicleId parameter is passed
    if (request.getParameter("vehicleId") != null) {
        vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

        // Fetch vehicle and driver details from the database
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT v.*, d.username, d.full_name, d.email, d.phone_number, d.nic, d.license_number " +
                             "FROM vehicles v JOIN drivers d ON v.driver_id = d.id WHERE v.id = ?")) {

            pstmt.setInt(1, vehicleId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                vehicleName = rs.getString("vehicle_name");
                model = rs.getString("model");
                vehicleType = rs.getString("vehicle_type");
                capacity = rs.getInt("capacity");
                pricePerDay = rs.getDouble("price_per_day");
                status = rs.getString("status");
                driverId = rs.getInt("driver_id");
                photo1 = rs.getString("photo1");
                photo2 = rs.getString("photo2");
                photo3 = rs.getString("photo3");

                // Fetch driver details
                driverUsername = rs.getString("username");
                driverFullName = rs.getString("full_name");
                driverEmail = rs.getString("email");
                driverPhoneNumber = rs.getString("phone_number");
                driverNic = rs.getString("nic");
                driverLicenseNumber = rs.getString("license_number");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Error: Unable to fetch vehicle and driver details.";
        }
    } else {
        errorMessage = "Error: Vehicle ID is missing.";
    }

    // Debugging: print the fetched details
    System.out.println("<h4>Debugging Vehicle Data</h4>");
    System.out.println("<p>Vehicle ID: " + vehicleId + "</p>");
    System.out.println("<p>Vehicle Name: " + vehicleName + "</p>");
    System.out.println("<p>Driver Username: " + driverUsername + "</p>");
    System.out.println("<p>Driver Full Name: " + driverFullName + "</p>");
    System.out.println("<p>Driver Email: " + driverEmail + "</p>");

    // Handle form submission to update data
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Handle file uploads and form submissions
        String uploadPath = application.getRealPath("") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // Create the directory if it doesn't exist
        }

        // Process each part of the form
        for (Part part : request.getParts()) {
            String fieldName = part.getName();
            if (fieldName.equals("vehicleId")) {
                vehicleId = Integer.parseInt(new String(part.getInputStream().readAllBytes()));
            } else if (fieldName.equals("vehicleName")) {
                vehicleName = new String(part.getInputStream().readAllBytes());
            } else if (fieldName.equals("model")) {
                model = new String(part.getInputStream().readAllBytes());
            } else if (fieldName.equals("vehicleType")) {
                vehicleType = new String(part.getInputStream().readAllBytes());
            } else if (fieldName.equals("capacity")) {
                capacity = Integer.parseInt(new String(part.getInputStream().readAllBytes()));
            } else if (fieldName.equals("pricePerDay")) {
                pricePerDay = Double.parseDouble(new String(part.getInputStream().readAllBytes()));
            } else if (fieldName.equals("status")) {
                status = new String(part.getInputStream().readAllBytes());
            } else if (fieldName.equals("driverId")) {
                driverId = Integer.parseInt(new String(part.getInputStream().readAllBytes()));
            } else if (fieldName.equals("photo1") && part.getSize() > 0) {
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

        // Update the vehicle and driver details in the database
        try (Connection conn = DBConnection.getConnection()) {
            String vehicleQuery = "UPDATE vehicles SET vehicle_name = ?, model = ?, vehicle_type = ?, capacity = ?, price_per_day = ?, status = ?, driver_id = ?, photo1 = ?, photo2 = ?, photo3 = ? WHERE id = ?";
            PreparedStatement vehiclePstmt = conn.prepareStatement(vehicleQuery);
            vehiclePstmt.setString(1, vehicleName);
            vehiclePstmt.setString(2, model);
            vehiclePstmt.setString(3, vehicleType);
            vehiclePstmt.setInt(4, capacity);
            vehiclePstmt.setDouble(5, pricePerDay);
            vehiclePstmt.setString(6, status);
            vehiclePstmt.setInt(7, driverId);
            vehiclePstmt.setString(8, photo1);
            vehiclePstmt.setString(9, photo2);
            vehiclePstmt.setString(10, photo3);
            vehiclePstmt.setInt(11, vehicleId);

            int rowsUpdated = vehiclePstmt.executeUpdate();
            if (rowsUpdated > 0) {
                successMessage = "Vehicle updated successfully!";
            } else {
                errorMessage = "Error: Unable to update the vehicle.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Error: Unable to update the vehicle. " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Vehicle</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>Update Vehicle</h2>

    <% if (!errorMessage.isEmpty()) { %>
    <div class="alert alert-danger">
        <%= errorMessage %>
    </div>
    <% } %>

    <% if (!successMessage.isEmpty()) { %>
    <div class="alert alert-success">
        <%= successMessage %>
    </div>
    <% } %>

    <form action="editVehicle.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="vehicleId" value="<%= vehicleId %>">
        <input type="hidden" name="existingPhoto1" value="<%= photo1 %>">
        <input type="hidden" name="existingPhoto2" value="<%= photo2 %>">
        <input type="hidden" name="existingPhoto3" value="<%= photo3 %>">

        <!-- Vehicle Details -->
        <div class="form-group">
            <label for="vehicleName">Vehicle Name</label>
            <input type="text" id="vehicleName" name="vehicleName" class="form-control" value="<%= vehicleName %>" required>
        </div>

        <div class="form-group">
            <label for="model">Model</label>
            <input type="text" id="model" name="model" class="form-control" value="<%= model %>" required>
        </div>

        <div class="form-group">
            <label for="vehicleType">Vehicle Type</label>
            <select id="vehicleType" name="vehicleType" class="form-control" required>
                <option value="Car" <%= "Car".equals(vehicleType) ? "selected" : "" %>>Car</option>
                <option value="Bike" <%= "Bike".equals(vehicleType) ? "selected" : "" %>>Bike</option>
                <option value="Van" <%= "Van".equals(vehicleType) ? "selected" : "" %>>Van</option>
                <option value="TukTuk" <%= "TukTuk".equals(vehicleType) ? "selected" : "" %>>TukTuk</option>
            </select>
        </div>

        <div class="form-group">
            <label for="capacity">Capacity</label>
            <input type="number" id="capacity" name="capacity" class="form-control" value="<%= capacity %>" required>
        </div>

        <div class="form-group">
            <label for="pricePerDay">Price per Day</label>
            <input type="number" id="pricePerDay" name="pricePerDay" class="form-control" value="<%= pricePerDay %>" required>
        </div>

        <div class="form-group">
            <label for="status">Status</label>
            <select id="status" name="status" class="form-control" required>
                <option value="available" <%= "available".equals(status) ? "selected" : "" %>>Available</option>
                <option value="booked" <%= "booked".equals(status) ? "selected" : "" %>>Booked</option>
                <option value="maintenance" <%= "maintenance".equals(status) ? "selected" : "" %>>Maintenance</option>
            </select>
        </div>

        <!-- Driver Details -->
        <h3>Driver Details</h3>
        <div class="form-group">
            <label for="driverUsername">Username</label>
            <input type="text" id="driverUsername" name="driverUsername" class="form-control" value="<%= driverUsername %>" required>
        </div>

        <div class="form-group">
            <label for="driverFullName">Full Name</label>
            <input type="text" id="driverFullName" name="driverFullName" class="form-control" value="<%= driverFullName %>" required>
        </div>

        <div class="form-group">
            <label for="driverEmail">Email</label>
            <input type="email" id="driverEmail" name="driverEmail" class="form-control" value="<%= driverEmail %>" required>
        </div>

        <div class="form-group">
            <label for="driverPhoneNumber">Phone Number</label>
            <input type="text" id="driverPhoneNumber" name="driverPhoneNumber" class="form-control" value="<%= driverPhoneNumber %>" required>
        </div>

        <div class="form-group">
            <label for="driverNic">NIC</label>
            <input type="text" id="driverNic" name="driverNic" class="form-control" value="<%= driverNic %>" required>
        </div>

        <div class="form-group">
            <label for="driverLicenseNumber">License Number</label>
            <input type="text" id="driverLicenseNumber" name="driverLicenseNumber" class="form-control" value="<%= driverLicenseNumber %>" required>
        </div>

        <!-- Photos -->
        <div class="form-group">
            <label for="photo1">Upload Photo 1</label>
            <input type="file" id="photo1" name="photo1" class="form-control">
        </div>

        <div class="form-group">
            <label for="photo2">Upload Photo 2</label>
            <input type="file" id="photo2" name="photo2" class="form-control">
        </div>

        <div class="form-group">
            <label for="photo3">Upload Photo 3</label>
            <input type="file" id="photo3" name="photo3" class="form-control">
        </div>

        <button type="submit" class="btn btn-primary">Update Vehicle</button>
    </form>
</div>
</body>
</html>
