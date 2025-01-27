<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // 获取产品 ID（假设通过 GET 参数传递）
    String productId = request.getParameter("id");
    if (productId == null) {
        out.println("Invalid product ID.");
        return;
    }

    // 查询产品详情和 Reviews
    String productName = "";
    String productDesc = "";
    double productPrice = 0.0;
    String productImageURL="";
    List<Map<String, Object>> reviews = new ArrayList<>();

    try (Connection conn = DriverManager.getConnection(url,uid,pw)) {
        // 查询产品详情
        String productQuery = "SELECT productName, productDesc, productPrice,productImageURL FROM product WHERE productId = ?";
        try (PreparedStatement ps = conn.prepareStatement(productQuery)) {
            ps.setInt(1, Integer.parseInt(productId));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    productName = rs.getString("productName");
                    productDesc = rs.getString("productDesc");
                    productPrice = rs.getDouble("productPrice");
                    productImageURL = rs.getString("productImageURL");
                } else {
                    out.println("Product not found.");
                    return;
                }
            }
        }

        // 查询产品 Reviews
        String reviewQuery = "SELECT c.userid, r.reviewComment, r.reviewRating, r.reviewDate "
                + "FROM review r "
                + "JOIN customer c ON r.customerId = c.customerId "
                + "WHERE r.productId = ? ORDER BY r.reviewDate DESC";
        try (PreparedStatement ps = conn.prepareStatement(reviewQuery)) {
            ps.setInt(1, Integer.parseInt(productId));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("userid", rs.getString("userid"));
                    review.put("reviewComment", rs.getString("reviewComment"));
                    review.put("reviewRating", rs.getInt("reviewRating"));
                    review.put("reviewDate", rs.getTimestamp("reviewDate"));
                    reviews.add(review);
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println(e);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= productName %></title>
    <%@include file="components/productDetileStyle.jsp"%>
</head>
<body>
<%@ include file="components/header.jsp" %>
<div class="product-details">
    <h1><%= productName %></h1>
    <p><img src="<%=productImageURL%>" alt="<%=productName%>" style=max-width:300px;>
        <img src="displayImage.jsp?id=<%=productId%>" alt="Binary Image" style=max-width:300px;>
    <p><%= productDesc %></p>
    <p><strong>Price:</strong> $<%= productPrice %></p>
</div>

<div class="reviews">
    <h2>Reviews</h2>
    <% if (reviews.isEmpty()) { %>
    <p>No reviews yet. Be the first to review!</p>
    <% } else { %>
    <% for (Map<String, Object> review : reviews) { %>
    <div class="review">
        <p><strong><%= review.get("userid") %></strong> - <%= review.get("reviewDate") %></p>
        <p class="review-rating">Rating: <%= review.get("reviewRating") %>/5</p>
        <p><%= review.get("reviewComment") %></p>
    </div>
    <% } %>
    <% } %>
</div>

<!-- 添加新评论 -->
<div class="add-review">
    <h2>Add a Review</h2>
    <form method="post" action="productAddReview.jsp">
        <%--@declare id="rating"--%>
        <input type="hidden" name="productId" value="<%= productId %>">

        <label for="customerId">Your Customer ID:</label>
        <input type="text" id="customerId" name="customerId" required>

        <label for="rating">Rating:</label>
        <div class="rating-stars">
            <% for (int i = 5; i >= 1; i--) { %>
            <input type="radio" id="star<%= i %>" name="rating" value="<%= i %>" required>
            <label for="star<%= i %>">★</label>
            <% } %>
        </div>

        <label for="reviewComment">Your Review:</label>
        <textarea id="reviewComment" name="reviewComment" rows="5" required></textarea>

        <button type="submit">Submit Review</button>
    </form>
</div>
</body>
</html>

