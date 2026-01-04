<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<jsp:useBean id="student" class="com.example.Students" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
int id = Integer.parseInt(request.getParameter("id"));
student = studentDAO.queryStudentById(id);

boolean success = studentDAO.deleteStudentById(id);
if (success) {
%>
删除成功
<br>已删除学生：<%= student.getName() %> (ID: <%= id %>)
<%
} else {
%>
删除失败
<%
}
%>
<br><a href="index.jsp">返回主页</a>
