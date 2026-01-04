<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<jsp:useBean id="student" class="com.example.Students" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
String name = request.getParameter("name");
int age = Integer.parseInt(request.getParameter("age"));
String gender = request.getParameter("gender");
double height = Double.parseDouble(request.getParameter("height"));
double weight = Double.parseDouble(request.getParameter("weight"));

student.setName(name);
student.setAge(age);
student.setGender(gender);
student.setHeight(height);
student.setWeight(weight);

boolean success = studentDAO.addStudent(student);
if (success) {
%>
添加成功
<br>姓名: <%= name %>, 年龄: <%= age %>, 性别: <%= gender %>
<br>身高: <%= height %>cm, 体重: <%= weight %>kg
<br>BMI: <%= String.format("%.2f", student.calculateBMI()) %>
<br>健康状态: <%= student.getHealthStatus() %>
<%
} else {
%>
添加失败
<%
}
%>
<br><a href="index.jsp">返回主页</a>
