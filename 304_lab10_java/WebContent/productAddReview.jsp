<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // 获取表单数据
    String productId = request.getParameter("productId");
    String customerId = request.getParameter("customerId");
    String reviewComment = request.getParameter("reviewComment");
    String reviewRating = request.getParameter("rating");

    try (Connection conn = DriverManager.getConnection(url, uid, pw)) {
        int reviewNum = 0;
        String checkLimitSQL = "select count(*) from review where customerId=? and productId=? group by customerId,productId";
        try (PreparedStatement ps = conn.prepareStatement(checkLimitSQL)){
            ps.setString(1, customerId);
            ps.setString(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                reviewNum = rs.getInt(1);
            }
        }
        if(reviewNum!=0) {
            String updateReviewSQL = "Update review set reviewRating = ?, reviewDate = GETDATE(),reviewComment = ? " +
                    "where customerId = ? and productId = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateReviewSQL)) {
                ps.setString(1, reviewRating);
                ps.setString(2,reviewComment);
                ps.setString(3,customerId);
                ps.setString(4,productId);
                int rowUpdated = ps.executeUpdate();
                if (rowUpdated > 0) {
                    response.sendRedirect("productDetile.jsp?id=" + productId); // 重定向回产品详情页面
                } else {
                    out.println("Failed to update review.");
                }
            }
        }else {
            String insertReviewSQL = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) "
                    + "VALUES (?, GETDATE(), ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertReviewSQL)) {
                ps.setInt(1, Integer.parseInt(reviewRating));
                ps.setInt(2, Integer.parseInt(customerId));
                ps.setInt(3, Integer.parseInt(productId));
                ps.setString(4, reviewComment);
                int rowsInserted = ps.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("productDetile.jsp?id=" + productId); // 重定向回产品详情页面
                } else {
                    out.println("Failed to add review.");
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    }
%>
