<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection, org.cablink.megacitycab.util.ImageUtil, jakarta.servlet.http.HttpSession" %>
<%
  HttpSession sessionObj = request.getSession(false);
  if (session == null || session.getAttribute("userId") == null) {
    response.sendRedirect("login.jsp?error=Please login first");
    return;
  }
  Integer userId = (Integer) session.getAttribute("userId");
  String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Customer Dashboard</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body { background-color: #f8f9fa; }
    .vehicle-card { margin-bottom: 20px; }
    .carousel-inner img { width: 100%; height: 200px; object-fit: cover; }
    .navbar-brand { font-weight: bold; }
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand" href="#">MegaCityCab</a>
  <div class="collapse navbar-collapse">
    <ul class="navbar-nav ml-auto">
      <li class="nav-item"><a class="nav-link" href="#">Welcome, <%= username %></a></li>
      <li class="nav-item"><a class="nav-link btn " href="customer-dashboard.jsp">Home</a></li>
      <li class="nav-item"><a class="nav-link" href="bookings.jsp">Your Bookings</a></li>
      <li class="nav-item"><a class="nav-link btn btn-danger text-white" href="Logout.jsp">Logout</a></li>
      <li class="nav-item"><a class="nav-link btn " href="profile.jsp">Profile</a></li>

    </ul>
  </div>
</nav>

<div class="container mt-4">
  <h2>Available Vehicles</h2>

  <!-- 🔹 Search & Filter Section -->
  <div class="row mb-3">
    <div class="col-md-4">
      <label>Vehicle Type:</label>
      <select class="form-control" id="vehicleTypeFilter">
        <option value="">All</option>
        <option value="Car">Car</option>
        <option value="Bike">Bike</option>
        <option value="TukTuk">TukTuk</option>
        <option value="Van">Van</option>
      </select>
    </div>
    <div class="col-md-4">
      <label>Min Capacity:</label>
      <input type="number" class="form-control" id="capacityFilter" placeholder="Min Capacity">
    </div>
    <div class="col-md-4">
      <label>Max Price (LKR):</label>
      <input type="number" class="form-control" id="priceFilter" placeholder="Max Price">
    </div>
  </div>

  <div class="row" id="vehicleList">
    <%
      try (Connection conn = DBConnection.getConnection();
           Statement stmt = conn.createStatement();
           ResultSet rs = stmt.executeQuery("SELECT * FROM vehicles WHERE status='available'")) {

        while (rs.next()) {
          int id = rs.getInt("id");
          String vehicleName = rs.getString("vehicle_name");
          String model = rs.getString("model");
          String vehicleType = rs.getString("vehicle_type");
          int capacity = rs.getInt("capacity");
          double pricePerDay = rs.getDouble("price_per_day");
          String photo1 = ImageUtil.getImageURL(rs.getString("photo1"));
    %>
    <div class="col-md-4 vehicle-card" data-type="<%= vehicleType %>" data-capacity="<%= capacity %>" data-price="<%= pricePerDay %>">
      <div class="card">
        <img src="<%= photo1 %>" class="card-img-top">
        <div class="card-body">
          <h5 class="card-title"><%= vehicleName %></h5>
          <p class="card-text"><strong>Model:</strong> <%= model %></p>
          <p class="card-text"><strong>Capacity:</strong> <%= capacity %> people</p>
          <p class="card-text"><strong>Price per Day:</strong> LKR <%= pricePerDay %></p>
          <a href="bookVehicle.jsp?vehicleId=<%= id %>" class="btn btn-primary btn-block">Book Now</a>
        </div>
      </div>
    </div>
    <% } } catch (SQLException e) { e.printStackTrace(); } %>
  </div>
</div>

<!-- 🔹 JavaScript for Filtering -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script>
  $(document).ready(function () {
    $("#vehicleTypeFilter, #capacityFilter, #priceFilter").on("input", function () {
      let typeFilter = $("#vehicleTypeFilter").val().toLowerCase();
      let capacityFilter = parseInt($("#capacityFilter").val()) || 0;
      let priceFilter = parseFloat($("#priceFilter").val()) || Infinity;

      $(".vehicle-card").each(function () {
        let type = $(this).data("type").toLowerCase();
        let capacity = parseInt($(this).data("capacity"));
        let price = parseFloat($(this).data("price"));

        let matchType = typeFilter === "" || type.includes(typeFilter);
        let matchCapacity = capacity >= capacityFilter;
        let matchPrice = price <= priceFilter;

        $(this).toggle(matchType && matchCapacity && matchPrice);
      });
    });
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
