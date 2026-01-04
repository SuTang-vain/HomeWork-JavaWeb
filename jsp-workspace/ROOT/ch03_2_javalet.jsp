<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<style>
body {
    font-family: "宋体", SimSun, serif;
}
</style>
</head>
<body>
<h2>直角三角形的形式显示数字：</h2>
<%
    for(int i = 1; i <= 9; i++) {
        for(int j = 1; j <= i; j++) {
            out.print(j + " ");
        }
        out.println("<br>");
    }
%>
<h2>根据随机产生的数据不同，显示不同的问候</h2>
<p>Have a <b>lousy</b> day</p>
</body>
</html>