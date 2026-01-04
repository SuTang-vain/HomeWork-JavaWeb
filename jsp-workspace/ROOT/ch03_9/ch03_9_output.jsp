<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    double s1 = (Double) request.getAttribute("s1");
    double s2 = (Double) request.getAttribute("s2");
    double s3 = (Double) request.getAttribute("s3");
%>
<html>
<head><title>实数加法计算 - 结果显示</title></head>
<body>
    <h2>计算结果</h2>
    <p>数据1：<%= s1 %></p>
    <p>数据2：<%= s2 %></p>
    <hr>
    <p>两数之和：<%= s3 %></p>
    <p><a href="ch03_9_input.jsp">返回重新计算</a></p>
</body>
</html>
