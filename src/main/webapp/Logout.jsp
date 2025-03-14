<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
  // Invalidate the session to log out the user

  if (session != null) {
    session.invalidate(); // Destroy the session
  }

  // Redirect to the login page with a logout message
  response.sendRedirect("login.jsp?message=You have been logged out successfully.");
%>