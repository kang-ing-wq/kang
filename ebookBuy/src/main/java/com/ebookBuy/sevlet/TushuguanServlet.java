package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.pojo.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/tushuguan")
public class TushuguanServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookManageDao bookDao = new BookManageDao();
        List<Book> bookList;

        // 获取分类参数，无参数则查全部
        String typeIdStr = request.getParameter("typeId");
        // 修正：原来的!isEmpty()写反了，现在是：有值且不为空才走分类查询
        if (typeIdStr != null && !typeIdStr.isEmpty()) {
            int typeId = Integer.parseInt(typeIdStr);
            try {
                bookList = bookDao.getBooksByTypeId(typeId);
            } catch (SQLException | ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
            request.setAttribute("currentTypeId", typeId);
        } else {
            try {
                bookList = bookDao.getAllBooks();
            } catch (SQLException | ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
        }

        request.setAttribute("bookList", bookList);
        request.getRequestDispatcher("/tushuguan.jsp").forward(request, response);
    }
}