<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    .login-container {
      background-color: #ffffff;
      padding: 2rem;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 400px;
    }
    .login-container h2 {
      margin-bottom: 1.5rem;
      text-align: center;
    }
    .form-group {
      margin-bottom: 1rem;
    }
    .form-group label {
      font-weight: 500;
    }
    .btn-primary {
      width: 100%;
      padding: 0.5rem;
      font-size: 1rem;
    }
    .alert {
      margin-top: 1rem;
    }
    .register-link {
      text-align: center;
      margin-top: 1rem;
    }
  </style>
</head>
<body>
<div class="login-container">
  <h2>Login</h2>

  <!-- Display error message if any -->
  <% if (request.getParameter("error") != null) { %>
  <div class="alert alert-danger">
    <%= request.getParameter("error") %>
  </div>
  <% } %>

  <!-- Login Form -->
  <form action="LoginController" method="POST">
    <div class="form-group">
      <label for="username">Username:</label>
      <input type="text" id="username" name="username" class="form-control" required>
    </div>
    <div class="form-group">
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-primary">Login</button>
  </form>

  <!-- Register Link -->
  <div class="register-link">
    <p>Don't have an account? <a href="Customerregister.jsp">Register here</a>.</p>
  </div>
</div>
</body>
</html>