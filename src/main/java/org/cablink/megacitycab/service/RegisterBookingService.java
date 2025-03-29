package org.cablink.megacitycab.service;

import org.cablink.megacitycab.dao.RegisterBookingDAO;
import org.cablink.megacitycab.model.RegisterBooking;

public class RegisterBookingService {
    private RegisterBookingDAO registerBookingDAO = new RegisterBookingDAO();

    public boolean processRegisterBooking(RegisterBooking registerBooking) {
        return registerBookingDAO.saveRegisterBooking(registerBooking);
    }
}
