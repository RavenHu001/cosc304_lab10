<%@ page import="java.sql.*" %>
<%@ include file="userAuth.jsp" %> <!--This check if user is logged in-->
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Profile</title>
<%@include file="components/orderWarehouseTableStyle.jsp"%>
</head>
<body>
<%@ include file="components/header.jsp" %>
<h1>Customer Profile</h1>
<%
    String userId = (String) session.getAttribute("authenticatedUser");
    if (userId == null) {
        out.println("<p>You must be logged in to access this page.</p>");
    } else {
        String sql = "SELECT * FROM customer WHERE userid = ?";
        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    out.println("<table>");
                    out.println("<tr><th>Id</th><td>" + rs.getInt("customerId") + "</td></tr>");
                    out.println("<tr><th>First Name</th><td>" + rs.getString("firstName") + "</td></tr>");
                    out.println("<tr><th>Last Name</th><td>" + rs.getString("lastName") + "</td></tr>");
                    out.println("<tr><th>Email</th><td>" + rs.getString("email") + "</td></tr>");
                    out.println("<tr><th>Phone</th><td>" + rs.getString("phonenum") + "</td></tr>");
                    out.println("<tr><th>Address</th><td>" + rs.getString("address") + "</td></tr>");
                    out.println("<tr><th>City</th><td>" + rs.getString("city") + "</td></tr>");
                    out.println("<tr><th>Province</th><td>" + rs.getString("state") + "</td></tr>");
                    out.println("<tr><th>Postal Code</th><td>" + rs.getString("postalCode") + "</td></tr>");
                    out.println("<tr><th>Country</th><td>" + rs.getString("country") + "</td></tr>");
                    out.println("<tr><th>User id</th><td>" + rs.getString("userId") + "</td></tr>");
                    out.println("</table>");
                } else {
                    out.println("<p>No customer information found for the logged-in user.</p>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error retrieving customer information: " + e.getMessage() + "</p>");
        }
        out.println("<h3><a href = 'userUpdateE_P.jsp'>Update password and email</a></h3>");
    }
%>
</body>
</html>