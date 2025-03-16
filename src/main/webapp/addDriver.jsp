<%@ page import="java.io.*, java.sql.*, java.util.*,org.cablink.megacitycab.controller.AddDriverController, jakarta.servlet.ServletException, jakarta.servlet.annotation.MultipartConfig, jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Enable file upload --%>
<%@ page isErrorPage="true" %>
<%@ page import="java.nio.file.*" %>


<!-- HTML Form -->
<form action="AddDriverController" method="post" enctype="multipart/form-data">
    <label>Username:</label>
    <input type="text" name="username" required><br>

    <label>Password:</label>
    <input type="password" name="password" required><br>

    <label>Full Name:</label>
    <input type="text" name="full_name" required><br>

    <label>Email:</label>
    <input type="email" name="email" required><br>

    <label>Phone Number:</label>
    <input type="text" name="phone_number" required><br>

    <label>NIC:</label>
    <input type="text" name="nic" required><br>

    <label>License Number:</label>
    <input type="text" name="license_number" required><br>

    <label>Profile Picture:</label>
    <input type="file" name="profile_picture" accept="image/*" required><br>

    <button type="submit">Add Driver</button>
</form>

<%-- Display error or success message --%>
<% if (request.getAttribute("errorMessage") != null) { %>
<p style="color:red;"><%= request.getAttribute("errorMessage") %></p>
<% } %>

<% if (request.getAttribute("successMessage") != null) { %>
<p style="color:green;"><%= request.getAttribute("successMessage") %></p>
<% } %>
