package org.cablink.megacitycab.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.cablink.megacitycab.model.Vehicle;
import org.cablink.megacitycab.service.VehicleService;

import java.io.IOException;
import java.util.List;

@WebServlet("/CustomerDashboardController")
public class CustomerDashboardController extends HttpServlet {
    private VehicleService vehicleService;

    @Override
    public void init() throws ServletException {
        vehicleService = new VehicleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("No session or userId found, redirecting to login");
            response.sendRedirect("login.jsp?error=Please login first");
            return;
        }

        System.out.println("Session found, userId: " + session.getAttribute("userId"));

        // Get all vehicles
        List<Vehicle> vehicles = vehicleService.getAllVehicles();
        System.out.println("Vehicles fetched: " + vehicles.size());

        // Set vehicles as a request attribute
        request.setAttribute("vehicles", vehicles);

        // Forward to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("customer-dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
