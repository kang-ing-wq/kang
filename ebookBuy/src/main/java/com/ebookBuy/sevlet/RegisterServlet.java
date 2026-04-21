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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. 获取表单所有参数（和你的register.jsp完全对应）
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String sex = request.getParameter("sex");
        Integer age = Integer.parseInt(request.getParameter("age"));
        String email = request.getParameter("email");

        // 2. 封装User对象
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setSex(sex);
        newUser.setAge(age);
        newUser.setEmail(email);
        newUser.setUserTitle("藏书阁弟子"); // 默认头衔
        newUser.setAvatarPath("/images/default-avatar.png"); // 默认头像

        try {
            // 3. 用户名重复校验
            User existUser = usersDao.findUserByUsername(username);
            if (existUser != null) {
                request.setAttribute("msg", "该道号已被占用，请更换");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 4. 执行注册，插入数据库
            usersDao.addUser(newUser);

            // 5. 注册成功，直接跳转到登录页（带成功提示）
            request.setAttribute("msg", "注册成功！请登录");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("msg", "系统异常，请稍后重试");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}