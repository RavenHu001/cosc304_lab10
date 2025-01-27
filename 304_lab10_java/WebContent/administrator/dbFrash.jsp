<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ include file="../auth.jsp" %>
<%@ include file="../jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Refresh Database</title>
    <%@include file="../components/listProdStyle.jsp"%>
    <script>
        function confirmRefresh() {
            return confirm("Are you sure you want to refresh the database?");
        }
    </script>
</head>
<body>
<%@ include file="../components/header.jsp" %>
<h1>Refresh Database</h1>
<%

    // DDL脚本文件路径
    String scriptFilePath = application.getRealPath("/") + "ddl/reFreshOrders.ddl";

    // 检查是否提交了刷新请求
    String refresh = request.getParameter("refresh");
    if ("true".equals(refresh)) {
        try {
            // 读取DDL脚本内容
            StringBuilder ddlScript = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new FileReader(scriptFilePath))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    ddlScript.append(line).append("\n");
                }
            }

            try (Connection conn = DriverManager.getConnection(url,uid,pw);
                 Statement stmt = conn.createStatement()) {

                // 分割并执行SQL语句
                String[] sqlStatements = ddlScript.toString().split(";");
                for (String sql : sqlStatements) {
                    if (!sql.trim().isEmpty()) {
                        stmt.execute(sql.trim());
                    }
                }

                out.println("<p style='color:green;'>Database refreshed successfully!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error refreshing database: " + e.getMessage() + "</p>");
        }
    }
%>

<!-- 提供一个刷新按钮 -->
<form method="post" onsubmit="return confirmRefresh();">
    <input type="hidden" name="refresh" value="true" />
    <button type="submit">Refresh Database</button>
</form>
</body>
</html>
