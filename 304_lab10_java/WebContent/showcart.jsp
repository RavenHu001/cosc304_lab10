<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
	<%@include file="components/listProdStyle.jsp"%>
</head>
<body>
<%@ include file="components/header.jsp" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<form action='updatecart.jsp' method='post'>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th><th>Actions</th></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = entry.getValue();
            String productId = (String) product.get(0);
            String productName = (String) product.get(1);
            double price = Double.parseDouble(product.get(2).toString());
            int quantity = Integer.parseInt(product.get(3).toString());
			String URL = "removecart.jsp?id="+productId;//no need to be full url, just jump to target file
			out.print("<tr>");
				out.print("<td>" + productId + "</td>");
				out.print("<td>" + productName + "</td>");
				out.print("<td>");
				out.print("<input type='number' name='quantity_" + productId + "' value='" + quantity + "' min='1' />");
				out.print("</td>");
				out.print("<td align='right'>" + currFormat.format(price) + "</td>");
				out.print("<td align='right'>" + currFormat.format(price * quantity) + "</td>");
				out.print("<td>");
				out.print("<a href=" + URL + ">Remove</a>");
				out.print("</td>");
				out.print("</tr>");
				total += price * quantity;
			}
			out.println("<tr><td colspan='4' align='right'><b>Order Total</b></td><td align='right'>" + currFormat.format(total) + "</td><td></td></tr>");
			out.print("</table>");
			out.print("<input type='submit' value='Update Cart' />");
			out.print("</form>");
			out.println("<h3><a href='checkout.jsp'>Check Out</a></h3>");
		}
%>
<h3><a href="listprod.jsp">Continue Shopping</a></h3>
</body>
</html> 

