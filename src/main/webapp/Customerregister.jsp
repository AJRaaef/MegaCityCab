<%@ page import="java.sql.*, java.io.*, jakarta.servlet.http.*, jakarta.servlet.ServletException, jakarta.servlet.annotation.MultipartConfig, jakarta.servlet.http.Part,org.cablink.megacitycab.util.DBConnection" %>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Get form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");
        String address = request.getParameter("address");
        String profileInfo = request.getParameter("profile_info");
        String role = request.getParameter("role");



        // Insert data into the database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO customers (username, password, full_name, email, phone_number, address, profile_info,  role) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);  // No hashing for simplicity
            stmt.setString(3, fullName);
            stmt.setString(4, email);
            stmt.setString(5, phoneNumber);
            stmt.setString(6, address);
            stmt.setString(7, profileInfo);
            stmt.setString(8, role);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("login.jsp");
            } else {
                System.out.println("Failed to insert data.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Registration</title>
</head>
<body>
<h2>Customer Registration</h2>
<form action="Customerregister.jsp" method="POST" >
    <label>Username:</label>
    <input type="text" name="username" required><br><br>

    <label>Password:</label>
    <input type="password" name="password" required><br><br>

    <label>Full Name:</label>
    <input type="text" name="full_name" required><br><br>

    <label>Email:</label>
    <input type="email" name="email" required><br><br>

    <label>Phone Number:</label>
    <input type="text" name="phone_number" required><br><br>

    <label>Address:</label>
    <input type="text" name="address" required><br><br>

    <label>Profile Info:</label>
    <textarea name="profile_info"></textarea><br><br>



    <label>Role:</label>
    <select name="role">
        <option value="Customer">Customer</option>
    </select><br><br>

    <button type="submit">Register</button>
</form>
</body>
</html>
