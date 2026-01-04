<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Students - Step 1</title>
</head>
<body>
    <h2>示例 4-9：按条件删除学生 - 步骤 1/2</h2>
    <p>请选择删除的条件：</p>

    <form action="delete_stu_2.jsp" method="post">
        <table border="1">
            <tr>
                <th colspan="2" style="background-color: #f0f0f0;">Delete Condition</th>
            </tr>
            <tr>
                <td>Condition Type:</td>
                <td>
                    <select name="conditionType">
                        <option value="name">Name</option>
                        <option value="gender">Gender</option>
                        <option value="age">Age</option>
                        <option value="weight">Weight</option>
                        <option value="department">Department</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>Condition Value:</td>
                <td><input type="text" name="conditionValue" placeholder="Enter value"></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <input type="submit" value="Delete">
                </td>
            </tr>
        </table>
    </form>

    <p><strong>Examples:</strong></p>
    <ul>
        <li>Name: ZhangSan</li>
        <li>Gender: Male</li>
        <li>Age: 20</li>
        <li>Weight: 80</li>
        <li>Department: Computer Science</li>
    </ul>
</body>
</html>
