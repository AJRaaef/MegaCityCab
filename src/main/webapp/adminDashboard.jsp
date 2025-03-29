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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .dashboard-container {
            margin-top: 30px;
        }
        .card {
            transition: 0.3s;
            cursor: pointer;
        }
        .card:hover {
            transform: scale(1.05);
        }
        .logout-btn {
            width: 100%;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Megacity Cab - Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="adminDashboard.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="manageBookings.jsp">Manage Bookings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="listVehicles.jsp">Manage Vehicles</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-danger text-white ms-2" href="Logout.jsp">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Dashboard Content -->
<div class="container dashboard-container">
    <div class="text-center mb-4">
        <h2>Welcome, <%= fullName %>!</h2>
        <p class="text-muted">You are logged in as Admin.</p>
    </div>

    <!-- Dashboard Options -->
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card text-bg-primary text-center p-3" onclick="location.href='adminDashboard.jsp'">
                <div class="card-body">
                    <h5 class="card-title">Home</h5>
                    <p class="card-text">Go to the admin homepage</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-bg-success text-center p-3" onclick="location.href='manageBookings.jsp'">
                <div class="card-body">
                    <h5 class="card-title">Manage Bookings</h5>
                    <p class="card-text">View and update bookings</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-bg-warning text-center p-3" onclick="location.href='addVehicle.jsp'">
                <div class="card-body">
                    <h5 class="card-title">Add Vehicles</h5>
                    <p class="card-text">Add new vehicles to the fleet</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-bg-danger text-center p-3" onclick="location.href='addDriver.jsp'">
                <div class="card-body">
                    <h5 class="card-title">Add Drivers</h5>
                    <p class="card-text">Register new drivers</p>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-bg-info text-center p-3" onclick="location.href='listVehicles.jsp'">
                <div class="card-body">
                    <h5 class="card-title">Manage Vehicles</h5>
                    <p class="card-text">Edit or remove vehicles</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Logout Button -->
    <div class="mt-4 text-center">
        <a href="Logout.jsp" class="btn btn-danger logout-btn">Logout</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
