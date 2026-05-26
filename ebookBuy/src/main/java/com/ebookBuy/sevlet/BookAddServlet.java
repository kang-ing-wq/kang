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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/bookAdd")
public class BookAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ✅ 第一步：先校验必须字段
        String typeIdsStr = request.getParameter("typeIds");
        if (typeIdsStr == null || typeIdsStr.trim().isEmpty()) {
            response.getWriter().println("<script>alert('请至少选择一个典籍类型！');history.back();</script>");
            return;
        }

        Book book = new Book();

        // 基础字段
        book.setBookTitle(request.getParameter("bookTitle"));
        book.setBookAuthor(request.getParameter("bookAuthor"));
        book.setBookSummary(request.getParameter("bookSummary"));

        // 处理多类型ID
        List<Integer> typeIds = new ArrayList<>();
        try {
            String[] arr = typeIdsStr.split(",");
            for (String s : arr) {
                typeIds.add(Integer.parseInt(s.trim()));
            }
        } catch (NumberFormatException e) {
            response.getWriter().println("<script>alert('类型参数错误！');history.back();</script>");
            return;
        }
        book.setTypeIds(typeIds);

        // 处理主题字符串
        String themeNames = request.getParameter("themeNames");
        book.setThemes(themeNames != null ? themeNames.trim() : "");

        // 其他字段
        String priceStr = request.getParameter("price");
        book.setPrice((priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0.00);
        String downloadTimesStr = request.getParameter("downloadTimes");
        book.setDownloadTimes((downloadTimesStr != null && !downloadTimesStr.isEmpty()) ? Integer.parseInt(downloadTimesStr) : 0);
        String pubYearStr = request.getParameter("bookPubYear");
        if (pubYearStr != null && !pubYearStr.isEmpty()) {
            book.setBookPubYear(String.valueOf(Date.valueOf(pubYearStr)));
        }
        book.setBookFile(request.getParameter("bookFile"));
        book.setBookCover(request.getParameter("bookCover"));
        book.setBookFormat(request.getParameter("bookFormat"));
        book.setStock(999);
        book.setIsSale(1);
        book.setTryReadChapter(1);

        // 执行插入
        BookManageDao bookDao = new BookManageDao();
        try {
            bookDao.addBook(book);
        } catch (Exception e) {
            e.printStackTrace();
            // ✅ 转义异常信息中的单引号，防止JS语法错误
            String errorMsg = e.getMessage().replace("'", "\\'");
            response.getWriter().println("<script>alert('录入失败：" + errorMsg + "');history.back();</script>");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/bookManage");
    }
}