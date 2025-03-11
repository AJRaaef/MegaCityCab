<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection, jakarta.servlet.http.HttpSession, java.util.ArrayList, java.util.List" %>
<%
    // Check if the admin is logged in

    if (session == null || session.getAttribute("adminId") == null) {
        response.sendRedirect("adminLogin.jsp?error=Please login first");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // Handle status update
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String bookingIdStr = request.getParameter("bookingId");
        String newStatus = request.getParameter("status");

        if (bookingIdStr != null && !bookingIdStr.isEmpty() && newStatus != null && !newStatus.isEmpty()) {
            try {
                int bookingId = Integer.parseInt(bookingIdStr);
                conn = DBConnection.getConnection();
                if (conn == null) {
                    System.out.println("<h3 style='color: red;'>Error: Unable to connect to the database.</h3>");
                    return;
                }

                // Update the booking status
                String updateQuery = "UPDATE bookings SET status = ? WHERE booking_id = ?";
                ps = conn.prepareStatement(updateQuery);
                ps.setString(1, newStatus);
                ps.setInt(2, bookingId);
                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    System.out.println("<h3 style='color: green;'>Booking status updated successfully.</h3>");
                } else {
                    System.out.println("<h3 style='color: red;'>Error: Unable to update booking status.</h3>");
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                System.out.println("<h3 style='color: red;'>Error: Unable to update booking status.</h3>");
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Fetch all bookings with customer, vehicle, and driver details
    List<String[]> bookings = new ArrayList<>();
    try {
        conn = DBConnection.getConnection();
        if (conn == null) {
            System.out.println("<h3 style='color: red;'>Error: Unable to connect to the database.</h3>");
            return;
        }

        // Query to fetch all bookings with customer, vehicle, and driver details
        String query = "SELECT b.booking_id, b.customer_id, b.vehicle_id, b.driver_id, b.start_date, b.end_date, b.total_days, b.total_amount, b.status, b.created_at, " +
                "c.full_name AS customer_name, c.email AS customer_email, c.phone_number AS customer_phone, " +
                "v.vehicle_name, v.model, v.capacity, v.price_per_day, v.vehicle_type, " +
                "d.full_name AS driver_name, d.phone_number AS driver_phone " +
                "FROM bookings b " +
                "JOIN customers c ON b.customer_id = c.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN drivers d ON b.driver_id = d.id " +
                "ORDER BY b.created_at DESC";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        while (rs.next()) {
            String[] booking = {
                    rs.getString("booking_id"),
                    rs.getString("customer_id"),
                    rs.getString("vehicle_id"),
                    rs.getString("driver_id"),
                    rs.getString("start_date"),
                    rs.getString("end_date"),
                    rs.getString("total_days"),
                    rs.getString("total_amount"),
                    rs.getString("status"),
                    rs.getString("created_at"),
                    rs.getString("customer_name"),
                    rs.getString("customer_email"),
                    rs.getString("customer_phone"),
                    rs.getString("vehicle_name"),
                    rs.getString("model"),
                    rs.getString("capacity"),
                    rs.getString("price_per_day"),
                    rs.getString("vehicle_type"),
                    rs.getString("driver_name"),
                    rs.getString("driver_phone")
            };
            bookings.add(booking);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("<h3 style='color: red;'>Error: Unable to fetch bookings.</h3>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Bookings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .booking-table {
            margin-top: 20px;
        }
        .status-form {
            display: inline-block;
        }
        .details {
            margin-top: 10px;
            padding: 10px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mt-4">Manage Bookings</h2>
    <a href="adminDashboard.jsp" class="btn btn-primary mb-3">Back to Dashboard</a>

    <%-- Display bookings in a table --%>
    <table class="table table-bordered table-striped booking-table">
        <thead class="table-dark">
        <tr>
            <th>Booking ID</th>
            <th>Customer Details</th>
            <th>Vehicle Details</th>
            <th>Driver Details</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Total Days</th>
            <th>Total Amount</th>
            <th>Status</th>
            <th>Created At</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (String[] booking : bookings) {
        %>
        <tr>
            <td><%= booking[0] %></td>
            <td>
                <div class="details">
                    <p><b>Name:</b> <%= booking[10] %></p>
                    <p><b>Email:</b> <%= booking[11] %></p>
                    <p><b>Phone:</b> <%= booking[12] %></p>
                </div>
            </td>
            <td>
                <div class="details">
                    <p><b>Name:</b> <%= booking[13] %></p>
                    <p><b>Model:</b> <%= booking[14] %></p>
                    <p><b>Capacity:</b> <%= booking[15] %></p>
                    <p><b>Price/Day:</b> $<%= booking[16] %></p>
                    <p><b>Type:</b> <%= booking[17] %></p>
                </div>
            </td>
            <td>
                <div class="details">
                    <p><b>Name:</b> <%= booking[18] %></p>
                    <p><b>Phone:</b> <%= booking[19] %></p>
                </div>
            </td>
            <td><%= booking[4] %></td>
            <td><%= booking[5] %></td>
            <td><%= booking[6] %></td>
            <td>$<%= booking[7] %></td>
            <td>
                <span class="badge bg-<%= booking[8].equals("confirmed") ? "success" : booking[8].equals("cancelled") ? "danger" : "warning" %>">
                    <%= booking[8] %>
                </span>
            </td>
            <td><%= booking[9] %></td>
            <td>
                <form action="manageBookings.jsp" method="post" class="status-form">
                    <input type="hidden" name="bookingId" value="<%= booking[0] %>">
                    <select name="status" class="form-select">
                        <option value="pending" <%= booking[8].equals("pending") ? "selected" : "" %>>Pending</option>
                        <option value="confirmed" <%= booking[8].equals("confirmed") ? "selected" : "" %>>Confirmed</option>
                        <option value="cancelled" <%= booking[8].equals("cancelled") ? "selected" : "" %>>Cancelled</option>
                    </select>
                    <button type="submit" class="btn btn-sm btn-primary mt-2">Update</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>