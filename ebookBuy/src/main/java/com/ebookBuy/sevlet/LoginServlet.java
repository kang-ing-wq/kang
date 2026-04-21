package com.ebookBuy.sevlet;

import com.ebookBuy.dao.UsersDao;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User loginUser = usersDao.findUserByUsernameAndPwd(username, password);
            if (loginUser != null) {
                // 登录成功，把用户信息存入Session
                HttpSession session = request.getSession();
                session.setAttribute("loginUser", loginUser);
                session.setMaxInactiveInterval(30 * 60); // 30分钟过期
                // 跳回藏书阁主页面
                response.sendRedirect(request.getContextPath() + "/tushuguan");
            } else {
                // 登录失败，返回登录页，带错误提示
                request.setAttribute("errorMsg", "用户名或密码错误");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "系统异常，请稍后重试");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}