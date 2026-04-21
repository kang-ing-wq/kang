package com.ebookBuy.sevlet;

import com.ebookBuy.dao.UsersDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/userDelete")
public class UserDeleteServlet extends HttpServlet {
    private final UsersDao usersDao = new UsersDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/usersList");
            return;
        }

        try {
            usersDao.deleteUserById(id);
            response.sendRedirect(request.getContextPath() + "/usersList");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/usersList");
        }
    }
}