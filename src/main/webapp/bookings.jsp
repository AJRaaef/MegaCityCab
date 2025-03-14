<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="org.cablink.megacitycab.util.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<html>
<head>
  <title>My Bookings</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .booking-table {
      margin-top: 20px;
    }
    .no-bookings {
      text-align: center;
      padding: 20px;
      font-size: 18px;
      color: #666;
    }
  </style>
</head>
<body>

<%-- Session Check --%>
<%
  HttpSession sessionObj = request.getSession(false);
  if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return;
  }

  // Get the logged-in user ID
  int userId = (Integer) sessionObj.getAttribute("userId");

  // Initialize booking list
  List<String[]> bookings = new ArrayList<>();

  Connection connection = null;
  PreparedStatement ps = null;
  ResultSet rs = null;

  try {
    // Get the database connection
    connection = DBConnection.getConnection();

    // Query to get bookings for the logged-in user
    String sql = "SELECT booking_id, vehicle_id, driver_id, start_date, end_date, total_days, total_amount, status, created_at " +
            "FROM bookings WHERE customer_id = ?";
    ps = connection.prepareStatement(sql);
    ps.setInt(1, userId);
    rs = ps.executeQuery();

    // Fetch bookings into the list
    while (rs.next()) {
      String[] booking = {
              rs.getString("booking_id"),
              rs.getString("vehicle_id"),
              rs.getString("driver_id"),
              rs.getString("start_date"),
              rs.getString("end_date"),
              rs.getString("total_days"),
              rs.getString("total_amount"),
              rs.getString("status"),
              rs.getString("created_at")
      };
      bookings.add(booking);
    }
  } catch (SQLException e) {
    e.printStackTrace();
  } finally {
    try {
      if (rs != null) rs.close();
      if (ps != null) ps.close();
      if (connection != null) connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
%>

<div class="container">
  <h2 class="mt-4 mb-4">My Bookings</h2>

  <%-- Display bookings in a table --%>
  <%
    if (!bookings.isEmpty()) {
  %>
  <table class="table table-bordered table-striped booking-table">
    <thead class="table-dark">
    <tr>
      <th>Booking ID</th>
      <th>Vehicle ID</th>
      <th>Driver ID</th>
      <th>Start Date</th>
      <th>End Date</th>
      <th>Total Days</th>
      <th>Total Amount</th>
      <th>Status</th>
      <th>Booked On</th>
    </tr>
    </thead>
    <tbody>
    <%
      for (String[] booking : bookings) {
    %>
    <tr>
      <td><%= booking[0] %></td>
      <td><%= booking[1] %></td>
      <td><%= booking[2] %></td>
      <td><%= booking[3] %></td>
      <td><%= booking[4] %></td>
      <td><%= booking[5] %></td>
      <td>$<%= booking[6] %></td>
      <td>
                <span class="badge bg-<%= booking[7].equals("confirmed") ? "success" : booking[7].equals("cancelled") ? "danger" : "warning" %>">
                    <%= booking[7] %>
                </span>
      </td>
      <td><%= booking[8] %></td>
    </tr>
    <%
      }
    %>
    </tbody>
  </table>
  <%
  } else {
  %>
  <div class="no-bookings">
    No bookings found.
  </div>
  <%
    }
  %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>