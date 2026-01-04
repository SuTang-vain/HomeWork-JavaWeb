<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>整数求和 - 输入页面</title>
</head>
<body>
    <h2>请输入两个整数：</h2>
    <form action="show.jsp" method="post">
        <p>
            第一个整数：<input type="text" name="number1">
        </p>
        <p>
            第二个整数：<input type="text" name="number2">
        </p>
        <p>
            <input type="submit" value="计算和值">
        </p>
    </form>
</body>
</html>
