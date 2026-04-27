package com.ebookBuy.sevlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/bookUpdate")
public class BookUpdateServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/ebook2?useSSL=false&serverTimezone=UTC&characterEncoding=utf-8";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. 获取书籍ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("bookManage");
            return;
        }
        int bookId = Integer.parseInt(idStr);

        // 2. 获取表单所有参数
        String bookTitle = request.getParameter("bookTitle");
        String bookAuthor = request.getParameter("bookAuthor");
        String bookSummary = request.getParameter("bookSummary");
        String typeIdStr = request.getParameter("typeId");
        String priceStr = request.getParameter("price");
        String downloadTimesStr = request.getParameter("downloadTimes");
        // 【修复】和数据库字段名对应
        String bookPubYear = request.getParameter("bookPubYear");
        String bookFile = request.getParameter("bookFile");
        String bookCover = request.getParameter("bookCover");
        String bookFormat = request.getParameter("bookFormat");

        // 调试打印
        System.out.println("===== 接收到修改请求 =====");
        System.out.println("书籍ID：" + bookId);
        System.out.println("修改后的封面路径：" + bookCover);
        System.out.println("修改后的书名：" + bookTitle);

        // 类型转换
        int typeId = Integer.parseInt(typeIdStr);
        double price = Double.parseDouble(priceStr);
        int downloadTimes = Integer.parseInt(downloadTimesStr);

        // 数据库更新
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 【核心修复】SQL字段名改回你数据库里的 book_pubYear
            String sql = "UPDATE book SET " +
                    "book_title=?, book_author=?, book_summary=?, type_id=?, " +
                    "price=?, download_times=?, book_pubYear=?, " +
                    "book_file=?, book_cover=?, book_format=? " +
                    "WHERE id=?";

            ps = conn.prepareStatement(sql);

            // 参数顺序和SQL完全对应
            ps.setString(1, bookTitle);
            ps.setString(2, bookAuthor);
            ps.setString(3, bookSummary);
            ps.setInt(4, typeId);
            ps.setDouble(5, price);
            ps.setInt(6, downloadTimes);
            ps.setString(7, bookPubYear);
            ps.setString(8, bookFile);
            ps.setString(9, bookCover);
            ps.setString(10, bookFormat);
            ps.setInt(11, bookId);

            // 执行更新
            int updateRows = ps.executeUpdate();
            System.out.println("SQL执行结果，更新行数：" + updateRows);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 重定向回管理页，刷新最新数据
        response.sendRedirect("bookManage");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}