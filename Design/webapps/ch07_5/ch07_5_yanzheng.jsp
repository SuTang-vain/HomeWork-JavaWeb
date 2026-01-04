<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.UserBean" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String userpassword = request.getParameter("userpassword");

    UserBean userBean = new UserBean();
    if (userBean.validateUser(username, userpassword)) {
        out.println("登录成功");
    } else {
        out.println("登录失败");
    }
%>
<br><a href="ch07_5_tijiao.jsp">返回</a>
