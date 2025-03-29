<%@ page import="java.sql.*, org.cablink.megacitycab.util.DBConnection" %>
<%
    String vehicleIdStr = request.getParameter("vehicleId");
    if (vehicleIdStr != null) {
        int vehicleId = Integer.parseInt(vehicleIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            // Prepare the SQL DELETE query
            String deleteQuery = "DELETE FROM vehicles WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteQuery)) {
                stmt.setInt(1, vehicleId);
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Redirect to the listVehicles.jsp after successful deletion
                    response.sendRedirect("listVehicles.jsp?message=Vehicle%20Deleted%20Successfully");
                } else {
                    response.sendRedirect("listVehicles.jsp?message=Error%20Deleting%20Vehicle");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("listVehicles.jsp?message=Error%20Deleting%20Vehicle");
        }
    } else {
        response.sendRedirect("listVehicles.jsp?message=Invalid%20Vehicle%20ID");
    }
%>
