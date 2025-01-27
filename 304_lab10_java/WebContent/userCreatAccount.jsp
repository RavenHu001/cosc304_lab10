<%@ page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ include file="components/header.jsp" %>
<form method="post" action="userCreatAccount.jsp">
    <table>
        <tr><td><input type="text" name="username" placeholder="Username" required></td></tr>
        <tr><td><input type="password" name="password" placeholder="Password" required></td></tr>
        <tr><td><input type="email" name="email" placeholder="Email"></td></tr>
        <tr><td><button type="submit">Register</button></td></tr>
    </table>
</form>
<%
    // 获取表单提交的数据
    String userid = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email");

    if (userid != null && password != null && email != null) {
        // 调用后端逻辑将用户数据存入数据库
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";
        try (Connection conn = DriverManager.getConnection(url, uid, pw);){
            PreparedStatement pstmt = conn.prepareStatement("insert into customer(email,userid,password) values(?,?,?)");
            pstmt.setString(1, email);
            pstmt.setString(2, userid);
            pstmt.setString(3, password);
            try {
                int effectRow = pstmt.executeUpdate();
                out.println("<h1>Register success!Please go back to account page and login </h1>");
            }catch (SQLException ex){
                out.println("<h1>Account already exist!</h1>");
            }
        }catch (SQLException ex) {
            out.println("SQLException: " + ex);
        }catch (NumberFormatException e){
            //this error only phappend for change cId into int
            out.println("<h1>Invalid input. Please try again.</h1>");
        }
    }else{
        out.println("<h3>Please fill all inputs!</h3>");
    }
%>