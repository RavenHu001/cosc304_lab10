<!--%@ include file="auth.jsp" %-->
<!--I do not know why, but auth.jsp itself would cause duplicate local veriable problem-->
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery Main Page</title>
    <%@include file="components/menueStyle.jsp"%>
</head>
<body>
    <%@ include file="components/header.jsp"%>
    <h1 align="center">Welcome to Ray's Grocery</h1>
    <h2 align="center">Main Menu</h2>
    <h3 align="center">
        <% 
            String userName = (String) session.getAttribute("authenticatedUser");
            if (userName != null) {
                out.println("Signed in as: " + userName);
            }
        %>
    </h3>
    <ul align="center">
        <li><a href="userAccount.jsp">User Account Page</a></li>
        <li><a href="listprod.jsp">Begin Shopping</a></li>
        <li><a href="administrator/admin.jsp">Administrators</a></li>
        <li><a href="<%=request.getContextPath()%>/warehouse/warehouseProduct.jsp">Product In Each Warehouse</a></li>
        <%
            if (userName==null || userName.equals("")) {
                out.println("<li><a href=\"login.jsp\">Log In</a></li>");
            }else{
                out.println("<li><a href=\"logout.jsp\">Log Out</a></li>");
            }
        %>
    </ul>
</body>
</html>