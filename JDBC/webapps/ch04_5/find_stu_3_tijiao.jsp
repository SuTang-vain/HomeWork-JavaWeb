<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <title>学生信息查询</title>
</head>
<body>
    <h2>查询学生信息</h2>
    <form action="find_stu_3.jsp" method="post">
        学号: <input type="text" name="id"><br><br>
        姓名: <input type="text" name="name"><br><br>
        性别:
        <select name="gender">
            <option value="">--请选择--</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
        </select><br><br>
        年龄范围:
        <input type="number" name="age_min" placeholder="最小年龄">
        到
        <input type="number" name="age_max" placeholder="最大年龄">
        <br><br>
        <input type="submit" value="查询">
    </form>

    <%
        String jdbcUrl = "jdbc:mysql://jdbc-mysql:3306/testdb?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&connectionCollation=utf8_unicode_ci";
        String dbUser = "root";
        String dbPassword = "123456";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            conn.createStatement().execute("SET NAMES utf8");
            conn.createStatement().execute("SET character_set_connection=utf8");

            String sql = "SELECT * FROM person ORDER BY id";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            out.println("<h3>所有学生信息：</h3>");
            out.println("<table border='1'>");
            out.println("<tr><th>学号</th><th>姓名</th><th>性别</th><th>年龄</th><th>体重</th><th>身高</th></tr>");

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("gender") + "</td>");
                out.println("<td>" + rs.getInt("age") + "</td>");
                out.println("<td>" + rs.getDouble("weight") + "</td>");
                out.println("<td>" + rs.getInt("height") + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");

        } catch (Exception e) {
            out.println("<p>错误: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
    %>
</body>
</html>
