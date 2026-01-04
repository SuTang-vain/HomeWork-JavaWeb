<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="counter" class="ch05_2.Counter" scope="application"/>
<% counter.increment(); %>

<html>
<head>
    <title>计数器页面1</title>
</head>
<body>
    <h2>网页计数器 - 页面1</h2>
    <p>当前页面：counter1.jsp</p>
    <p>总访问次数：<jsp:getProperty name="counter" property="count"/></p>
    <p><a href="counter2.jsp">访问页面2</a></p>
</body>
</html>
