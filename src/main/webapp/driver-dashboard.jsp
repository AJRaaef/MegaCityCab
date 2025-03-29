<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  // Get the driver ID from the session

  Integer driverId = (Integer) session.getAttribute("userId");

  // Check if driverId is null
  if (driverId == null) {
    response.sendRedirect("login.jsp?error=Please login to access your dashboard.");
    return;
  }

  // Database connection setup
  String jdbcUrl = "jdbc:mysql://localhost:3306/megacitycab";
  String jdbcUser = "root";
  String jdbcPassword = "";
  List<Map<String, Object>> vehicles = new ArrayList<>();

  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;

  try {
    conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
    String sql = "SELECT * FROM vehicles WHERE driver_id = ?";
    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, driverId);
    rs = stmt.executeQuery();

    while (rs.next()) {
      Map<String, Object> vehicle = new HashMap<>();
      vehicle.put("id", rs.getInt("id"));
      vehicle.put("vehicle_name", rs.getString("vehicle_name"));
      vehicle.put("model", rs.getString("model"));
      vehicle.put("capacity", rs.getInt("capacity"));
      vehicle.put("price_per_day", rs.getDouble("price_per_day"));
      vehicle.put("status", rs.getString("status"));
      vehicle.put("photo1", rs.getString("photo1"));
      vehicles.add(vehicle);
    }
  } catch (SQLException e) {
    e.printStackTrace();
  } finally {
    try {
      if (rs != null) rs.close();
      if (stmt != null) stmt.close();
      if (conn != null) conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Custom Styles */
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background-color: #007bff !important;
        }
        .navbar-brand, .nav-link {
            color: #fff !important;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: 0.3s;
        }
        .card:hover {
            transform: scale(1.03);
        }
        .card img {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .badge-available {
            background-color: green;
            color: white;
        }
        .badge-booked {
            background-color: red;
            color: white;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
    <a class="navbar-brand" href="#">🚖 Megacity Cab</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="driverBookings.jsp">📅 Upcoming Bookings</a>
            </li>
            <li class="nav-item">
                <a class="nav-link btn btn-danger text-white ml-2" href="Logout.jsp">🚪 Logout</a>
            </li>
        </ul>
    </div>
</nav>

<!-- Dashboard Content -->
<div class="container mt-5">
    <div class="text-center">
        <h2 class="mb-3">👋 Welcome, Driver</h2>
        <h4>Your Vehicle(s)</h4>
    </div>

    <%
        if (vehicles.isEmpty()) {
    %>
    <p class="text-center text-muted">No vehicles found for this driver.</p>
    <%
    } else {
    %>
    <div class="row">
        <%
            for (Map<String, Object> vehicle : vehicles) {
                String status = (String) vehicle.get("status");
                String statusClass = status.equalsIgnoreCase("available") ? "badge-available" : "badge-booked";
        %>
        <div class="col-md-4">
            <div class="card mb-4">
                <img src="<%= vehicle.get("photo1") %>" class="card-img-top" alt="Vehicle Image">
                <div class="card-body">
                    <h5 class="card-title">
                        <%= vehicle.get("vehicle_name") %>
                        <span class="badge <%= statusClass %>"><%= status %></span>
                    </h5>
                    <p class="card-text">🚗 Model: <strong><%= vehicle.get("model") %></strong></p>
                    <p class="card-text">👥 Capacity: <strong><%= vehicle.get("capacity") %> people</strong></p>
                    <p class="card-text">💲 Price per day: <strong>$<%= vehicle.get("price_per_day") %></strong></p>
                    <a href="vehicleDetails.jsp?id=<%= vehicle.get("id") %>" class="btn btn-info btn-sm">🔍 View Details</a>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
