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
    String messageColor = "green";
    int restoredRows = 0;
    List<String[]> studentList = new ArrayList<>();

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, username, password);

        String sql = "INSERT INTO stu_info (name, gender, age, weight, department, address) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);

        String[][] deletedStudents = {
            {"2", "LiSi", "Female", "21", "82.3", "Software Engineering", "Pudong District, Shanghai"},
            {"4", "ZhaoLiu", "Female", "22", "90.2", "Network Engineering", "Nanshan District, Shenzhen"},
            {"6", "TestUser1", "Male", "25", "85.5", "Computer Science", "Beijing"},
            {"7", "TestUser2", "Female", "23", "92", "Software Engineering", "Shanghai"},
            {"8", "TestUser3", "Male", "22", "88.3", "Information Security", "Guangzhou"},
            {"9", "UserA", "Male", "24", "81", "Computer Science", "Beijing"},
            {"10", "UserB", "Female", "26", "95.5", "Software Engineering", "Shanghai"}
        };

        for (String[] student : deletedStudents) {
            try {
                pstmt.setString(1, student[1]);
                pstmt.setString(2, student[2]);
                pstmt.setInt(3, Integer.parseInt(student[3]));
                pstmt.setFloat(4, Float.parseFloat(student[4]));
                pstmt.setString(5, student[5]);
                pstmt.setString(6, student[6]);
                pstmt.executeUpdate();
                restoredRows++;
            } catch (SQLException e) {
                // 忽略重复插入错误
            }
        }

        message = "Restore successful! " + restoredRows + " record(s) restored.";

        pstmt.close();

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
        message = "Restore failed: " + e.getMessage();
        messageColor = "red";
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
    <title>示例 4-8 - 恢复学生</title>
    <style>
        .message-success { color: green; font-weight: bold; }
        .message-error { color: red; font-weight: bold; }
        .table-header { background-color: #f0f0f0; }
    </style>
</head>
<body>
    <h2>示例 4-8：恢复已删除的学生记录</h2>

    <p class="<%= messageColor %>">
        <%= message %>
    </p>

    <h3>All Student Records (After Restore):</h3>
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
                String bgColor = Float.parseFloat(student[4]) >= 80 ? "#ffebee" : "#ffffff";
        %>
        <tr style="background-color: <%= bgColor %>;">
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

    <p><strong>Note:</strong> Records with weight >= 80 are highlighted in pink.</p>

    <p>
        <a href="restore_stu.jsp">Restore Again</a> |
        <a href="delete_stu.jsp">Go to Delete Page</a> |
        <a href="../index.jsp">Back to Home</a>
    </p>
</body>
</html>
