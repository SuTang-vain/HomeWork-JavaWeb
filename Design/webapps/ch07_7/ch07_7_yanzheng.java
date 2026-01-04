package com.example;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ch07_7_yanzheng extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String driver = "com.mysql.cj.jdbc.Driver";
    private String url = "jdbc:mysql://mysql-db:3306/user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";
    private String dbUser = "root";
    private String dbPassword = "root_password";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String username = request.getParameter("username");
        String userpassword = request.getParameter("userpassword");

        boolean loginSuccess = validateUser(username, userpassword);
        request.setAttribute("username", username);

        if (loginSuccess) {
            request.getRequestDispatcher("/ch07_7/ch07_7_Success.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/ch07_7/ch07_7_error.jsp").forward(request, response);
        }
    }

    private boolean validateUser(String username, String userpassword) {
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
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
    }
}
