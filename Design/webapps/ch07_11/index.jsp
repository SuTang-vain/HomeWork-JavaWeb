<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.Students" %>
<%@ page import="com.example.StudentDAO" %>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生体质信息管理系统</title>
</head>
<body>
    <h1>学生体质信息管理系统</h1>
    <p>
        <a href="add_student.jsp">添加学生</a> |
        <a href="search_student.jsp">查询学生</a>
    </p>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>姓名</th>
            <th>年龄</th>
            <th>性别</th>
            <th>身高(cm)</th>
            <th>体重(kg)</th>
            <th>BMI</th>
            <th>健康状态</th>
            <th>操作</th>
        </tr>
        <%
            List<Students> studentsList = studentDAO.queryAllStudents();
            if (studentsList != null) {
                for (Students student : studentsList) {
        %>
        <tr>
            <td><%= student.getId() %></td>
            <td><%= student.getName() %></td>
            <td><%= student.getAge() %></td>
            <td><%= student.getGender() %></td>
            <td><%= student.getHeight() %></td>
            <td><%= student.getWeight() %></td>
            <td><%= String.format("%.2f", student.getBmi()) %></td>
            <td><%= student.getHealth_status() %></td>
            <td>
                <a href="edit_student.jsp?id=<%= student.getId() %>">编辑</a> |
                <a href="delete_student.jsp?id=<%= student.getId() %>" onclick="return confirm('确定删除？')">删除</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>
