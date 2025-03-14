package org.cablink.megacitycab.controller;



import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.cablink.megacitycab.model.Vehicle;
import org.cablink.megacitycab.util.DBConnection;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/listVehicles")
public class ListVehiclesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sessionObj = request.getSession(false);
        if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
            response.sendRedirect("adminLogin.jsp?error=Please login first");
            return;
        }

        List<Vehicle> vehicleList = new ArrayList<>();
        String errorMessage = "";

        try {
            Connection conn = DBConnection.getConnection();
            if (conn == null) {
                errorMessage = "Error: Unable to connect to the database.";
            } else {
                String vehicleQuery = "SELECT * FROM vehicles";
                PreparedStatement ps = conn.prepareStatement(vehicleQuery);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Vehicle vehicle = new Vehicle();
                    vehicle.setId(rs.getInt("id"));
                    vehicle.setName(rs.getString("vehicle_name"));
                    vehicle.setModel(rs.getString("model"));
                    vehicle.setCapacity(rs.getInt("capacity"));
                    vehicle.setPricePerDay(rs.getDouble("price_per_day"));
                    vehicle.setVehicleType(rs.getString("vehicle_type"));
                    vehicle.setDriverId(rs.getInt("driver_id"));
                    vehicle.setPhoto1(rs.getString("photo1"));
                    vehicle.setPhoto2(rs.getString("photo2"));
                    vehicle.setPhoto3(rs.getString("photo3"));
                    vehicleList.add(vehicle);
                }
            }
        } catch (SQLException e) {
            errorMessage = "Error: Unable to fetch vehicles.";
            e.printStackTrace();
        }

        request.setAttribute("vehicleList", vehicleList);
        if (!errorMessage.isEmpty()) {
            request.setAttribute("errorMessage", errorMessage);
        }
        request.getRequestDispatcher("listVehicles.jsp").forward(request, response);
    }
}
