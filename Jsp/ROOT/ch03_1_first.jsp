<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<html>
    <head>
        <title>1~10累加和</title>
    </head>
    <body>
        <%
            int sum = 0;
            for(int x = 1; x <= 10; x++) {
                sum += x;
            }
            Date currentDate = new Date();
        %>
        <h3>该程序的功能是计算1到10的累加和，并显示运行时间</h3>
        <p>1到10的累加和是：<%=sum%></p>
        <p>程序的运行日期是：<%=currentDate%></p>
    </body>
</html>