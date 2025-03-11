<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection, java.io.File, jakarta.servlet.http.Part" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Initialize variables
    String errorMessage = "";
    String successMessage = "";

    // Fetch vehicle details if vehicleId is provided
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

    if (request.getParameter("vehicleId") != null) {
        vehicleId = Integer.parseInt(request.getParameter("vehicleId"));

        // Fetch vehicle details from the database
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM vehicles WHERE id = ?")) {

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
            }
        } catch (SQLException e) {
            e.printStackTrace();
            errorMessage = "Error: Unable to fetch vehicle details.";
        }
    } else {
        errorMessage = "Error: Vehicle ID is missing.";
    }

    // Check if the form is submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Handle file uploads
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

        // If no new photo is uploaded, retain the existing photo path
        if (photo1 == null || photo1.isEmpty()) {
            photo1 = request.getParameter("existingPhoto1");
        }
        if (photo2 == null || photo2.isEmpty()) {
            photo2 = request.getParameter("existingPhoto2");
        }
        if (photo3 == null || photo3.isEmpty()) {
            photo3 = request.getParameter("existingPhoto3");
        }

        // Update the vehicle details in the database
        try (Connection conn = DBConnection.getConnection()) {
            String query = "UPDATE vehicles SET vehicle_name = ?, model = ?, vehicle_type = ?, capacity = ?, price_per_day = ?, status = ?, driver_id = ?, photo1 = ?, photo2 = ?, photo3 = ? WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, vehicleName);
            pstmt.setString(2, model);
            pstmt.setString(3, vehicleType);
            pstmt.setInt(4, capacity);
            pstmt.setDouble(5, pricePerDay);
            pstmt.setString(6, status);
            pstmt.setInt(7, driverId);
            pstmt.setString(8, photo1);
            pstmt.setString(9, photo2);
            pstmt.setString(10, photo3);
            pstmt.setInt(11, vehicleId);

            // Debug: Print the SQL query and parameters
            System.out.println("Executing Query: " + query);
            System.out.println("Parameters:");
            System.out.println("1. Vehicle Name: " + vehicleName);
            System.out.println("2. Model: " + model);
            System.out.println("3. Vehicle Type: " + vehicleType);
            System.out.println("4. Capacity: " + capacity);
            System.out.println("5. Price Per Day: " + pricePerDay);
            System.out.println("6. Status: " + status);
            System.out.println("7. Driver ID: " + driverId);
            System.out.println("8. Photo 1: " + photo1);
            System.out.println("9. Photo 2: " + photo2);
            System.out.println("10. Photo 3: " + photo3);
            System.out.println("11. Vehicle ID: " + vehicleId);

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
            <label for="pricePerDay">Price Per Day</label>
            <input type="number" step="0.01" id="pricePerDay" name="pricePerDay" class="form-control" value="<%= pricePerDay %>" required>
        </div>

        <div class="form-group">
            <label for="status">Status</label>
            <select id="status" name="status" class="form-control" required>
                <option value="available" <%= "available".equals(status) ? "selected" : "" %>>Available</option>
                <option value="booking" <%= "booking".equals(status) ? "selected" : "" %>>Booking</option>
                <option value="processing" <%= "processing".equals(status) ? "selected" : "" %>>Processing</option>
            </select>
        </div>

        <div class="form-group">
            <label for="driverId">Driver</label>
            <select id="driverId" name="driverId" class="form-control" required>
                <option value="">Select Driver</option>
                <%
                    try (Connection conn = DBConnection.getConnection();
                         PreparedStatement pstmt = conn.prepareStatement("SELECT id, full_name FROM drivers");
                         ResultSet rs = pstmt.executeQuery()) {

                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String fullName = rs.getString("full_name");
                %>
                <option value="<%= id %>" <%= id == driverId ? "selected" : "" %>><%= fullName %></option>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select>
        </div>

        <div class="form-group">
            <label for="photo1">Photo 1</label>
            <input type="file" id="photo1" name="photo1" class="form-control">
            <small class="form-text text-muted">Current photo: <%= photo1 != null && !photo1.isEmpty() ? photo1 : "No photo available" %></small>
        </div>

        <div class="form-group">
            <label for="photo2">Photo 2</label>
            <input type="file" id="photo2" name="photo2" class="form-control">
            <small class="form-text text-muted">Current photo: <%= photo2 != null && !photo2.isEmpty() ? photo2 : "No photo available" %></small>
        </div>

        <div class="form-group">
            <label for="photo3">Photo 3</label>
            <input type="file" id="photo3" name="photo3" class="form-control">
            <small class="form-text text-muted">Current photo: <%= photo3 != null && !photo3.isEmpty() ? photo3 : "No photo available" %></small>
        </div>

        <button type="submit" class="btn btn-primary">Save Changes</button>
        <a href="editVehicles.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>