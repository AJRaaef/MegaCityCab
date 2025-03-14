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
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">Megacity Cab</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNav">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" href="driverBookings.jsp">upcoming booking</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="Logout.jsp">Logout</a>
      </li>
    </ul>
  </div>
</nav>

<!-- Driver Dashboard Content -->
<div class="container mt-5">
  <h2>Welcome, Driver</h2>
  <h4>Your Vehicle(s)</h4>

  <%
    if (vehicles.isEmpty()) {
  %>
  <p>No vehicles found for this driver.</p>
  <%
  } else {
  %>
  <div class="row">
    <%
      for (Map<String, Object> vehicle : vehicles) {
    %>
    <div class="col-md-4">
      <div class="card mb-4">
        <img src="<%= vehicle.get("photo1") %>" class="card-img-top" alt="Vehicle Image">
        <div class="card-body">
          <h5 class="card-title"><%= vehicle.get("vehicle_name") %></h5>
          <p class="card-text">Model: <%= vehicle.get("model") %></p>
          <p class="card-text">Capacity: <%= vehicle.get("capacity") %> people</p>
          <p class="card-text">Price per day: $<%= vehicle.get("price_per_day") %></p>
          <p class="card-text">Status: <%= vehicle.get("status") %></p>
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

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
