<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="studentDAO" class="com.example.StudentDAO" scope="page" />
<jsp:useBean id="student" class="com.example.Students" scope="page" />
<form action="add_student_action.jsp" method="post">
姓名: <input type="text" name="name"><br>
年龄: <input type="number" name="age"><br>
性别:
<select name="gender">
<option value="男">男</option>
<option value="女">女</option>
</select><br>
身高(cm): <input type="number" name="height"><br>
体重(kg): <input type="number" name="weight"><br>
<input type="submit" value="添加">
<a href="index.jsp">取消</a>
</form>
