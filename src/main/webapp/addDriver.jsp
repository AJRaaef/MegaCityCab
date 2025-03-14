<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Driver</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
            color: #333;
        }
        input, select {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .back-link {
            text-align: center;
            display: block;
            margin-top: 20px;
            color: #4CAF50;
            font-size: 14px;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .form-group {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Add New Driver</h2>

    <form action="addDriverServlet" method="post">
        <div class="form-group">
            <label for="driverName">Driver Name:</label>
            <input type="text" id="driverName" name="driverName" required>
        </div>

        <div class="form-group">
            <label for="licenseNumber">License Number:</label>
            <input type="text" id="licenseNumber" name="licenseNumber" required>
        </div>

        <div class="form-group">
            <label for="vehicleType">Vehicle Type:</label>
            <select id="vehicleType" name="vehicleType" required>
                <option value="Car">Car</option>
                <option value="Van">Van</option>
                <option value="Truck">Truck</option>
            </select>
        </div>

        <div class="form-group">
            <label for="contactNumber">Contact Number:</label>
            <input type="text" id="contactNumber" name="contactNumber" required>
        </div>

        <input type="submit" value="Add Driver">
    </form>

    <a href="driverList.jsp" class="back-link">Back to Driver List</a>
</div>

</body>
</html>
