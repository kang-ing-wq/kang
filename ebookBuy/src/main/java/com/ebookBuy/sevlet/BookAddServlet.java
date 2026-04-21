package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.pojo.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/bookAdd")
public class BookAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 接收表单参数
        Book book = new Book();
        book.setBookTitle(request.getParameter("bookTitle"));
        book.setBookAuthor(request.getParameter("bookAuthor"));
        book.setBookSummary(request.getParameter("bookSummary"));
        book.setTypeId(Integer.parseInt(request.getParameter("typeId")));
        book.setDownloadTimes(Integer.parseInt(request.getParameter("downloadTimes")));
        book.setBookPubYear(String.valueOf(Date.valueOf(request.getParameter("bookPubYear"))));
        book.setBookFile(request.getParameter("bookFile"));
        book.setBookCover(request.getParameter("bookCover"));
        book.setBookFormat(request.getParameter("bookFormat"));

        BookManageDao bookDao = new BookManageDao();
        try {
            bookDao.addBook(book);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        // 新增完成跳回藏书阁
        response.sendRedirect(request.getContextPath() + "/tushuguan");
    }
}