<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="add" class="ch05_1.Add" scope="page"/>
<jsp:setProperty name="add" property="*"/>

<html>
<head>
    <title>整数求和 - 结果页面</title>
</head>
<body>
    <h2>计算结果：</h2>
    <p>第一个数：<jsp:getProperty name="add" property="number1"/></p>
    <p>第二个数：<jsp:getProperty name="add" property="number2"/></p>
    <p>和值：<jsp:getProperty name="add" property="sum"/></p>
</body>
</html>
