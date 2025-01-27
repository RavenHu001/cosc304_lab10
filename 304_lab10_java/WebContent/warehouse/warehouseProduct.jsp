<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Objects" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="../jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Warehouse Product Inventory</title>
    <%@include file="../components/orderWarehouseTableStyle.jsp"%>
</head>
<body>
<%@ include file="../components/header.jsp" %>
<h1>Warehouse Product Inventory</h1>
<table>
    <tbody>
        <%
                // SQL 查询
                String query = "SELECT w.warehouseId, w.warehouseName, " +
                               "p.productId, p.productName, p.productPrice, " +
                               "pi.quantity " +
                               "FROM warehouse w " +
                               "LEFT JOIN productinventory pi ON w.warehouseId = pi.warehouseId " +
                               "LEFT JOIN product p ON pi.productId = p.productId " +
                               "ORDER BY w.warehouseId, p.productId";

                try (Connection conn = DriverManager.getConnection(url,uid,pw);
                     PreparedStatement pstmt = conn.prepareStatement(query);
                     ResultSet rs = pstmt.executeQuery()) {

                    int currentWarehouseId = -1;

                    while (rs.next()) {
                        int warehouseId = rs.getInt("warehouseId");
                        String warehouseName = rs.getString("warehouseName");
                        int productId = rs.getInt("productId");
                        String productName = rs.getString("productName");
                        double productPrice = rs.getDouble("productPrice");
                        int quantity = rs.getInt("quantity");

                        // 如果当前仓库 ID 变化，则输出新仓库信息
                        if (warehouseId != currentWarehouseId) {
                            // 关闭上一个仓库的表格
                            if (currentWarehouseId != -1) {
                                    %>
                                </table>
                                </td></tr>
                                <%
    }
    currentWarehouseId = warehouseId;
%>
<tr class="warehouse-row">
    <td >Warehouse ID: <%= warehouseId %> | <%= warehouseName %></td>
</tr>
<tr>
    <td colspan="6">
        <table class="product-table">
            <thead>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Product Price</th>
                <th>Quantity</th>
            </tr>
            </thead>
            <tbody>
            <%
                }

                // 如果产品信息存在，则输出产品行
                if (productId > 0) {
            %>
            <tr>
                <td><%= productId %></td>
                <td><%= productName %></td>
                <td><%= productPrice %></td>
                <td><%= quantity %></td>
            </tr>
            <%
                    }
                }

                // 关闭最后一个仓库的表格
                if (currentWarehouseId != -1) {
            %>
            </tbody>
        </table>
    </td>
</tr>
<%
        }
    } catch (SQLException e) {
        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
</tbody>
</table>
</body>
</html>
