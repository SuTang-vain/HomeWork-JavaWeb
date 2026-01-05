<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    String correctUsername = "abcdef";
    String correctPassword = "123456";

    if (correctUsername.equals(username) && correctPassword.equals(password)) {
%>
<jsp:forward page="ch03_11_loginCorrect.jsp"/>
<%
    } else {
        //重定向
        response.sendRedirect("https://www.bistu.edu.cn");
    }
%>
