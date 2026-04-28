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

@WebServlet("/bookAdd")
public class BookAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        Book book = new Book();

        // 1. 基础字段
        book.setBookTitle(request.getParameter("bookTitle"));
        book.setBookAuthor(request.getParameter("bookAuthor"));
        book.setBookSummary(request.getParameter("bookSummary"));

        // 2. 分类ID（容错）
        String typeIdStr = request.getParameter("typeId");
        book.setTypeId((typeIdStr != null && !typeIdStr.isEmpty()) ? Integer.parseInt(typeIdStr) : 1);

        // 3. 价格（核心修复：必须接收）
        String priceStr = request.getParameter("price");
        book.setPrice((priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0.00);

        // 4. 传阅次数
        String downloadTimesStr = request.getParameter("downloadTimes");
        book.setDownloadTimes((downloadTimesStr != null && !downloadTimesStr.isEmpty()) ? Integer.parseInt(downloadTimesStr) : 0);

        // 5. 出版年份
        String pubYearStr = request.getParameter("bookPubYear");
        if (pubYearStr != null && !pubYearStr.isEmpty()) {
            book.setBookPubYear(String.valueOf(Date.valueOf(pubYearStr)));
        }

        // 6. 文件与封面
        book.setBookFile(request.getParameter("bookFile"));
        book.setBookCover(request.getParameter("bookCover"));
        book.setBookFormat(request.getParameter("bookFormat"));

        // 7. 新增：Dao需要的售卖字段（给默认值，防止报错）
        book.setStock(999);      // 默认库存999
        book.setIsSale(1);        // 默认上架(1上架/0下架)
        book.setTryReadChapter(1); // 默认试读第1章

        // 执行插入
        BookManageDao bookDao = new BookManageDao();
        try {
            bookDao.addBook(book);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('录入失败：" + e.getMessage() + "');history.back();</script>");
            return;
        }

        // 跳回管理页（修正了之前的路径错误）
        response.sendRedirect(request.getContextPath() + "/bookManage");
    }
}