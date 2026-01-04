<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="counter" class="ch05_2.Counter" scope="application"/>
<% counter.increment(); %>

<html>
<head>
    <title>计数器页面2</title>
</head>
<body>
    <h2>网页计数器 - 页面2</h2>
    <p>当前页面：counter2.jsp</p>
    <p>总访问次数：<jsp:getProperty name="counter" property="count"/></p>
    <p><a href="counter1.jsp">访问页面1</a></p>
</body>
</html>
