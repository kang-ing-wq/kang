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
import java.util.List;

@WebServlet("/usersList")
public class UserListServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<User> userList = usersDao.findAllUsers();
            request.setAttribute("userList", userList);
            request.getRequestDispatcher("/usersList.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "加载人员列表失败");
            request.getRequestDispatcher("/zongmen.jsp").forward(request, response);
        }
    }
}