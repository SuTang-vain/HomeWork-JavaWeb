<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="user" class="com.example.User" scope="request" />
登录成功
<br>欢迎，<jsp:getProperty name="user" property="username" />
<br><a href="ch07_9_tijiao.jsp">返回</a>
