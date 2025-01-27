<%@ page language="java" import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Use variables directly without re-declaring them
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // SQL query to validate user credentials
    String sql = "SELECT customerId,userId FROM customer WHERE userId = ? AND password = ?";
    try {
        getConnection(); // Use the method from jdbc.jsp
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    session.setAttribute("authenticatedUser", username);
                    response.sendRedirect("index.jsp");
                } else {
                    session.setAttribute("loginMessage", "Invalid username or password.");
                    response.sendRedirect("login.jsp");
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        closeConnection(); // Close connection
    }
%>