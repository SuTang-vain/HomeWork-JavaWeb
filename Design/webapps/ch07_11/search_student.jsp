<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.Students" %>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<form action="search_student.jsp" method="get">
姓名: <input type="text" name="name">
<input type="submit" value="查询">
<a href="index.jsp">返回主页</a>
</form>
<br>
<%
String name = request.getParameter("name");
if (name != null && !name.trim().isEmpty()) {
    List<Students> studentsList = studentDAO.queryStudentsByName(name);
    if (studentsList == null || studentsList.isEmpty()) {
%>
未找到匹配的学生信息: <%= name %>
<%
    } else {
%>
找到 <%= studentsList.size() %> 条记录
<table border="1">
<tr>
<th>ID</th><th>姓名</th><th>年龄</th><th>性别</th><th>身高</th><th>体重</th><th>BMI</th><th>健康状态</th><th>操作</th>
</tr>
<%
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
<a href="delete_student.jsp?id=<%= student.getId() %>">删除</a>
</td>
</tr>
<%
        }
%>
</table>
<%
    }
} else {
%>
请输入学生姓名进行查询
<%
}
%>
