<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="userAuth.jsp" %> <!--This check if user is logged in-->
<%@ include file="jdbc.jsp" %>
<%
    String userId = (String) session.getAttribute("authenticatedUser");
    // 获取表单参数
    String newEmail = request.getParameter("email");
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");

    String message = "";

    try (Connection con = DriverManager.getConnection(url, uid, pw);) {
        if (newEmail != null && !newEmail.isEmpty()) {
            // 更新邮箱
            String updateEmailSQL = "UPDATE customer SET email = ? WHERE userid = ?";
            try (PreparedStatement ps = con.prepareStatement(updateEmailSQL)) {
                ps.setString(1, newEmail);
                ps.setString(2, userId);
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    message += "Email updated successfully.<br>";
                } else {
                    message += "Failed to update email.<br>";
                }
            }
        }

        if (currentPassword != null && newPassword != null && confirmPassword != null) {
            if (!newPassword.equals(confirmPassword)) {
                message += "New password and confirm password do not match.<br>";
            } else {
                // 验证当前密码
                String validatePasswordSQL = "SELECT password FROM customer WHERE userid = ?";
                try (PreparedStatement ps = con.prepareStatement(validatePasswordSQL)) {
                    ps.setString(1, userId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String storedPassword = rs.getString("password");
                        if (!storedPassword.equals(currentPassword)) {
                            message += "Current password is incorrect.<br>";
                        } else {
                            // 更新密码
                            String updatePasswordSQL = "UPDATE customer SET password = ? WHERE userid = ?";
                            try (PreparedStatement psUpdate = con.prepareStatement(updatePasswordSQL)) {
                                psUpdate.setString(1, newPassword); // 如需加密密码，可在此加密
                                psUpdate.setString(2, userId);
                                int rowsUpdated = psUpdate.executeUpdate();
                                if (rowsUpdated > 0) {
                                    message += "Password updated successfully.<br>";
                                } else {
                                    message += "Failed to update password.<br>";
                                }
                            }
                        }
                    } else {
                        message += "User not found.<br>";
                    }
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        message += "An error occurred: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update User Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .form-container {
            max-width: 400px;
            margin: 0 auto;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin: 10px 0 5px;
        }
        input {
            padding: 8px;
            font-size: 14px;
            margin-bottom: 15px;
        }
        button {
            padding: 10px;
            font-size: 16px;
            color: white;
            background-color: #007BFF;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .message {
            margin: 20px 0;
            color: green;
        }
    </style>
</head>
<body>
<%@ include file="components/header.jsp" %>
<h1>Update User Information</h1>

<!-- 显示操作结果消息 -->
<div class="message"><%= message %></div>

<!-- 修改邮箱表单 -->
<div class="form-container">
    <form method="post" action="userUpdateE_P.jsp">
        <h2>Update Email</h2>
        <label for="email">New Email:</label>
        <input type="email" id="email" name="email" placeholder="Enter new email" required>
        <button type="submit">Update Email</button>
    </form>
</div>

<!-- 修改密码表单 -->
<div class="form-container">
    <form method="post" action="userUpdateE_P.jsp">
        <h2>Update Password</h2>
        <label for="currentPassword">Current Password:</label>
        <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password" required>

        <label for="newPassword">New Password:</label>
        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required>

        <label for="confirmPassword">Confirm New Password:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password" required>

        <button type="submit">Update Password</button>
    </form>
</div>
</body>
</html>
