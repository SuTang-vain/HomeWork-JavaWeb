<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <title>添加学生处理</title>
    <meta charset="UTF-8">
</head>
<body>
<%
    // 【从request对象中获取数据】
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String gender = request.getParameter("gender");
    String age = request.getParameter("age");
    String weight = request.getParameter("weight");
    String height = request.getParameter("height");

    String jdbcUrl = "jdbc:mysql://jdbc-mysql:3306/testdb?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&connectionCollation=utf8mb4_unicode_ci";
    String dbUser = "root";
    String dbPassword = "123456";

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        // 设置连接字符集
        conn.createStatement().execute("SET NAMES utf8mb4");

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
            out.println("<h4>刚添加的数据：</h4>");
            out.println("<table border='1'>");
            out.println("<tr><th>学号</th><th>姓名</th><th>性别</th><th>年龄</th><th>体重</th><th>身高</th></tr>");
            out.println("<tr><td>" + id + "</td><td>" + name + "</td><td>" + gender + "</td><td>" + age + "</td><td>" + weight + "</td><td>" + height + "</td></tr>");
            out.println("</table>");
        } else {
            out.println("<h3>添加失败！</h3>");
        }

    } catch (SQLException e) {
        String errorMsg = e.getMessage();
        if (errorMsg.contains("Duplicate entry") && errorMsg.contains("PRIMARY")) {
            out.println("<h3>错误: 学号 '" + id + "' 已存在，请使用其他学号！</h3>");
            out.println("<p>当前数据：</p>");
            out.println("<table border='1'>");
            out.println("<tr><th>学号</th><th>姓名</th><th>性别</th><th>年龄</th><th>体重</th><th>身高</th></tr>");
            out.println("<tr><td>" + id + "</td><td>" + name + "</td><td>" + gender + "</td><td>" + age + "</td><td>" + weight + "</td><td>" + height + "</td></tr>");
            out.println("</table>");
        } else {
            out.println("<h3>数据库错误: " + errorMsg + "</h3>");
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
