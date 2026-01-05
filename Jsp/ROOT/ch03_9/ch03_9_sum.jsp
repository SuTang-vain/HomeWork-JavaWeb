<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String str1 = request.getParameter("num1");
    String str2 = request.getParameter("num2");

    double s1 = Double.parseDouble(str1);
    double s2 = Double.parseDouble(str2);

    double s3 = s1 + s2;

    request.setAttribute("s1", s1);
    request.setAttribute("s2", s2);
    request.setAttribute("s3", s3);

%>
<jsp:forward page="ch03_9_output.jsp"/>
