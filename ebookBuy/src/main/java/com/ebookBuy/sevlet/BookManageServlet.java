package com.ebookBuy.sevlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.pojo.Book;

@WebServlet("/bookManage")
public class BookManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        BookManageDao bookDao = new BookManageDao();

        // 1. 接收参数
        String keyword = request.getParameter("keyword");
        String author = request.getParameter("author"); // ✅ 新增：接收作者搜索参数
        String typeIdsStr = request.getParameter("typeIds");
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");
        String themeNames = request.getParameter("themeNames");

        // 2. 解析多类型ID
        List<Integer> typeIds = new ArrayList<>();
        if (typeIdsStr != null && !typeIdsStr.trim().isEmpty()) {
            try {
                String[] arr = typeIdsStr.split(",");
                for (String s : arr) {
                    if (!s.trim().isEmpty()) typeIds.add(Integer.parseInt(s.trim()));
                }
            } catch (NumberFormatException ignored) {}
        }

        // 3. 排序校验
        if (sortField == null || !sortField.equals("id")) sortField = "id";
        if (sortOrder == null || (!sortOrder.equalsIgnoreCase("asc") && !sortOrder.equalsIgnoreCase("desc"))) sortOrder = "desc";

        // 4. 查询书籍列表（✅ 新增author参数传递给Dao）
        List<Book> bookList = new ArrayList<>();
        try {
            bookList = bookDao.getBookList(keyword, author, typeIds, themeNames, sortField, sortOrder);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "查询失败：" + e.getMessage());
        }

        // 5. 回传数据（✅ 新增author回显到页面）
        request.setAttribute("bookList", bookList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("author", author);
        request.setAttribute("typeIds", typeIdsStr);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("themeNames", themeNames);

        request.getRequestDispatcher("/bookManage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}