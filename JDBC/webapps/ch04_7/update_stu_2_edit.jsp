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

    String studentId = "";
    String studentName = "";
    String studentGender = "";
    int studentAge = 0;
    String studentDept = "";
    String studentAddr = "";
    boolean found = false;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);

        String id = request.getParameter("id");
        String name = request.getParameter("name");

        if (id != null && !id.trim().isEmpty()) {
            String sql = "SELECT * FROM stu_info WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(id));
            rs = pstmt.executeQuery();

            if (rs.next()) {
                found = true;
                studentId = rs.getString("id");
                studentName = rs.getString("name");
                studentGender = rs.getString("gender");
                studentAge = rs.getInt("age");
                studentDept = rs.getString("department");
                studentAddr = rs.getString("address");

                session.setAttribute("stuId", studentId);
            }
            rs.close();
            pstmt.close();
        } else if (name != null && !name.trim().isEmpty()) {
            String sql = "SELECT * FROM stu_info WHERE name = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                found = true;
                studentId = rs.getString("id");
                studentName = rs.getString("name");
                studentGender = rs.getString("gender");
                studentAge = rs.getInt("age");
                studentDept = rs.getString("department");
                studentAddr = rs.getString("address");

                session.setAttribute("stuId", studentId);
            }
            rs.close();
            pstmt.close();
        } else {
            message = "请输入查询条件！";
        }

    } catch (Exception e) {
        message = "查询失败：" + e.getMessage();
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑学生信息 - 步骤2</title>
</head>
<body>
    <h2>编辑学生信息 - 步骤2/3</h2>

    <% if (!message.isEmpty()) { %>
        <p style="color: red;"><%= message %></p>
        <p><a href="update_stu_2_tijiao.jsp">返回查询</a></p>
    <% } else if (found) { %>

    <form action="update_stu_2.jsp" method="post">
        <table border="1">
            <tr>
                <th colspan="2" style="background-color: #f0f0f0;">学生信息编辑</th>
            </tr>
            <tr>
                <td>学号：</td>
                <td><input type="text" name="id" value="<%= studentId %>" readonly></td>
            </tr>
            <tr>
                <td>姓名：</td>
                <td><input type="text" name="name" value="<%= studentName %>"></td>
            </tr>
            <tr>
                <td>性别：</td>
                <td>
                    <input type="radio" name="gender" value="Male" <%= "Male".equals(studentGender) ? "checked" : "" %>> 男
                    <input type="radio" name="gender" value="Female" <%= "Female".equals(studentGender) ? "checked" : "" %>> 女
                </td>
            </tr>
            <tr>
                <td>年龄：</td>
                <td><input type="number" name="age" value="<%= studentAge %>"></td>
            </tr>
            <tr>
                <td>系部：</td>
                <td><input type="text" name="department" value="<%= studentDept %>"></td>
            </tr>
            <tr>
                <td>地址：</td>
                <td><input type="text" name="address" value="<%= studentAddr %>" style="width: 300px;"></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <input type="submit" value="确认修改">
                    <input type="button" value="取消" onclick="location.href='update_stu_2_tijiao.jsp'">
                </td>
            </tr>
        </table>
    </form>

    <% } else { %>
        <p style="color: red;">未找到符合条件的记录！</p>
        <p><a href="update_stu_2_tijiao.jsp">重新查询</a></p>
    <% } %>

    <p><strong>当前查询条件：</strong>
    <% if (request.getParameter("id") != null && !request.getParameter("id").trim().isEmpty()) { %>
        学号 = <%= request.getParameter("id") %>
    <% } else if (request.getParameter("name") != null && !request.getParameter("name").trim().isEmpty()) { %>
        姓名 = <%= request.getParameter("name") %>
    <% } %>
    </p>
</body>
</html>
