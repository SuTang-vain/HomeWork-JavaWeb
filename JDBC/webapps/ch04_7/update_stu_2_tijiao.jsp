<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>查询学生信息 - 步骤1</title>
</head>
<body>
    <h2>查询学生信息 - 步骤1/3</h2>
    <p>请输入查询条件（假设满足条件的记录只有一条）：</p>

    <form action="update_stu_2_edit.jsp" method="post">
        <table border="1">
            <tr>
                <td>学号：</td>
                <td><input type="text" name="id" placeholder="输入学号"></td>
            </tr>
            <tr>
                <td>姓名：</td>
                <td><input type="text" name="name" placeholder="输入姓名"></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <input type="submit" value="查询">
                </td>
            </tr>
        </table>
    </form>

    <p><strong>说明：</strong>输入学号或姓名任意一项进行查询</p>
</body>
</html>
