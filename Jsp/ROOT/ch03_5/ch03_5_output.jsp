<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String value = request.getParameter("data");
%>
接受参数，并显示结果页面<br>
<span style="font-size: 50px; color: blue;"><%= value %></span>
你好，欢迎你访问
