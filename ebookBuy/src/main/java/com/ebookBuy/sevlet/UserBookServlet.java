package com.ebookBuy.sevlet;

import com.ebookBuy.dao.UserBookDao;
import com.ebookBuy.pojo.Book;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/userBook")
public class UserBookServlet extends HttpServlet {
    private final UserBookDao userBookDao = new UserBookDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 先清空之前残留的错误信息
        HttpSession session = request.getSession();
        session.removeAttribute("msg");
        request.removeAttribute("msg");

        // 1. 登录强校验
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            session.setAttribute("msg", "道友请先登录，方可查看私人藏经阁！");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 2. 查询私人藏经阁列表
            List<Book> bookList = userBookDao.getUserBookList(loginUser.getId());
            request.setAttribute("bookList", bookList);
            // 3. 永远转发到当前页面，不跳其他页面
            request.getRequestDispatcher("/userBook.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // 异常信息只存在request里，刷新页面就消失，不会残留
            request.setAttribute("msg", "藏经阁加载失败：" + e.getMessage());
            request.setAttribute("bookList", null);
            request.getRequestDispatcher("/userBook.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}