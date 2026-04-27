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
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ebookBuy.pojo.Book;

@WebServlet("/bookManage")
public class BookManageServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/ebook2?useSSL=false&serverTimezone=UTC&characterEncoding=utf-8";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("===== 典籍管理Servlet被访问了 =====");
        request.setCharacterEncoding("UTF-8");
        List<Book> bookList = new ArrayList<>();

        // 1. 接收前端参数：搜索、筛选、排序
        String keyword = request.getParameter("keyword");
        String typeIdStr = request.getParameter("typeId");
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");

        // 2. 排序参数白名单校验（防止SQL注入）
        // 只允许按id排序，排序方向只能是asc/desc
        if (sortField == null || !sortField.equals("id")) {
            sortField = "id";
        }
        if (sortOrder == null || (!sortOrder.equalsIgnoreCase("asc") && !sortOrder.equalsIgnoreCase("desc"))) {
            sortOrder = "desc";
        }

        // 3. 动态拼接SQL：搜索+筛选+排序
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM book WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // 关键词搜索：书名/作者
        if (keyword != null && !keyword.trim().isEmpty()) {
            sqlBuilder.append(" AND (book_title LIKE ? OR book_author LIKE ?)");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }

        // 分类筛选
        if (typeIdStr != null && !typeIdStr.trim().isEmpty()) {
            try {
                int typeId = Integer.parseInt(typeIdStr.trim());
                sqlBuilder.append(" AND type_id = ?");
                params.add(typeId);
            } catch (NumberFormatException ignored) {}
        }

        // 排序逻辑
        sqlBuilder.append(" ORDER BY ").append(sortField).append(" ").append(sortOrder);

        // 4. 执行SQL查询
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            ps = conn.prepareStatement(sqlBuilder.toString());
            // 给SQL设置参数
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();

            // 封装书籍数据
            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setBookTitle(rs.getString("book_title"));
                book.setBookAuthor(rs.getString("book_author"));
                book.setBookSummary(rs.getString("book_summary"));
                book.setTypeId(rs.getInt("type_id"));
                book.setBookPubYear(rs.getString("book_pubYear"));
                book.setDownloadTimes(rs.getInt("download_times"));
                book.setBookFormat(rs.getString("book_format"));
                book.setPrice(rs.getDouble("price"));
                book.setBookFile(rs.getString("book_file"));
                book.setBookCover(rs.getString("book_cover"));

                bookList.add(book);
                System.out.println("查询到书籍：" + book.getBookTitle() + " | ID：" + book.getId());
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 5. 把参数回传到JSP，保留搜索状态
        System.out.println("===== 查询到书籍总数：" + bookList.size() + " | 排序方式：" + sortField + " " + sortOrder + " =====");
        request.setAttribute("bookList", bookList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("typeId", typeIdStr);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);

        // 转发到JSP
        request.getRequestDispatcher("/bookManage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}