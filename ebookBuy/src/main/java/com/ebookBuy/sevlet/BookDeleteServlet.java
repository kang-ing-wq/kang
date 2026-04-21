package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/bookDelete")
public class BookDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Long bookId = Long.parseLong(request.getParameter("id"));

        BookManageDao bookDao = new BookManageDao();
        try {
            // 捕获Dao方法抛出的受检异常
            bookDao.deleteBook(bookId);
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        // 删除完成跳回藏书阁
        response.sendRedirect(request.getContextPath() + "/tushuguan");
    }
}