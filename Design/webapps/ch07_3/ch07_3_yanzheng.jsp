<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String userpassword = request.getParameter("userpassword");

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";
    String dbUser = "root";
    String dbPassword = "root_password";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
        String sql = "SELECT * FROM user_b WHERE username = ? AND userpassword = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, userpassword);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            out.println("登录成功");
        } else {
            out.println("登录失败");
        }
    } catch (Exception e) {
        out.println("错误: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>
<br><a href="ch07_3_tijiao.jsp">返回</a>
