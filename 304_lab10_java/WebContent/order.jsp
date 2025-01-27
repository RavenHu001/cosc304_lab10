<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
    <%@include file="components/orderWarehouseTableStyle.jsp"%>
</head>
<body>
<%@ include file="components/header.jsp" %>
<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    //set connect inf
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    // get number format
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    //create connection in try()
    try(Connection conn = DriverManager.getConnection(url, uid, pw);
        Statement stmt = conn.createStatement();){
        //1.verify the customId is valid
        int cId = Integer.parseInt(custId);
        PreparedStatement pstmt1= conn.prepareStatement("SELECT customerId,firstName,lastName " +
                "FROM customer WHERE customerId = ?");
        pstmt1.setInt(1, cId);
        ResultSet rst1 = pstmt1.executeQuery();
        if (!rst1.next()) {
            out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
        }else{
            //2.check cart is empty
            if(productList==null||productList.isEmpty()){
                out.println("<h1>Your shopping cart is empty!</h1>");
            }else{
                // if valid, start insert
                String cName = rst1.getString("firstName")+" "+rst1.getString("lastName");

                // 3.Save order information to database
                String sqlInsert = "Insert into ordersummary(orderDate,customerId) values(?,?)";
                // get creat new order and get the orderId
                PreparedStatement pstmt2 = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
                Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                pstmt2.setTimestamp(1, currentTime);
                pstmt2.setInt(2, cId);
                pstmt2.executeUpdate();
                ResultSet keys = pstmt2.getGeneratedKeys();
                keys.next();
                int orderId = keys.getInt(1);

                // 4.go through the productlist
                double totalPrice = 0;
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();

                //displaying start
                out.println("<h1>Order summary checked!</h1>");
                out.println("<table>" +
                        "<tr>" +
                        "<th>Product Id</th>" +
                        "<th>Product Name</th>" +
                        "<th>Quantity</th>" +
                        "<th>Price</th>" +
                        "<th>Subtotal</th>" +
                        "</tr>");
                while (iterator.hasNext())
                {
                    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                    String productId = (String) product.get(0);
                    String price = (String) product.get(2);
                    double pr = Double.parseDouble(price);
                    int qty = ( (Integer)product.get(3)).intValue();
                    PreparedStatement pstmt3 = conn.prepareStatement("insert into orderproduct values(?,?,?,?)");
                    pstmt3.setInt(1, orderId);
                    pstmt3.setString(2, productId);
                    pstmt3.setDouble(3, pr);
                    pstmt3.setInt(4, qty);
                    pstmt3.executeUpdate();

                    double subtotal = pr*qty;
                    totalPrice += subtotal;

                    //displaying products
                    String fpr = currFormat.format(pr);
                    String fsubtotal = currFormat.format(subtotal);
                    String pName = (String) product.get(1);
                    out.println("<tr>" +
                            "<td>"+productId+"</td>" +
                            "<td>"+pName+"</td>" +
                            "<td>"+qty+"</td>" +
                            "<td>"+fpr+"</td>" +
                            "<td>"+fsubtotal+"</td>" +
                            "</tr>");
                }
                //5.update total amount in order summary
                PreparedStatement pstmt4 = conn.prepareStatement("UPDATE ordersummary " +
                        "SET totalAmount = ? where orderId = ?");
                pstmt4.setDouble(1, totalPrice);
                pstmt4.setInt(2, orderId);
                pstmt4.executeUpdate();

                //displaying end
                String ftotalPrice = currFormat.format(totalPrice);
                out.println("<tr>" +
                        "<th colspan=4>Total amount</th>" +
                        "<td>"+ftotalPrice+"</td>" +
                        "</tr>" +
                        "</table>");
                out.println("<table>" +
                        "<tr><th colspan = 2>Order shipped success...</ht></tr>" +
                        "<tr><th>Order number</th><td>"+orderId+"</td>" +
                        "<tr><th>Ship to customer</th><td>"+cName+"</td>" +
                        "<tr><th>Customer ID</th><td>"+cId+"</td>" +
                        "</table>");

                //6.clean productList
                productList = new HashMap<String, ArrayList<Object>>();
                session.setAttribute("productList", productList);
            }
        }
    }catch (SQLException ex) {
        out.println("SQLException: " + ex);
    }catch (NumberFormatException e){
        //this error only phappend for change cId into int
        out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
    }
%>
</BODY>
</HTML>

