<%@ page import="java.sql.*, java.text.NumberFormat" %>
<%@ include file="../auth.jsp" %>
<%@ include file="../jdbc.jsp" %>
<!--%@ include file="auth.jsp" %-->
<!--I do not know why, but auth.jsp itself would cause duplicate local veriable problem-->
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <%@include file="../components/menueStyle.jsp"%>
</head>
<body>
<%@ include file="../components/header.jsp" %>
<h1>Administrator Menue</h1>
<h3 align="center">
    <%
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null) {
            out.println("Signed in as: " + userName);
        }
    %>
</h3>
<ul align="center">
    <li><a href="totalSales.jsp">List Total Sales</a></li>
    <li><a href="listorder.jsp">List All Orders</a></li>
    <li><a href="listCustomer.jsp">List All Customer</a></li>
    <li><a href="<%=request.getContextPath()%>/index.jsp">Leave Administrator</a></li>
    <li><a href="dbFrash.jsp">Refresh the Data Base</a></li>
</ul>
</body>
</html>