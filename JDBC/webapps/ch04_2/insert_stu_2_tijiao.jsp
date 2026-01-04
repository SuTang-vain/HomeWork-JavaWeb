<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>学生信息提交</title>
</head>
<body>
    <h2>添加学生信息</h2>
    <form action="insert_stu_2.jsp" method="post">
        学号: <input type="text" name="id" required><br><br>
        姓名: <input type="text" name="name" required><br><br>
        性别: <input type="radio" name="gender" value="男" checked> 男
              <input type="radio" name="gender" value="女"> 女<br><br>
        年龄: <input type="number" name="age" required><br><br>
        体重: <input type="number" name="weight" step="0.1" required><br><br>
        身高: <input type="number" name="height" required><br><br>
        <input type="submit" value="提交">
    </form>
</body>
</html>
