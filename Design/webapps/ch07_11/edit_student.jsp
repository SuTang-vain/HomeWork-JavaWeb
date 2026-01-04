<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<jsp:useBean id="student" class="com.example.Students" scope="page" />
<%
int id = Integer.parseInt(request.getParameter("id"));
student = studentDAO.queryStudentById(id);
if (student == null) {
%>
未找到该学生信息！
<br><a href="index.jsp">返回主页</a>
<%
} else {
%>
<form action="edit_student_action.jsp" method="post">
<input type="hidden" name="id" value="<%= student.getId() %>">
姓名: <input type="text" name="name" value="<%= student.getName() %>"><br>
年龄: <input type="number" name="age" value="<%= student.getAge() %>"><br>
性别:
<select name="gender">
<option value="男" <%= "男".equals(student.getGender()) ? "selected" : "" %>>男</option>
<option value="女" <%= "女".equals(student.getGender()) ? "selected" : "" %>>女</option>
</select><br>
身高(cm): <input type="number" name="height" value="<%= student.getHeight() %>"><br>
体重(kg): <input type="number" name="weight" value="<%= student.getWeight() %>"><br>
<input type="submit" value="更新">
<a href="index.jsp">取消</a>
</form>
<%
}
%>
