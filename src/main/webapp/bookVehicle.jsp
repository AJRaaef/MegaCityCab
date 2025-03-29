<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection, jakarta.servlet.http.HttpSession" %>

<%
  // Fetch vehicle ID from the request
  String vehicleIdStr = request.getParameter("vehicleId");

  if (vehicleIdStr == null || vehicleIdStr.isEmpty()) {
    System.out.println("<h3 style='color: red;'>Error: Vehicle ID is missing in the URL.</h3>");
    return;
  }

  // Parse Vehicle ID
  int vehicleId = 0;
  try {
    vehicleId = Integer.parseInt(vehicleIdStr);
  } catch (NumberFormatException e) {
    System.out.println("<h3 style='color: red;'>Error: Invalid Vehicle ID in the URL.</h3>");
    return;
  }

  // Check if the user is logged in

  if (session == null || session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return;
  }

  int userId = Integer.parseInt(session.getAttribute("userId").toString());

  Connection conn = null;
  PreparedStatement ps = null;
  ResultSet rs = null;

  // Variables to store vehicle and driver details
  String vehicleName = "", model = "", vehicleType = "";
  int capacity = 0, driverId = 0;
  double pricePerDay = 0;
  String driverName = "", driverPhone = "";

  try {
    // Establish database connection
    conn = DBConnection.getConnection();
    if (conn == null) {
      System. out.println("<h3 style='color: red;'>Error: Unable to connect to the database.</h3>");
      return;
    }

    // Fetch vehicle and driver details
    String vehicleQuery = "SELECT v.vehicle_name, v.model, v.capacity, v.price_per_day, v.driver_id, v.vehicle_type, " +
            "d.full_name, d.phone_number " +
            "FROM vehicles v JOIN drivers d ON v.driver_id = d.id WHERE v.id = ?";
    ps = conn.prepareStatement(vehicleQuery);
    ps.setInt(1, vehicleId);
    rs = ps.executeQuery();

    if (rs.next()) {
      vehicleName = rs.getString("vehicle_name");
      model = rs.getString("model");
      capacity = rs.getInt("capacity");
      pricePerDay = rs.getDouble("price_per_day");
      driverId = rs.getInt("driver_id");
      vehicleType = rs.getString("vehicle_type");
      driverName = rs.getString("full_name");
      driverPhone = rs.getString("phone_number");
    } else {
      System. out.println("<h3 style='color: red;'>Error: Vehicle not found.</h3>");
      return;
    }
  } catch (SQLException e) {
    e.printStackTrace();
    System.out.println("<h3 style='color: red;'>Error: Unable to fetch vehicle details.</h3>");
    return;
  }

  // Handle form submission for booking
  if (request.getMethod().equalsIgnoreCase("POST")) {
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    // Calculate total days and total amount
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    long totalDays = 0;
    double totalAmount = 0;

    try {
      java.util.Date startDate = sdf.parse(startDateStr);
      java.util.Date endDate = sdf.parse(endDateStr);
      long difference = endDate.getTime() - startDate.getTime();
      totalDays = difference / (1000 * 60 * 60 * 24); // Convert milliseconds to days
      totalAmount = pricePerDay * totalDays;

      // Check if the user is eligible for a discount
      String countQuery = "SELECT COUNT(*) AS booking_count FROM bookings WHERE customer_id = ?";
      ps = conn.prepareStatement(countQuery);
      ps.setInt(1, userId);
      rs = ps.executeQuery();

      if (rs.next()) {
        int bookingCount = rs.getInt("booking_count");
        if (bookingCount > 2) {
          // Apply 15% discount
          totalAmount = totalAmount * 0.85; // 15% discount
          System. out.println("<h3 style='color: green;'>You are eligible for a 15% discount!</h3>");
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
      System.out.println("<h3 style='color: red;'>Error: Invalid date format.</h3>");
      return;
    }

    // Insert booking into the database
    String bookingQuery = "INSERT INTO bookings (customer_id, vehicle_id, driver_id, start_date, end_date, total_days, total_amount, status, created_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', NOW())";
    try {
      ps = conn.prepareStatement(bookingQuery);
      ps.setInt(1, userId);
      ps.setInt(2, vehicleId);
      ps.setInt(3, driverId);
      ps.setString(4, startDateStr);
      ps.setString(5, endDateStr);
      ps.setLong(6, totalDays);
      ps.setDouble(7, totalAmount);
      int rowsInserted = ps.executeUpdate();

      if (rowsInserted > 0) {
       System.out.println("<h3 style='color: green;'>Booking Successful!</h3>");
      } else {
        System.out.println("<h3 style='color: red;'>Error: Unable to book vehicle.</h3>");
      }
    } catch (SQLException e) {
      e.printStackTrace();
      System.out.println("<h3 style='color: red;'>Error: Unable to book vehicle.</h3>");
    }
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Book Vehicle</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
  <style>
    .container {
      max-width: 700px;
      margin: auto;
    }
    .card {
      border-radius: 10px;
      box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    }
    .btn-custom {
      width: 100%;
      margin-top: 10px;
    }
  </style>
</head>
<body>
<div class="container mt-5">
  <h2 class="text-center">🚗 Book a Vehicle</h2>

  <!-- Vehicle & Driver Details -->
  <div class="card p-3 my-4">
    <h4><i class="fas fa-car"></i> Vehicle Details</h4>
    <p><b>Name:</b> <%= vehicleName %></p>
    <p><b>Model:</b> <%= model %></p>
    <p><b>Capacity:</b> <%= capacity %> persons</p>
    <p><b>Price per Day:</b> $<%= pricePerDay %></p>
    <p><b>Vehicle Type:</b> <%= vehicleType %></p>

    <h4><i class="fas fa-user"></i> Driver Details</h4>
    <p><b>Name:</b> <%= driverName %></p>
    <p><b>Phone:</b> <%= driverPhone %></p>
  </div>

  <!-- Booking Form -->
  <div class="card p-3">
    <h4>📅 Booking Details</h4>
    <form action="" method="post">
      <div class="mb-3">
        <label for="startDate" class="form-label">Start Date:</label>
        <input type="date" id="startDate" name="startDate" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="endDate" class="form-label">End Date:</label>
        <input type="date" id="endDate" name="endDate" class="form-control" required>
      </div>
      <div class="mb-3">
        <label for="totalAmount" class="form-label">Total Amount ($):</label>
        <input type="text" id="totalAmount" name="totalAmount" class="form-control" readonly>
      </div>
      <button type="button" class="btn btn-secondary btn-custom" onclick="calculateTotal()">💰 Calculate Price</button>
      <button type="submit" class="btn btn-primary btn-custom">✅ Confirm Booking</button>
    </form>
  </div>
</div>

<script>
  function calculateTotal() {
    const pricePerDay = <%= pricePerDay %>;
    const startDate = new Date(document.getElementById("startDate").value);
    const endDate = new Date(document.getElementById("endDate").value);

    if (startDate && endDate && endDate > startDate) {
      const timeDifference = endDate - startDate;
      const totalDays = Math.ceil(timeDifference / (1000 * 60 * 60 * 24));
      const totalAmount = pricePerDay * totalDays;
      document.getElementById("totalAmount").value = totalAmount.toFixed(2);
    } else {
      alert("⚠️ Please select valid start and end dates.");
    }
  }
</script>
</body>
</html>
