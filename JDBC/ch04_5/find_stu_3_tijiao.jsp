<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>学生信息查询</title>
</head>
<body>
    <h2>查询学生信息</h2>
    <form action="find_stu_3.jsp" method="post">
        学号: <input type="text" name="id"><br><br>
        姓名: <input type="text" name="name"><br><br>
        性别:
        <select name="gender">
            <option value="">--请选择--</option>
            <option value="男">男</option>
            <option value="女">女</option>
        </select><br><br>
        年龄范围:
        <input type="number" name="age_min" placeholder="最小年龄">
        到
        <input type="number" name="age_max" placeholder="最大年龄">
        <br><br>
        <input type="submit" value="查询">
    </form>
</body>
</html>
