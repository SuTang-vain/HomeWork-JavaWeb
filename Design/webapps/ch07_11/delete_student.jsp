<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<jsp:useBean id="student" class="com.example.Students" scope="page" />
<%
int id = Integer.parseInt(request.getParameter("id"));
student = studentDAO.queryStudentById(id);
if (student != null) {
%>
确认删除学生：<%= student.getName() %>
<br>ID: <%= student.getId() %>, 年龄: <%= student.getAge() %>, 性别: <%= student.getGender() %>
<br>身高: <%= student.getHeight() %>cm, 体重: <%= student.getWeight() %>kg
<br><strong>此操作不可撤销！</strong>
<br><a href="delete_student_action.jsp?id=<%= id %>">确认删除</a>
<a href="index.jsp">取消</a>
<%
} else {
%>
未找到该学生信息！
<br><a href="index.jsp">返回主页</a>
<%
}
%>
