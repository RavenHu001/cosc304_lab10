<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    @SuppressWarnings("unchecked")
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
    if (productList != null) {
        String productId = request.getParameter("id");
        if (productId != null && productList.containsKey(productId)) {
            productList.remove(productId);
        }
        session.setAttribute("productList", productList);
        response.sendRedirect("showcart.jsp");
    }
%>
