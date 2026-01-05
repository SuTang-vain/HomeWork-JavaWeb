<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>String Parameter Passing</title></head>
<body>
<h2>该页面传递一个参数QQ,直线下是接受参数页面的内容<br></h2>
<hr>
<jsp:include page="ch03_5_output.jsp">
    <jsp:param name="data" value="QQ"/>
</jsp:include>
</body>
</html>