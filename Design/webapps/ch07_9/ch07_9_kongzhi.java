package com.example;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ch07_9_kongzhi extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        User user = new User();
        user.setUsername(username);
        user.setUserpassword(userpassword);

        ConnectDbase connectDbase = new ConnectDbase();
        boolean loginSuccess = connectDbase.yanzheng_uesr(user);

        request.setAttribute("user", user);
        request.setAttribute("loginSuccess", loginSuccess);

        if (loginSuccess) {
            request.getRequestDispatcher("/ch07_9/ch07_9_Success.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/ch07_9/ch07_9_error.jsp").forward(request, response);
        }
    }
}
