<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>用户登录</title></head>
<body>
    <h2>用户登录</h2>
    <form action="ch03_11_userReceive.jsp" method="post">
        <p>
            用户名：<input type="text" name="username" required>
        </p>
        <p>
            密码：<input type="password" name="password" required>
        </p>
        <p>
            <input type="submit" value="登录">
        </p>
    </form>
</body>
</html>
