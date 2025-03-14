<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection, org.cablink.megacitycab.util.ImageUtil" %>
<%
    String action = request.getParameter("action");
    int vehicleIdToEdit = -1;
    String vehicleName = "";
    String model = "";
    String vehicleType = "";
    int capacity = 0;
    double pricePerDay = 0;
    String photo1 = "";

    // Fetch vehicle details for editing
    if ("edit".equals(action)) {
        vehicleIdToEdit = Integer.parseInt(request.getParameter("vehicleId"));
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM vehicles WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, vehicleIdToEdit);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                vehicleName = rs.getString("vehicle_name");
                model = rs.getString("model");
                vehicleType = rs.getString("vehicle_type");
                capacity = rs.getInt("capacity");
                pricePerDay = rs.getDouble("price_per_day");
                photo1 = ImageUtil.getImageURL(rs.getString("photo1"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Handle vehicle update
    if ("update".equals(action)) {
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        String newVehicleName = request.getParameter("vehicleName");
        String newModel = request.getParameter("model");
        String newVehicleType = request.getParameter("vehicleType");
        int newCapacity = Integer.parseInt(request.getParameter("capacity"));
        double newPricePerDay = Double.parseDouble(request.getParameter("pricePerDay"));

        try (Connection conn = DBConnection.getConnection()) {
            String updateQuery = "UPDATE vehicles SET vehicle_name = ?, model = ?, vehicle_type = ?, capacity = ?, price_per_day = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, newVehicleName);
            stmt.setString(2, newModel);
            stmt.setString(3, newVehicleType);
            stmt.setInt(4, newCapacity);
            stmt.setDouble(5, newPricePerDay);
            stmt.setInt(6, vehicleId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("listVehicles.jsp"); // Redirect after update
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Vehicles</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .vehicle-card { margin-bottom: 20px; }
        .carousel-inner img { width: 100%; height: 200px; object-fit: cover; }
        .navbar-brand { font-weight: bold; }
    </style>
</head>
<body>

<div class="container mt-4">
    <h2>Manage Vehicles</h2>

    <!-- Vehicle List -->
    <div class="row" id="vehicleList">
        <%
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT * FROM vehicles WHERE status='available'")) {

                while (rs.next()) {
                    int id = rs.getInt("id");
                    vehicleName = rs.getString("vehicle_name");
                     model = rs.getString("model");
                    vehicleType = rs.getString("vehicle_type");
                    capacity = rs.getInt("capacity");
                    pricePerDay = rs.getDouble("price_per_day");
                    photo1 = ImageUtil.getImageURL(rs.getString("photo1"));
        %>
        <div class="col-md-4 vehicle-card">
            <div class="card">
                <img src="<%= photo1 %>" class="card-img-top">
                <div class="card-body">
                    <h5 class="card-title"><%= vehicleName %></h5>
                    <p class="card-text"><strong>Model:</strong> <%= model %></p>
                    <p class="card-text"><strong>Capacity:</strong> <%= capacity %> people</p>
                    <p class="card-text"><strong>Price per Day:</strong> LKR <%= pricePerDay %></p>

                    <!-- Edit Button -->
                    <a href="listVehicles.jsp?action=edit&vehicleId=<%= id %>" class="btn btn-warning btn-block">Edit</a>
                    <!-- Delete Button -->
                    <a href="deleteVehicle.jsp?vehicleId=<%= id %>" class="btn btn-danger btn-block" onclick="return confirm('Are you sure you want to delete this vehicle?')">Delete</a>
                </div>
            </div>
        </div>
        <% } } catch (SQLException e) { e.printStackTrace(); } %>
    </div>

    <% if ("edit".equals(action)) { %>
    <!-- Edit Vehicle Form -->
    <div class="mt-4">
        <h3>Edit Vehicle Details</h3>
        <form action="listVehicles.jsp?action=update&vehicleId=<%= vehicleIdToEdit %>" method="POST">
            <div class="form-group">
                <label for="vehicleName">Vehicle Name</label>
                <input type="text" class="form-control" id="vehicleName" name="vehicleName" value="<%= vehicleName %>" required>
            </div>
            <div class="form-group">
                <label for="model">Model</label>
                <input type="text" class="form-control" id="model" name="model" value="<%= model %>" required>
            </div>
            <div class="form-group">
                <label for="vehicleType">Vehicle Type</label>
                <input type="text" class="form-control" id="vehicleType" name="vehicleType" value="<%= vehicleType %>" required>
            </div>
            <div class="form-group">
                <label for="capacity">Capacity</label>
                <input type="number" class="form-control" id="capacity" name="capacity" value="<%= capacity %>" required>
            </div>
            <div class="form-group">
                <label for="pricePerDay">Price per Day (LKR)</label>
                <input type="number" class="form-control" id="pricePerDay" name="pricePerDay" value="<%= pricePerDay %>" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Update Vehicle</button>
        </form>
    </div>
    <% } %>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
