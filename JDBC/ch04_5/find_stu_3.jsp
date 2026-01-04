<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <title>查询结果</title>
</head>
<body>
<%
    String id = request.getParameter("id");
    String age_min = request.getParameter("age_min");
    String age_max = request.getParameter("age_max");

    String jdbcUrl = "jdbc:mysql://jdbc-mysql:3306/testdb?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPassword = "123456";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        conn.createStatement().execute("SET NAMES utf8mb4");

        String sql = "SELECT * FROM person WHERE 1=1";
        if (id != null && !id.trim().isEmpty()) {
            sql += " AND id = " + Integer.parseInt(id);
        }
        if (age_min != null && !age_min.trim().isEmpty()) {
            sql += " AND age >= " + Integer.parseInt(age_min);
        }
        if (age_max != null && !age_max.trim().isEmpty()) {
            sql += " AND age <= " + Integer.parseInt(age_max);
        }

        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        out.println("<h3>查询条件：</h3>");
        out.println("<p>");
        if (id != null && !id.trim().isEmpty()) out.println("学号: " + id + " | ");
        if (age_min != null && !age_min.trim().isEmpty()) out.println("年龄>=: " + age_min + " | ");
        if (age_max != null && !age_max.trim().isEmpty()) out.println("年龄<=: " + age_max + " | ");
        out.println("</p>");

        out.println("<h3>查询结果：</h3>");
        out.println("<table border='1'>");
        out.println("<tr><th>学号</th><th>姓名</th><th>性别</th><th>年龄</th><th>体重</th><th>身高</th></tr>");

        int count = 0;
        while (rs.next()) {
            count++;
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
        out.println("<p><strong>共找到 " + count + " 条记录</strong></p>");

    } catch (Exception e) {
        out.println("<h3>错误: " + e.getMessage() + "</h3>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {}
    }
%>
<br>
<a href="find_stu_3_tijiao.jsp">返回查询</a>
</body>
</html>
