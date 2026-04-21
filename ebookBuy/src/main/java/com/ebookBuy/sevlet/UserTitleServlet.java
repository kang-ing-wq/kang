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

@WebServlet("/updateTitle")
public class UserTitleServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        // 未登录拦截
        if (loginUser == null) {
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"请先登录\"}");
            return;
        }

        // 获取新头衔
        String newTitle = request.getParameter("newTitle");
        if (newTitle == null || newTitle.trim().isEmpty()) {
            newTitle = "藏书阁弟子";
        }
        // 限制头衔长度
        if (newTitle.length() > 10) {
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write("{\"code\":400,\"msg\":\"头衔不能超过10个字\"}");
            return;
        }

        try {
            // 更新数据库，用String类型的id
            usersDao.updateUserTitle(loginUser.getId(), newTitle);
            // 更新Session里的用户信息
            loginUser.setUserTitle(newTitle);
            session.setAttribute("loginUser", loginUser);

            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write("{\"code\":200,\"msg\":\"头衔修改成功\"}");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().write("{\"code\":500,\"msg\":\"系统异常，请稍后重试\"}");
        }
    }
}