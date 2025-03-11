<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Check if the admin is logged in

    if (session == null || session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp?error=Please login first");
        return;
    }

    int adminId = (Integer) session.getAttribute("adminId");
    String fullName = (String) session.getAttribute("fullName");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .dashboard-container {
            margin-top: 20px;
        }
        .nav-button {
            margin: 10px;
            padding: 15px 30px;
            font-size: 18px;
            width: 100%;
        }
    </style>
</head>
<body>
<div class="container dashboard-container">
    <h2 class="mt-4">Welcome, <%= fullName %>!</h2>
    <p>You are logged in as Admin.</p>

    <!-- Navigation Buttons -->
    <div class="row">
        <div class="col-md-3">
            <a href="adminDashboard.jsp" class="btn btn-primary nav-button">Home</a>
        </div>
        <div class="col-md-3">
            <a href="manageBookings.jsp" class="btn btn-success nav-button">Manage Bookings</a>
        </div>
        <div class="col-md-3">
            <a href="addVehicle.jsp" class="btn btn-warning nav-button">Add Vehicles</a>
        </div>
        <div class="col-md-3">
            <a href="addDriver.jsp" class="btn btn-danger nav-button">Add Drivers</a>
        </div>
        <div class="col-md-3">
            <a href="listVehicles.jsp" class="btn btn-danger nav-button">Manage Veichles</a>
        </div>
    </div>

    <!-- Logout Button -->
    <div class="mt-4">
        <a href="Logout.jsp" class="btn btn-secondary">Logout</a>
    </div>
</div>
</body>
</html>