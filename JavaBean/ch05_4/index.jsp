<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="user" class="ch05_4.User" scope="page"/>
<jsp:setProperty name="user" property="*"/>

<%
String action = request.getParameter("action");
String message = "";

// 从application中获取用户列表（全局共享）
List<Map<String, String>> userList = (List<Map<String, String>>) application.getAttribute("userList");
if (userList == null) {
    userList = new ArrayList<>();
    application.setAttribute("userList", userList);
}

if ("add".equals(action)) {
    try {
        String userid = request.getParameter("userid");
        String username = request.getParameter("username");
        String sex = request.getParameter("sex");

        if (userid != null && !userid.trim().isEmpty() &&
            username != null && !username.trim().isEmpty() &&
            sex != null && !sex.trim().isEmpty()) {

            // 检查用户ID是否已存在
            boolean exists = false;
            for (Map<String, String> u : userList) {
                if (u.get("userid").equals(userid)) {
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                Map<String, String> newUser = new HashMap<>();
                newUser.put("userid", userid);
                newUser.put("username", username);
                newUser.put("sex", sex);
                userList.add(newUser);
                message = "添加成功！";
            } else {
                message = "错误：用户ID已存在！";
            }
        } else {
            message = "错误：请填写所有字段！";
        }
    } catch (Exception e) {
        message = "错误：" + e.getMessage();
    }
} else if ("delete".equals(action)) {
    try {
        String userid = request.getParameter("userid");
        if (userid != null) {
            boolean removed = userList.removeIf(u -> u.get("userid").equals(userid));
            message = removed ? "删除成功！" : "错误：用户不存在！";
        }
    } catch (Exception e) {
        message = "错误：" + e.getMessage();
    }
} else if ("update".equals(action)) {
    try {
        String userid = request.getParameter("userid");
        String username = request.getParameter("username");
        String sex = request.getParameter("sex");

        boolean updated = false;
        for (Map<String, String> u : userList) {
            if (u.get("userid").equals(userid)) {
                if (username != null && !username.trim().isEmpty()) {
                    u.put("username", username);
                }
                if (sex != null && !sex.trim().isEmpty()) {
                    u.put("sex", sex);
                }
                updated = true;
                break;
            }
        }
        message = updated ? "修改成功！" : "错误：用户不存在！";
    } catch (Exception e) {
        message = "错误：" + e.getMessage();
    }
}
%>

<html>
<head>
    <title>用户管理系统 </title>
</head>
<body>
    <h2>用户管理系统</h2>

    <% if (!message.isEmpty()) { %>
        <p><%=message%></p>
    <% } %>

    <h3>添加用户</h3>
    <form action="index.jsp" method="post">
        <input type="hidden" name="action" value="add">
        <p>用户ID：<input type="text" name="userid"></p>
        <p>用户名：<input type="text" name="username"></p>
        <p>性别：<input type="text" name="sex"></p>
        <p><input type="submit" value="添加"></p>
    </form>

    <h3>用户列表</h3>
    <table border="1">
        <tr>
            <th>用户ID</th>
            <th>用户名</th>
            <th>性别</th>
            <th>操作</th>
        </tr>
        <%
        try {
            if (userList.isEmpty()) {
                out.println("<tr><td colspan='4' style='text-align:center;'>暂无用户数据</td></tr>");
            } else {
                for (Map<String, String> u : userList) {
        %>
        <tr>
            <td><%=u.get("userid")%></td>
            <td><%=u.get("username")%></td>
            <td><%=u.get("sex")%></td>
            <td>
                <form action="index.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="userid" value="<%=u.get("userid")%>">
                    <input type="submit" value="删除" onclick="return confirm('确定删除？')">
                </form>
            </td>
        </tr>
        <%
                }
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='4'>错误：" + e.getMessage() + "</td></tr>");
        }
        %>
    </table>

    <h3>修改用户</h3>
    <form action="index.jsp" method="post">
        <input type="hidden" name="action" value="update">
        <p>用户ID：<input type="text" name="userid"></p>
        <p>用户名：<input type="text" name="username"></p>
        <p>性别：<input type="text" name="sex"></p>
        <p><input type="submit" value="修改"></p>
    </form>
</body>
</html>
