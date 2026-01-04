<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生信息查询</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #958cff; color: white; }
    </style>
</head>
<body>
    <h2>学生信息列表 (使用 PreparedStatement)</h2>

    <%
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://mysql:3306/testdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String username = "root";
        String password = "123456";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, username, password);

            String sql = "SELECT * FROM stu_info";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
    %>

    <table>
        <tr>
            <th>ID</th>
            <th>姓名</th>
            <th>性别</th>
            <th>年龄</th>
            <th>系部</th>
            <th>地址</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("gender") %></td>
            <td><%= rs.getInt("age") %></td>
            <td><%= rs.getString("department") %></td>
            <td><%= rs.getString("address") %></td>
        </tr>
        <%
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
        %>
    </table>
</body>
</html>
