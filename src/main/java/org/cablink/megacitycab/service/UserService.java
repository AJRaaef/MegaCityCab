package org.cablink.megacitycab.service;

import org.cablink.megacitycab.dao.UserDAO;
import org.cablink.megacitycab.model.User;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    // Authenticate user and return their details
    public User authenticateUser(String username, String password) {
        return userDAO.authenticateUser(username, password);
    }
}