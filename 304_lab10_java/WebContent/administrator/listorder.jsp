<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="../jdbc.jsp" %>
<%@ include file="../auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
<%@include file="../components/listProdStyle.jsp"%>
</head>
<body>
<%@ include file="../components/header.jsp" %>
<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
	// get number format
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	// data format
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	try
	{
		// Make connection
		Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();
		// write statements
		PreparedStatement pstmt = con.prepareStatement("SELECT productId,quantity,price " +
				"from orderproduct where orderId = ?");
		ResultSet rst1 = stmt.executeQuery("SELECT orderId,orderDate,o.customerId,firstName,lastName,totalAmount " +
				"FROM ordersummary o join customer c on o.customerId=c.customerId");
		out.println("<table>" );
		// print the order information
		while (rst1.next()){
			//format the totalAmount
			String formatedAmount = currFormat.format(rst1.getDouble(6));
			//format date
			String date = sdf.format(rst1.getTimestamp(2));
			out.println(
					"<tr>" +
							"<th>Order Id</th>" +
							"<th>Order Date</th>" +
							"<th>Customer Id</th>" +
							"<th>Customer Name</th>" +
							"<th>Total Amount</th>" +
					"</tr>"+
					"<tr>"+
							"<td>"+rst1.getInt(1)+"</td>"+
							"<td>"+date+"</td>"+
							"<td>"+rst1.getInt(3)+"</td>"+
							"<td>"+rst1.getString(4)+" "+rst1.getString(5)+"</td>"+
							"<td>"+formatedAmount+"</td>"+
					"</tr>"
			);
			//print products in each orders
			pstmt.setInt(1, rst1.getInt(1));
			ResultSet rst2 = pstmt.executeQuery();
			out.println(
					"<td colspan = 4><table>"+
							"<tr>"+
							"<th>Product Id</th>"+
							"<th>Quantity</th>"+
							"<th>Price</th>"
			);
			while (rst2.next()){
				String formatedPrice = currFormat.format(rst2.getDouble(3));
				out.println(
						"<tr>"+
								"<td>"+rst2.getInt(1)+"</td>"+
								"<td>"+rst2.getInt(2)+"</td>"+
								"<td>"+formatedPrice+"</td>"+
								"</tr>"
				);
			}
			//close product table
			out.println("</table></td>" +
					"<td><h3><a href='updateOrderStatus.jsp?orderId=" + rst1.getInt(1) + "'>Modify</a></h></td></tr>");
		}
		//close order table
		out.println("</table>");
		//closs connection
		stmt.close();
		con.close();
	} catch (SQLException ex) {
		out.println("SQLException: " + ex);
	}
%>

</body>
</html>

