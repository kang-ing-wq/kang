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

@WebServlet("/userAdd")
public class UserAddServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String sex = request.getParameter("sex");
        Integer age = Integer.parseInt(request.getParameter("age"));
        String email = request.getParameter("email");

        // 封装User对象
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setSex(sex);
        user.setAge(age);
        user.setEmail(email);
        user.setUserTitle("藏书阁弟子");
        user.setAvatarPath("/images/default-avatar.png");

        try {
            // 用户名查重
            User existUser = usersDao.findUserByUsername(username);
            if (existUser != null) {
                request.setAttribute("errorMsg", "该用户名已存在");
                request.getRequestDispatcher("/userAdd.jsp").forward(request, response);
                return;
            }

            usersDao.addUser(user);
            response.sendRedirect(request.getContextPath() + "/usersList");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "新增人员失败");
            request.getRequestDispatcher("/userAdd.jsp").forward(request, response);
        }
    }
}