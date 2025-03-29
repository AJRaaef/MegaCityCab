package org.cablink.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.cablink.megacitycab.model.User;
import org.cablink.megacitycab.service.UserService;

import java.io.IOException;

@WebServlet("/LoginController")
public class LoginController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Authenticate user
        User user = userService.authenticateUser(username, password);

        if (user != null) {
            // Create session and store user details
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Redirect based on role
            if ("customer".equals(user.getRole())) {
                response.sendRedirect("customer-dashboard.jsp");
            } else if ("driver".equals(user.getRole())) {
                response.sendRedirect("driver-dashboard.jsp");
            } else {
                response.sendRedirect("login.jsp?error=Invalid role");
            }
        } else {
            // Redirect back to login with an error message
            response.sendRedirect("login.jsp?error=Invalid username password");
        }
    }
}