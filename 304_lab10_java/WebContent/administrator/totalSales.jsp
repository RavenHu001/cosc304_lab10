<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="../auth.jsp" %>
<%@ include file="../jdbc.jsp" %>
<!--%@ include file="auth.jsp" %-->
<!--I do not know why, but auth.jsp itself would cause duplicate local veriable problem-->
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
<%@include file="../components/listProdStyle.jsp"%>
</head>
<body>
<%@ include file="../components/header.jsp" %>
    <h1>Administrator Sales Report by Day</h1>
    <%
        //SQL query to calculate total order amount by day
        String sql = "SELECT CONVERT(VARCHAR, orderDate, 23) AS OrderDate, SUM(totalAmount) AS TotalOrderAmount " +
                     "FROM ordersummary " +
                     "GROUP BY CONVERT(VARCHAR, orderDate, 23) " +
                     "ORDER BY OrderDate";
        try (Connection con = DriverManager.getConnection(url, uid, pw);
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            out.println("<table>");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");
            while (rs.next()) {
                String orderDate = rs.getString("OrderDate");
                double totalAmount = rs.getDouble("TotalOrderAmount");
                String formattedTotal = NumberFormat.getCurrencyInstance().format(totalAmount);
                out.println("<tr>");
                out.println("<td>" + orderDate + "</td>");
                out.println("<td>" + formattedTotal + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
</body>
</html>