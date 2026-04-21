package com.ebookBuy.sevlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 销毁Session，退出登录
        HttpSession session = request.getSession();
        session.invalidate();
        // 跳回藏书阁主页面
        response.sendRedirect(request.getContextPath() + "/tushuguan");
    }
}