<%@ page import="java.io.*, java.sql.*, java.util.*,org.cablink.megacitycab.controller.AddDriverController, jakarta.servlet.ServletException, jakarta.servlet.annotation.MultipartConfig, jakarta.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Enable file upload --%>
<%@ page isErrorPage="true" %>
<%@ page import="java.nio.file.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Driver</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            width: 40%;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        form {
            display: grid;
            grid-template-columns: 1fr;
            gap: 15px;
        }
        label {
            font-weight: bold;
            display: block;
        }
        input[type="text"],
        input[type="password"],
        input[type="email"],
        input[type="file"],
        button {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        button:hover {
            background-color: #45a049;
        }
        .message {
            text-align: center;
            font-size: 16px;
            margin-top: 10px;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add Driver</h2>

    <!-- HTML Form -->
    <form action="AddDriverController" method="post" enctype="multipart/form-data">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required>

        <label for="full_name">Full Name:</label>
        <input type="text" name="full_name" id="full_name" required>

        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required>

        <label for="phone_number">Phone Number:</label>
        <input type="text" name="phone_number" id="phone_number" required>

        <label for="nic">NIC:</label>
        <input type="text" name="nic" id="nic" required>

        <label for="license_number">License Number:</label>
        <input type="text" name="license_number" id="license_number" required>

        <label for="profile_picture">Profile Picture:</label>
        <input type="file" name="profile_picture" id="profile_picture" accept="image/*" required>

        <button type="submit">Add Driver</button>
    </form>

    <%-- Display error or success message --%>
    <div class="message">
        <% if (request.getAttribute("errorMessage") != null) { %>
        <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
        <p class="success"><%= request.getAttribute("successMessage") %></p>
        <% } %>
    </div>
</div>

</body>
</html>
