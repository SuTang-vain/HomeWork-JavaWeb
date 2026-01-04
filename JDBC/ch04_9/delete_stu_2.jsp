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
    String message = "";
    String messageColor = "red";
    int deletedRows = 0;
    List<String[]> studentList = new ArrayList<>();

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);

        String conditionType = request.getParameter("conditionType");
        String conditionValue = request.getParameter("conditionValue");

        if (conditionType == null || conditionValue == null || conditionValue.trim().isEmpty()) {
            message = "Error: Please provide condition type and value!";
        } else {
            String sql = "";
            boolean isNumeric = conditionValue.matches("\\d+");

            if ("name".equals(conditionType)) {
                sql = "DELETE FROM stu_info WHERE name = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, conditionValue);
            } else if ("gender".equals(conditionType)) {
                sql = "DELETE FROM stu_info WHERE gender = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, conditionValue);
            } else if ("age".equals(conditionType)) {
                sql = "DELETE FROM stu_info WHERE age = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(conditionValue));
            } else if ("weight".equals(conditionType)) {
                sql = "DELETE FROM stu_info WHERE weight = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setFloat(1, Float.parseFloat(conditionValue));
            } else if ("department".equals(conditionType)) {
                sql = "DELETE FROM stu_info WHERE department = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, conditionValue);
            } else {
                message = "Error: Invalid condition type!";
            }

            if (pstmt != null) {
                deletedRows = pstmt.executeUpdate();
                message = "Delete successful! " + deletedRows + " record(s) deleted.";
                messageColor = "green";
                pstmt.close();
            }
        }

        String selectSql = "SELECT * FROM stu_info ORDER BY id";
        pstmt = conn.prepareStatement(selectSql);
        ResultSet rs = pstmt.executeQuery();

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

        rs.close();

    } catch (Exception e) {
        message = "Delete failed: " + e.getMessage();
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>删除学生 - 步骤 2</title>
    <style>
        .message-success { color: green; font-weight: bold; }
        .message-error { color: red; font-weight: bold; }
        .table-header { background-color: #f0f0f0; }
    </style>
</head>
<body>
    <h2>示例 4-9：按条件删除学生 - 步骤 2/2</h2>

    <p class="<%= messageColor %>">
        <%= message %>
    </p>

    <h3>剩余学生记录：</h3>
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
        <a href="delete_stu_2_tijiao.jsp">Delete Again</a> |
        <a href="../index.jsp">Back to Home</a>
    </p>
</body>
</html>
