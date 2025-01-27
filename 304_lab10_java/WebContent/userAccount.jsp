<!--%@ include file="auth.jsp" %-->
<!--I do not know why, but auth.jsp itself would cause duplicate local veriable problem-->
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery Main Page</title>
    <%@include file="components/menueStyle.jsp"%>
</head>
<body>
<%@ include file="components/header.jsp" %>
<h2 align="center">User account menu</h2>
<h3 align="center">
    <%
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null) {
            out.println("Signed in as: " + userName);
        }
    %>
</h3>
<ul align="center">
    <li><a href="userCreatAccount.jsp">Creat account</a></li>
    <li><a href="userOrder.jsp">List User Orders</a></li>
    <li><a href="userInf.jsp">Customer Info</a></li>
    <%
        if (userName==null || userName.equals("")) {
            out.println("<li><a href=\"userLogin.jsp\">Log In</a></li>");
        }else{
            out.println("<li><a href=\"userLogout.jsp\">Log Out</a></li>");
        }
    %>
</ul>
</body>
</html>