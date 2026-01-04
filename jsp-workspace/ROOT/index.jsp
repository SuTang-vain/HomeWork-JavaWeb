<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP Docker Environment</title>
</head>
<body>
    <h1>Hello from JSP in Docker!</h1>
    <p>This is a sample JSP page running in a Docker container.</p>
    <p>Current server time is: <%= new Date() %></p>
</body>
</html>
