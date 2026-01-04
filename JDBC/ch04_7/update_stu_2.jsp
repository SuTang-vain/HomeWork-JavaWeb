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
    boolean success = false;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);

        String stuId = (String)session.getAttribute("stuId");

        if (stuId == null || stuId.trim().isEmpty()) {
            message = "错误：未获取到学生ID，请重新查询！";
        } else {
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String ageStr = request.getParameter("age");
            String department = request.getParameter("department");
            String address = request.getParameter("address");

            if (name == null || name.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty() ||
                ageStr == null || ageStr.trim().isEmpty() ||
                department == null || department.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {
                message = "错误：请填写所有字段！";
            } else {
                int age = Integer.parseInt(ageStr);

                String sql = "UPDATE stu_info SET name = ?, gender = ?, age = ?, department = ?, address = ? WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setString(2, gender);
                pstmt.setInt(3, age);
                pstmt.setString(4, department);
                pstmt.setString(5, address);
                pstmt.setInt(6, Integer.parseInt(stuId));

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    success = true;
                    message = "更新成功！已更新学生信息。";
                } else {
                    message = "更新失败：未找到要更新的记录！";
                }

                pstmt.close();
                pstmt = null;

                String selectSql = "SELECT * FROM stu_info WHERE id = ?";
                pstmt = conn.prepareStatement(selectSql);
                pstmt.setInt(1, Integer.parseInt(stuId));
                rs = pstmt.executeQuery();

                if (rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>更新结果 - 步骤3</title>
</head>
<body>
    <h2>更新结果 - 步骤3/3</h2>

    <p style="color: <%= success ? "green" : "red" %>; font-weight: bold;">
        <%= message %>
    </p>

    <h3>更新后的学生信息：</h3>
    <table border="1">
        <tr style="background-color: #f0f0f0;">
            <th>学号</th>
            <th>姓名</th>
            <th>性别</th>
            <th>年龄</th>
            <th>系部</th>
            <th>地址</th>
        </tr>
        <tr>
            <td><%= rs.getString("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("gender") %></td>
            <td><%= rs.getInt("age") %></td>
            <td><%= rs.getString("department") %></td>
            <td><%= rs.getString("address") %></td>
        </tr>
    </table>

    <p>
        <a href="update_stu_2_tijiao.jsp">继续更新其他学生</a> |
        <a href="../index.jsp">返回主页</a>
    </p>
</body>
</html>
<%
                }

                session.removeAttribute("stuId");
            }
        }

    } catch (Exception e) {
        message = "更新失败：" + e.getMessage();
        e.printStackTrace();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>更新失败</title>
</head>
<body>
    <h2>更新失败</h2>
    <p style="color: red;"><%= message %></p>
    <p><a href="update_stu_2_tijiao.jsp">返回重新操作</a></p>
</body>
</html>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
