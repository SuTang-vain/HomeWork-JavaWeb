<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加学生处理</title>
</head>
<body>
<%
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String gender = request.getParameter("gender");
    String age = request.getParameter("age");
    String weight = request.getParameter("weight");
    String height = request.getParameter("height");

    String jdbcUrl = "jdbc:mysql://localhost:3306/testdb?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
    String dbUser = "root";
    String dbPassword = "123456";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        String sql = "INSERT INTO person (id, name, gender, age, weight, height) VALUES (?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(id));
        ps.setString(2, name);
        ps.setString(3, gender);
        ps.setInt(4, Integer.parseInt(age));
        ps.setDouble(5, Double.parseDouble(weight));
        ps.setInt(6, Integer.parseInt(height));

        int result = ps.executeUpdate();

        if (result > 0) {
            out.println("<h3>添加成功！</h3>");
        } else {
            out.println("<h3>添加失败！</h3>");
        }

    } catch (Exception e) {
        out.println("<h3>错误: " + e.getMessage() + "</h3>");
    } finally {
        try {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {}
    }
%>
<br>
<a href="insert_stu_2_tijiao.jsp">返回</a>
</body>
</html>
