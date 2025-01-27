<%@ page import="java.sql.*" %>
<%@ include file="../jdbc.jsp" %>
<%@ include file="../auth.jsp" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Update Ship To State</title>
    <%@include file="../components/listProdStyle.jsp"%>
</head>
<body>
<%@ include file="../components/header.jsp" %>
<h1>Update Ship To State</h1>

<form method="post">
    <label for="newState">New Ship To State:</label>
    <input type="text" id="newState" name="newState" required>
    <br><br>

    <input type="submit" value="Update">
</form>

<%
    // Check if form data is submitted
    String orderIdParam = request.getParameter("orderId");
    String newStateParam = request.getParameter("newState");

    if (orderIdParam != null && newStateParam != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url,uid,pw);

            // Update query
            String updateSQL = "UPDATE ordersummary SET shiptoState = ? WHERE orderId = ?";
            pstmt = conn.prepareStatement(updateSQL);

            // Set query parameters
            pstmt.setString(1, newStateParam);
            pstmt.setInt(2, Integer.parseInt(orderIdParam));

            // Execute update
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p><h3>Ship to state updated successfully!</h3></p>");
            } else {
                out.println("<p><h3>Error: Order ID not found.</h3></p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error updating the database: " + e.getMessage() + "</p>");
        } finally {
            // Close resources
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>

</body>
</html>
