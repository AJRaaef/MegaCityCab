package org.cablink.megacitycab.util;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/megacitycab";
    private static final String DB_USERNAME = "root";  // Change if needed
    private static final String DB_PASSWORD = "";  // Change if needed

    public static Connection getConnection() throws SQLException {
        try {
            // ✅ Ensure MySQL JDBC 9.0 is loaded
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("❌ JDBC Driver not found. Ensure MySQL Connector 9.0 JAR is added!", e);
        }
    }

    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("✅ Database Connected Successfully!");
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
