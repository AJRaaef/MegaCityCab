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
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Dashboard | MegaCityCab</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
  <style>
    body {
      background-color: #121212;
      color: white;
    }
    .navbar {
      background-color: #1f1f1f;
    }
    .navbar-brand {
      font-size: 1.5rem;
      font-weight: bold;
    }
    .card {
      background: #1c1c1c;
      color: white;
      border-radius: 12px;
      overflow: hidden;
      transition: transform 0.3s ease;
    }
    .card:hover {
      transform: scale(1.05);
    }
    .card img {
      height: 200px;
      object-fit: cover;
    }
    .filter-section {
      background: #1f1f1f;
      padding: 15px;
      border-radius: 10px;
    }
    .btn-primary {
      background: #ff9800;
      border: none;
    }
    .btn-primary:hover {
      background: #e68900;
    }
  </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <a class="navbar-brand" href="#">MegaCityCab</a>
  <div class="ml-auto">
    <a class="btn btn-outline-light" href="profile.jsp">Welcome, <%= username %></a>
    <a class="btn btn-warning ml-2" href="bookings.jsp">Your Bookings</a>
    <a class="btn btn-danger ml-2" href="Logout.jsp">Logout</a>
  </div>
</nav>

<div class="container mt-4">
  <h2 class="text-center mb-4">🚗 Available Vehicles</h2>

  <!-- Filters -->
  <div class="row filter-section text-white mb-4">
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
    <% try (Connection conn = DBConnection.getConnection();
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
    <div class="col-md-4 vehicle-card mb-4" data-type="<%= vehicleType %>" data-capacity="<%= capacity %>" data-price="<%= pricePerDay %>">
      <div class="card">
        <img src="<%= photo1 %>" class="card-img-top">
        <div class="card-body text-center">
          <h5 class="card-title">🚘 <%= vehicleName %></h5>
          <p class="card-text">Model: <strong><%= model %></strong></p>
          <p class="card-text">Capacity: <strong><%= capacity %></strong> people</p>
          <p class="card-text">Price per Day: <strong>LKR <%= pricePerDay %></strong></p>
          <a href="bookVehicle.jsp?vehicleId=<%= id %>" class="btn btn-primary btn-block">Book Now</a>
        </div>
      </div>
    </div>
    <% } } catch (SQLException e) { e.printStackTrace(); } %>
  </div>
</div>

<!-- JavaScript for Filtering -->
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

