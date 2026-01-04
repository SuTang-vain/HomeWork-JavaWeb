<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
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
    String messageColor = "red";
    int deletedRows = 0;
    List<String[]> studentList = new ArrayList<>();

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);

        String sql = "delete from stu_info where weight >= ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setFloat(1, 80);

        deletedRows = pstmt.executeUpdate();

        if (deletedRows > 0) {
            message = "Delete successful! " + deletedRows + " record(s) deleted.";
            messageColor = "green";
        } else {
            message = "Delete successful! 0 record(s) deleted.";
            messageColor = "orange";
        }

        pstmt.close();

        String selectSql = "SELECT * FROM stu_info ORDER BY id";
        pstmt = conn.prepareStatement(selectSql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String[] student = new String[7];
            student[0] = rs.getString("id");
            student[1] = rs.getString("name");
            student[2] = rs.getString("gender");
            student[3] = rs.getString("age");
            student[4] = rs.getString("weight");
            student[5] = rs.getString("department");
            student[6] = rs.getString("address");
            studentList.add(student);
        }

    } catch (Exception e) {
        message = "Delete failed: " + e.getMessage();
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
    <title>示例 4-8：删除学生</title>
    <style>
        .message-success { color: green; font-weight: bold; }
        .message-warning { color: orange; font-weight: bold; }
        .message-error { color: red; font-weight: bold; }
        .table-header { background-color: #f0f0f0; }
    </style>
</head>
<body>
    <h2>>示例 4-8：删除体重 >= 80 的学生</h2>

    <p class="<%= messageColor.equals("green") ? "message-success" : (messageColor.equals("orange") ? "message-warning" : "message-error") %>">
        <%= message %>
    </p>

    <h3>Remaining Student Records:</h3>
    <table border="1">
        <tr class="table-header">
            <th>ID</th>
            <th>Name</th>
            <th>Gender</th>
            <th>Age</th>
            <th>Weight</th>
            <th>Department</th>
            <th>Address</th>
        </tr>
        <%
            for (String[] student : studentList) {
        %>
        <tr>
            <td><%= student[0] %></td>
            <td><%= student[1] %></td>
            <td><%= student[2] %></td>
            <td><%= student[3] %></td>
            <td><%= student[4] %></td>
            <td><%= student[5] %></td>
            <td><%= student[6] %></td>
        </tr>
        <%
            }
        %>
    </table>

    <p>
        <a href="delete_stu.jsp">Refresh Page</a> |
        <a href="restore_stu.jsp">Restore Deleted Data</a> |
        <a href="../index.jsp">Back to Home</a>
    </p>
</body>
</html>
