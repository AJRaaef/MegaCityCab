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
  List<Map<String, Object>> bookings = new ArrayList<>();

  Connection conn = null;
  PreparedStatement stmt = null;
  ResultSet rs = null;

  try {
    conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

    // SQL query to get bookings for the driver along with vehicle and customer info
    String sql = "SELECT b.booking_id, b.start_date, b.end_date, b.total_days, b.total_amount, b.status, "
            + "v.vehicle_name, v.model, v.capacity, v.price_per_day, v.photo1, "
            + "c.full_name, c.email, c.phone_number "
            + "FROM bookings b "
            + "JOIN vehicles v ON b.vehicle_id = v.id "
            + "JOIN customers c ON b.customer_id = c.id "
            + "WHERE b.driver_id = ?";

    stmt = conn.prepareStatement(sql);
    stmt.setInt(1, driverId);  // Set driver ID to filter bookings
    rs = stmt.executeQuery();

    while (rs.next()) {
      Map<String, Object> booking = new HashMap<>();
      booking.put("booking_id", rs.getInt("booking_id"));
      booking.put("start_date", rs.getDate("start_date"));
      booking.put("end_date", rs.getDate("end_date"));
      booking.put("total_days", rs.getInt("total_days"));
      booking.put("total_amount", rs.getDouble("total_amount"));
      booking.put("status", rs.getString("status"));
      booking.put("vehicle_name", rs.getString("vehicle_name"));
      booking.put("model", rs.getString("model"));
      booking.put("capacity", rs.getInt("capacity"));
      booking.put("price_per_day", rs.getDouble("price_per_day"));
      booking.put("photo1", rs.getString("photo1"));
      booking.put("customer_name", rs.getString("full_name"));
      booking.put("customer_email", rs.getString("email"));
      booking.put("customer_phone", rs.getString("phone_number"));
      bookings.add(booking);
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
  <title>Driver Bookings</title>
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
        <a class="nav-link" href="driver-dashboard.jsp">Dashboard</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="driverBookings.jsp">Bookings</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="logout.jsp">Logout</a>
      </li>
    </ul>
  </div>
</nav>

<!-- Driver Bookings Content -->
<div class="container mt-5">
  <h2>Your Bookings</h2>

  <%
    if (bookings.isEmpty()) {
  %>
  <p>No bookings found for this driver.</p>
  <%
  } else {
  %>
  <div class="table-responsive">
    <table class="table table-bordered">
      <thead>
      <tr>
        <th>Booking ID</th>
        <th>Vehicle Name</th>
        <th>Customer Name</th>
        <th>Start Date</th>
        <th>End Date</th>
        <th>Total Days</th>
        <th>Total Amount</th>
        <th>Status</th>
      </tr>
      </thead>
      <tbody>
      <%
        for (Map<String, Object> booking : bookings) {
      %>
      <tr>
        <td><%= booking.get("booking_id") %></td>
        <td>
          <img src="<%= booking.get("photo1") %>" alt="Vehicle Image" class="img-thumbnail" width="100">
          <%= booking.get("vehicle_name") %> (<%= booking.get("model") %>)
        </td>
        <td><%= booking.get("customer_name") %><br><%= booking.get("customer_email") %><br><%= booking.get("customer_phone") %></td>
        <td><%= booking.get("start_date") %></td>
        <td><%= booking.get("end_date") %></td>
        <td><%= booking.get("total_days") %></td>
        <td>$<%= booking.get("total_amount") %></td>
        <td><%= booking.get("status") %></td>
      </tr>
      <%
        }
      %>
      </tbody>
    </table>
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
