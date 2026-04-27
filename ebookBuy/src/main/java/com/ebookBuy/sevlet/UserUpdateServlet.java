package com.ebookBuy.sevlet;

import com.ebookBuy.dao.UsersDao;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/userUpdate")
public class UserUpdateServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    // 打开编辑页面
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/usersList");
            return;
        }

        try {
            User user = usersDao.findUserById(id);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/usersList");
                return;
            }
            request.setAttribute("user", user);
            request.getRequestDispatcher("/userUpdate.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/usersList");
        }
    }

    // 处理修改提交
    // 处理修改提交
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String sex = request.getParameter("sex");
        Integer age = Integer.parseInt(request.getParameter("age"));
        String email = request.getParameter("email");
        // 【新增】获取头像路径参数
        String avatarPath = request.getParameter("avatarPath");
        if (avatarPath == null || avatarPath.trim().isEmpty()) {
            avatarPath = "/images/default-avatar.png";
        }

        User user = new User();
        user.setId(id);
        user.setUsername(username);
        user.setPassword(password);
        user.setSex(sex);
        user.setAge(age);
        user.setEmail(email);
        // 【新增】设置头像路径
        user.setAvatarPath(avatarPath);

        try {
            usersDao.updateUser(user);
            response.sendRedirect(request.getContextPath() + "/usersList");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "修改人员信息失败");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/userUpdate.jsp").forward(request, response);
        }
    }
}