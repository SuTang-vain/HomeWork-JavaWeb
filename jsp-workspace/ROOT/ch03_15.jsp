<%@ page language="java" pageEncoding="UTF-8"%>
<%--
  程序功能：
  演示JSP内置对象 out的使用方法，用于向页面输出内容。
  运行流程分析：
  <%
  out.print("aaa<br/>bbb");  // 输出第一行
  out.print("<br/>用户名或密码不正确，请重新...");  // 输出错误信息和链接
  out.print("<br><a href='javascript:history.back()'>后退</a>...");  // 输出后退链接
  %>
  其他分析：
  1. out.print() -JSP内置对象，用于向响应流输出内容
  2. HTML标签混用 -在print方法中嵌入HTML标签
--%>

<html>
<head><title>out的使用</title></head>
<body>
利用out对象输出的页面信息：<br>
<hr>
<%
out.print("aaa<br/>bbb");
out.print("<br/>用户名或密码不正确，请重新<a href='http://www.bistu.edu.cn'><font size='15' color='red'>登录</font></a>");
out.print("<br><a href='javascript:history.back()'>后退</a>……");
%>
</body>
</html>
