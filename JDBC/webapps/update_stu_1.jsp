<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://jdbc-mysql:3306/testdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8&connectionCollation=utf8_unicode_ci";
    String username = "root";
    String password = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String message = "";

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);
        conn.createStatement().execute("SET NAMES latin1");
        conn.createStatement().execute("SET character_set_connection=latin1");

        if (request.getMethod().equalsIgnoreCase("POST")) {
            String studentName = "ZhangSan";
            String weightStr = request.getParameter("weight");

            if (weightStr != null && !weightStr.trim().isEmpty()) {
                try {
                    double newWeight = Double.parseDouble(weightStr);
                    String sql = "UPDATE person SET weight = ? WHERE name = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setDouble(1, newWeight);
                    pstmt.setString(2, studentName);

                    int rowsAffected = pstmt.executeUpdate();
                    if (rowsAffected > 0) {
                        message = "更新成功！已将学生 '" + studentName + "' 的体重更新为 " + newWeight + " kg";
                    } else {
                        message = "更新失败！未找到学生 '" + studentName + "'";
                    }
                    pstmt.close();
                    pstmt = null;
                } catch (NumberFormatException e) {
                    message = "错误：请输入有效的数字";
                }
            }
        }

        String selectSql = "SELECT * FROM person WHERE name = ?";
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setString(1, "ZhangSan");
        rs = pstmt.executeQuery();

    } catch (Exception e) {
        message = "错误：" + e.getMessage();
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>更新学生体重信息</title>
</head>
<body>
    <h2>更新学生体重信息</h2>

    <% if (!message.isEmpty()) { %>
        <p><%= message %></p>
    <% } %>

    <form method="post">
        输入体重: <input type="number" name="weight" step="0.1" placeholder="如: 75.5">
        <input type="submit" value="更新">
    </form>

    <h3>当前学生信息</h3>
    <table border='1'>
        <tr>
            <th>ID</th>
            <th>姓名</th>
            <th>性别</th>
            <th>年龄</th>
            <th>体重(kg)</th>
            <th>身高(cm)</th>
        </tr>
        <%
            if (rs != null && rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("gender") %></td>
            <td><%= rs.getInt("age") %></td>
            <td><%= rs.getDouble("weight") %></td>
            <td><%= rs.getInt("height") %></td>
        </tr>
        <%
            } else {
        %>
        <tr>
            <td colspan="6" style="text-align: center;">未找到学生信息</td>
        </tr>
        <%
            }
        %>
    </table>

    <p>操作说明：输入体重值并点击更新按钮，将使用 PreparedStatement 将姓名为"ZhangSan"的学生的体重更新为指定值</p>
</body>
</html>

<%
    if (rs != null) try { rs.close(); } catch (SQLException e) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    if (conn != null) try { conn.close(); } catch (SQLException e) {}
%>
