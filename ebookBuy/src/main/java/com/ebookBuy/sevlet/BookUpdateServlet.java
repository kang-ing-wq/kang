package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.pojo.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/bookUpdate")
public class BookUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 接收ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("bookManage");
            return;
        }
        int bookId = Integer.parseInt(idStr);

        Book book = new Book();
        book.setId(bookId);
        book.setBookTitle(request.getParameter("bookTitle"));
        book.setBookAuthor(request.getParameter("bookAuthor"));
        book.setBookSummary(request.getParameter("bookSummary"));

        // 【核心】处理多类型ID
        String typeIdsStr = request.getParameter("typeIds");
        List<Integer> typeIds = new ArrayList<>();
        if (typeIdsStr != null && !typeIdsStr.trim().isEmpty()) {
            try {
                String[] arr = typeIdsStr.split(",");
                for (String s : arr) {
                    typeIds.add(Integer.parseInt(s.trim()));
                }
            } catch (NumberFormatException ignored) {}
        }
        book.setTypeIds(typeIds);

        // 【新增】处理主题字符串
        String themeNames = request.getParameter("themeNames");
        if (themeNames == null) themeNames = request.getParameter("themes"); // 兼容不同参数名
        book.setThemes(themeNames != null ? themeNames.trim() : "");

        // 其他字段
        book.setPrice(Double.parseDouble(request.getParameter("price")));
        book.setDownloadTimes(Integer.parseInt(request.getParameter("downloadTimes")));
        book.setBookPubYear(request.getParameter("bookPubYear"));
        book.setBookFile(request.getParameter("bookFile"));
        book.setBookCover(request.getParameter("bookCover"));
        book.setBookFormat(request.getParameter("bookFormat"));
        book.setStock(999);
        book.setIsSale(1);
        book.setTryReadChapter(1);

        // 执行更新
        BookManageDao bookDao = new BookManageDao();
        try {
            bookDao.updateBook(book);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("bookManage");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}