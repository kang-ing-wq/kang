package com.ebookBuy.sevlet;

import com.ebookBuy.dao.ChapterDao;
import com.ebookBuy.pojo.Chapter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/chapterAdd")
public class ChapterAddServlet extends HttpServlet {

    // 只用你现有的ChapterDao，不需要BookDao
    private final ChapterDao chapterDao = new ChapterDao();

    // 打开录入页面，加载所有书籍到下拉框
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 直接用ChapterDao里的方法查询所有书籍
            request.setAttribute("bookList", chapterDao.getAllBookList());
            // 跳转到录入页面
            request.getRequestDispatcher("/chapterAdd.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // 出错了就回藏书阁
            response.sendRedirect(request.getContextPath() + "/tushuguan");
        }
    }

    // 处理章节录入提交
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. 获取表单参数
        Long bookId = Long.parseLong(request.getParameter("bookId"));
        Integer chapterNum = Integer.parseInt(request.getParameter("chapterNum"));
        String chapterTitle = request.getParameter("chapterTitle");
        String chapterContent = request.getParameter("chapterContent");

        // 2. 封装Chapter对象
        Chapter chapter = new Chapter();
        chapter.setBookId(bookId);
        chapter.setChapterNum(chapterNum);
        chapter.setChapterTitle(chapterTitle);
        chapter.setChapterContent(chapterContent);

        try {
            // 3. 调用Dao保存到数据库
            chapterDao.addChapter(chapter);
            // 4. 录入成功，跳回藏书阁
            response.sendRedirect(request.getContextPath() + "/tushuguan");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // 5. 录入失败，返回录入页重试
            response.sendRedirect(request.getContextPath() + "/chapterAdd");
        }
    }
}