<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>学生信息列表</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            border-collapse: collapse;
            width: 80%;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        a {
            color: blue;
            text-decoration: none;
            margin-right: 10px;
        }
        .count {
            background-color: #e7f3ff;
            padding: 10px;
            border-left: 4px solid #2196F3;
        }
    </style>
</head>
<body>
    <h2>学生信息列表</h2>

    <div class="count">
        <strong>总记录数：</strong>
        <%
            String jdbcUrl = "jdbc:mysql://jdbc-mysql:3306/testdb?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "123456";

            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                String countSql = "SELECT COUNT(*) as total FROM person";
                ps = conn.prepareStatement(countSql);
                rs = ps.executeQuery();
                if (rs.next()) {
                    out.println(rs.getInt("total"));
                }
            } catch (Exception e) {
                out.println("错误: " + e.getMessage());
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {}
            }
        %>
    </div>

    <table>
        <thead>
            <tr>
                <th>学号</th>
                <th>姓名</th>
                <th>性别</th>
                <th>年龄</th>
                <th>体重(kg)</th>
                <th>身高(cm)</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                String sql = "SELECT * FROM person ORDER BY id";
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
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
                }
            } catch (Exception e) {
        %>
                <tr>
                    <td colspan="6" style="color: red;">错误: <%= e.getMessage() %></td>
                </tr>
        <%
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <br>
    <a href="insert_stu_2_tijiao.jsp">添加新学生</a>
</body>
</html>
