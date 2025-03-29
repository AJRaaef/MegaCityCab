package org.cablink.megacitycab.service;

import org.cablink.megacitycab.dao.VehicleDAO;
import org.cablink.megacitycab.model.Vehicle;
import java.util.List;

public class VehicleService {
    private VehicleDAO vehicleDAO = new VehicleDAO();

    // Get all vehicles (no filters)
    public List<Vehicle> getAllVehicles() {
        return vehicleDAO.getAllVehicles();
    }


}