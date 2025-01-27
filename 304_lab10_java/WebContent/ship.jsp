<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<html>
<head>
<title>Ray's Grocery Shipment Processing</title>
</head>
<body>
<%@ include file="header.jsp" %>
<%
    String orderId = request.getParameter("orderId"); 
    boolean shipmentSuccessful = true;
    String errorMessage = "";
    String output = "";
    if (orderId == null || orderId.isEmpty()) {
        out.println("<p>Invalid order ID. Please go back and try again.</p>");
    } else {
        Connection con = null;
        try {
            //Establish connection
            con = DriverManager.getConnection(url, uid, pw);
            con.setAutoCommit(false); //Turn off auto-commit to manage transactions
            //Validate ID
            String validateOrderSql = "SELECT COUNT(*) AS count FROM ordersummary WHERE orderId = ?";
            try (PreparedStatement validateStmt = con.prepareStatement(validateOrderSql)) {
                validateStmt.setInt(1, Integer.parseInt(orderId));
                try (ResultSet rs = validateStmt.executeQuery()) {
                    if (rs.next() && rs.getInt("count") == 0) {
                        out.println("<p>Order ID does not exist. Please try again.</p>");
                        return;
                    }
                }
            }
            //Retrieve order items
            String itemsSql = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
            String insertShipmentSql = "INSERT INTO shipment (shipmentDate,warehouseId) VALUES (GETDATE(),1)";
            String checkInventorySql = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
            String updateInventorySql = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
            try (
                PreparedStatement itemsStmt = con.prepareStatement(itemsSql);
                PreparedStatement insertShipmentStmt = con.prepareStatement(insertShipmentSql);//, Statement.RETURN_GENERATED_KEYS);
                PreparedStatement checkInventoryStmt = con.prepareStatement(checkInventorySql);
                PreparedStatement updateInventoryStmt = con.prepareStatement(updateInventorySql)
            ) {
                itemsStmt.setInt(1, Integer.parseInt(orderId));
                try (ResultSet rs = itemsStmt.executeQuery()) {
                    boolean hasInsufficientInventory = false;
                    //Insert shipment record
                    //insertShipmentStmt.setInt(1, Integer.parseInt(orderId));
                    insertShipmentStmt.executeUpdate();
                    int shipmentId = insertShipmentStmt.RETURN_GENERATED_KEYS;
                    //Process each order item
                    while (rs.next()) {
                        int productId = rs.getInt("productId");
                        int orderedQty = rs.getInt("quantity");
                        //Check inventory
                        checkInventoryStmt.setInt(1, productId);
                        try (ResultSet inventoryRs = checkInventoryStmt.executeQuery()) {
                            if (inventoryRs.next()) {
                                int currentQty = inventoryRs.getInt("quantity");
                                if (currentQty < orderedQty) {
                                    shipmentSuccessful = false;
                                    hasInsufficientInventory = true;
                                    errorMessage = "Insufficient inventory for product id: " + productId;
                                    break;
                                } else {
                                    //Update inventory
                                    updateInventoryStmt.setInt(1, orderedQty);
                                    updateInventoryStmt.setInt(2, productId);
                                    updateInventoryStmt.executeUpdate();
                                    output += "Ordered product: " + productId +
                                              " Qty: " + orderedQty +
                                              " Previous inventory: " + currentQty +
                                              " New inventory: " + (currentQty - orderedQty) + "<br>";
                                }
                            }
                        }
                    }
                    if (hasInsufficientInventory) {
                        con.rollback(); //Rollback transaction
                    } else {
                        con.commit(); //Commit transaction
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            shipmentSuccessful = false;
            errorMessage = "An error occurred during shipment processing.";
            if (con != null) con.rollback(); //Ensure rollback on error
        } finally {
            if (con != null) con.setAutoCommit(true); //Turn auto-commit back on
        }
        //Display results
        out.println("<h1>Ray's Grocery</h1>");
        out.println("<h2>Screenshot - " + (shipmentSuccessful ? "Successful" : "Unsuccessful") + " Shipment with orderId=" + orderId + "</h2>");
        out.println(output);
        if (shipmentSuccessful) {
            out.println("<h3><p>Shipment successfully processed.</p></h>");
        } else {
            out.println("<h3><p>Shipment not done. " + errorMessage + "</p></h>");
        }
    }
%>
<h2><a href="shop.html">Back to Main Page</a></h2>
</body>
</html>