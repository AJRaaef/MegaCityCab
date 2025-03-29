package org.cablink.megacitycab.controller;

import org.cablink.megacitycab.model.RegisterBooking;
import org.cablink.megacitycab.service.RegisterBookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/RegisterBookingController")
public class RegisterBookingController extends HttpServlet {
    private RegisterBookingService registerBookingService = new RegisterBookingService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Retrieve the vehicleId from the URL (query string)
            String vehicleIdStr = request.getParameter("vehicleId");
            if (vehicleIdStr == null || vehicleIdStr.isEmpty()) {
                response.sendRedirect("bookVehicle.jsp?error=Vehicle ID is missing.");
                return;
            }
            int registerVehicleId = Integer.parseInt(vehicleIdStr);

            // Continue with the rest of the parameters as usual
            int registerCustomerId = Integer.parseInt(request.getSession().getAttribute("userId").toString());
            String registerStartPlace = request.getParameter("registerbookingStartPlace");
            String registerDestination = request.getParameter("registerbookingDestination");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date registerStartDate = sdf.parse(request.getParameter("registerbookingStartDate"));
            Date registerEndDate = sdf.parse(request.getParameter("registerbookingEndDate"));

            int registerTotalDays = (int) ((registerEndDate.getTime() - registerStartDate.getTime()) / (1000 * 60 * 60 * 24));
            double registerPricePerDay = Double.parseDouble(request.getParameter("registerbookingPricePerDay"));
            double registerTotalAmount = registerTotalDays * registerPricePerDay;

            RegisterBooking registerBooking = new RegisterBooking();
            registerBooking.setRegisterCustomerId(registerCustomerId);
            registerBooking.setRegisterVehicleId(registerVehicleId); // Set the vehicle ID
            registerBooking.setRegisterStartPlace(registerStartPlace);
            registerBooking.setRegisterDestination(registerDestination);
            registerBooking.setRegisterStartDate(registerStartDate);
            registerBooking.setRegisterEndDate(registerEndDate);
            registerBooking.setRegisterTotalDays(registerTotalDays);
            registerBooking.setRegisterTotalAmount(registerTotalAmount);
            registerBooking.setRegisterStatus("Pending");

            boolean isRegistered = registerBookingService.processRegisterBooking(registerBooking);

            if (isRegistered) {
                response.sendRedirect("bookingSuccess.jsp");
            } else {
                response.sendRedirect("bookVehicle.jsp?error=Booking failed, try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("bookVehicle.jsp?error=Invalid data.");
        }
    }
}


