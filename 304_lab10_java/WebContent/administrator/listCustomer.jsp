<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="../jdbc.jsp" %>
<%@ include file="../auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery</title>
    <%@include file="../components/listProdStyle.jsp"%>
</head>
<body>
<%@ include file="../components/header.jsp" %>
<%

    String sql = "SELECT * FROM customer";
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(sql)) {
        try (ResultSet rs = ps.executeQuery()) {
            out.println("<table>");
            out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Phone Number</th>" +
                    "<th>Address</th><th>City</th><th>State</th><th>PostalCode</th><th>Country</th><th>UserId</th></tr>");
            while (rs.next()) {
                int customerId = rs.getInt("customerId");
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
                String email = rs.getString("email");
                String phonenum = rs.getString("phonenum");
                String address = rs.getString("address");
                String city = rs.getString("city");
                String state = rs.getString("state");
                String postalCode = rs.getString("postalCode");
                String country = rs.getString("country");
                String userid = rs.getString("userid");

                out.println("<tr><td>"+customerId+"</td>" +
                        "<td>"+firstName+" "+lastName+"</td>" +
                        "<td>"+email+"</td>" +
                        "<td>"+phonenum+"</td>" +
                        "<td>"+address+"</td>" +
                        "<td>"+city+"</td>" +
                        "<td>"+state+"</td>" +
                        "<td>"+postalCode+"</td>" +
                        "<td>"+country+"</td>" +
                        "<td>"+userid+"</td></tr>");
            }
            out.println("</table>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>