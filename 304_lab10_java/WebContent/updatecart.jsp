<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
    if (productList != null) {
        for (String productId : productList.keySet()) {
            String quantityPara = request.getParameter("quantity_" + productId);
            if (quantityPara != null) {
                try {
                    int newQuantity = Integer.parseInt(quantityPara);
                    if (newQuantity > 0) {
                        ArrayList<Object> product = productList.get(productId);
                        product.set(3, newQuantity); // Update the quantity
                    } else {
                        productList.remove(productId);
                    }
                } catch (NumberFormatException e) {
                    //ignore invalid input
                }
            }
        }
        session.setAttribute("productList", productList);
    }
    response.sendRedirect("showcart.jsp");
%>
