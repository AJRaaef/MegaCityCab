<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection" %>
<%
    // Handle form submission
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            System.out.println("<h3 style='color: red;'>Error: Username and password are required.</h3>");
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Establish database connection
                conn = DBConnection.getConnection();
                if (conn == null) {
                    System.out.println("<h3 style='color: red;'>Error: Unable to connect to the database.</h3>");
                    return;
                }

                // Query to check admin credentials
                String sql = "SELECT admin_id, full_name FROM admin WHERE username = ? AND password = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    // Admin credentials are valid
                    int adminId = rs.getInt("admin_id");
                    String fullName = rs.getString("full_name");

                    // Create a session for the admin

                    session.setAttribute("adminId", adminId);
                    session.setAttribute("fullName", fullName);

                    // Redirect to admin dashboard
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    // Invalid credentials
                    System.out.println("<h3 style='color: red;'>Error: Invalid username or password.</h3>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println("<h3 style='color: red;'>Error: Unable to authenticate admin.</h3>");
            } finally {
                // Close database resources
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-form {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .login-form h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .login-form label {
            font-weight: bold;
        }
        .login-form .btn {
            width: 100%;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="login-form">
        <h2>Admin Login</h2>
        <form action="" method="post">
            <div class="mb-3">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Login</button>
        </form>
    </div>
</div>
</body>
</html>