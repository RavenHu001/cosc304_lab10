<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="head-bar">
    <div class="logo">
        <a href="index.jsp">Ray's Grocery</a>
    </div>
    <div class = "back">
        <a href="javascript:history.back()">Return to preview page</a>
    </div>
    <%
        Object userNameH = session.getAttribute("authenticatedUser");
        boolean isloged = (userNameH != null);
    %>
    <div class="user-status">
        <% if (isloged) { %>
        <!-- 显示已登录状态 -->
        <span>Welcome, <%= userNameH %>!</span>
        <% } else { %>
        <!-- 显示未登录状态 -->
        <span>You are not logged in</span>
        <% } %>
    </div>
    <button class="menu-toggle">☰</button> <!-- 菜单按钮 -->
    <nav class="nav-links">
        <!--<%
        //if (isloged) {
        //    out.print("<a href=\"logout.jsp\">Log Out</a>");
        //}else{
        //    out.print("<a href=\"login.jsp\">Log In</a>");
        //}
        %>-->
        <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
        <a href="<%=request.getContextPath()%>/listprod.jsp">Shopping Page</a>
        <a href="<%=request.getContextPath()%>/userAccount.jsp">User Account</a>
    </nav>
</div>

<style>
    /* 在这里放置与 header 样式相关的 CSS */
    .head-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: #333;
        padding: 10px 20px;
        color: white;
        position: sticky;
        top: 0;
        z-index: 1000;
    }
    .head-bar .logo a {
        text-decoration: none;
        color: white;
        font-size: 1.5em;
        font-weight: bold;
    }
    .head-bar .nav-links a {
        margin: 0 15px;
        text-decoration: none;
        color: white;
        font-size: 1em;
        transition: color 0.3s ease;
    }
    .head-bar .nav-links a:hover {
        color: #f0a500;
    }
    .nav-links {
        display: none;
        flex-direction: column;
        background-color: #333;
        position: absolute;
        top: 50px;
        right: 20px;
        width: 150px;
        z-index: 1000;
        border-radius: 5px;
        padding: 10px;
    }
    .nav-links.show {
        display: flex;
    }
    .menu-toggle {
        font-size: 1.5em;
        background: none;
        border: none;
        color: white;
        cursor: pointer;
    }

    .head-bar .user-status {
        flex: 1;
        text-align: right;
        color: #f0a500;
        font-size: 1em;
        font-weight: bold;
    }

    .head-bar .back a{
        flex: 1;
        text-align: left;
        color: white;
        font-size: 1em;
        font-weight: bold;
        margin-left: 30px;
    }
</style>

<script>
    // 菜单按钮的交互逻辑
    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');
    menuToggle.addEventListener('click', () => {
        navLinks.classList.toggle('show');
    });
</script>