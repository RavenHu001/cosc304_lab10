<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery</title>
    <%@include file="components/listProdStyle.jsp"%>
</head>
<body>
<%@ include file="components/header.jsp" %>
<%
    try{
        Object userName = session.getAttribute("authenticatedUser");
        if (userName != null&&!"".equals(userName)) {
            out.println("<h3>Logged user: "+ userName +"</h3>");
        }else {
            out.println("<h3>No logged user</h3>");
        }
    }catch (Exception e){
        out.println("<h3>No logged user</h3>");
    }

%>
<h1>Search for the products you want to buy:</h1>
<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50">
    <input type="submit" value="Submit">
    <input type="reset" value="Reset"> (Leave blank for all products)
    <!-- Dynamic list menu -->
    <select name="category">
        <option value="">All Categories</option>
        <%
            //Define database connection parameters
            // get categories
            String categoryQuery = "SELECT DISTINCT * FROM category";
            try (Connection conn = DriverManager.getConnection(url, uid, pw);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(categoryQuery)) {

                while (rs.next()) {
                    String categoryId = rs.getString("categoryId");
                    String categoryName = rs.getString("categoryName");

        %>
        <option value="<%= categoryId %>"><%= categoryName %></option>
        <%
                }
            } catch (SQLException e) {
                out.println("Error loading categories: " + e.getMessage());
            }
        %>
    </select>
</form>
<%
    String productName = request.getParameter("productName");
    //store categoryId
    String selectedCategory = request.getParameter("category");

    if (productName == null) productName = "";
    String sql = "SELECT productId, productName, productPrice, productImageURL FROM Product WHERE productName LIKE ?";
    //if selected a category
    if (selectedCategory != ""&& selectedCategory!=null) sql+= " AND categoryId = ?";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, "%" + productName + "%");
        //if selected a category
        if (selectedCategory != ""&& selectedCategory!=null) ps.setString(2, selectedCategory);
        try (ResultSet rs = ps.executeQuery()) {
            out.println("<table>");
            out.println("<tr><th>Product Name</th><th>Price</th><th>Action</th></tr>");
            while (rs.next()) {
                int productId = rs.getInt("productId");
                String name = rs.getString("productName");
                double price = rs.getDouble("productPrice");
                String imageUrl = rs.getString("productImageURL");
                out.println("<tr>");
                out.println("<td><a href='" + request.getContextPath() + "/productDetile.jsp?id=" + productId + "'>" + name + "</a></td>");
                out.println("<td>" + NumberFormat.getCurrencyInstance().format(price) + "</td>");
                out.println("<td><a href='" + request.getContextPath() + "/addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(name, "UTF-8") + "&price=" + price + "'>Add to Cart</a></td>");
                out.println("</tr>");
                if (imageUrl != null && !imageUrl.equals("")) {
                    out.println("<tr><td colspan = '3'>" +
                            "<a href='" + request.getContextPath() + "/productDetile.jsp?id=" + productId + "'>" +
                            "<img src='" + imageUrl + "' alt='" + name + "' style='max-width:300px; max-high:200px;'>" +
                            "</a></td></tr>");
                }
            }
            out.println("</table>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>
