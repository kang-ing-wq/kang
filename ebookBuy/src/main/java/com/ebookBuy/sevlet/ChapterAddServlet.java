package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.dao.ChapterDao;
import com.ebookBuy.pojo.Book;
import com.ebookBuy.pojo.Chapter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/chapterAdd")
public class ChapterAddServlet extends HttpServlet {
    // 【修复1：正确初始化Dao，章节用ChapterDao，书籍用BookManageDao】
    private final ChapterDao chapterDao = new ChapterDao();
    private final BookManageDao bookManageDao = new BookManageDao();

    // 打开录入页面，加载所有书籍到下拉框
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 【修复2：用BookManageDao查询所有书籍，不是ChapterDao】
            List<Book> bookList = bookManageDao.findAllBook();
            request.setAttribute("bookList", bookList);
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

        try {
            // 接收表单参数
            Long bookId = Long.parseLong(request.getParameter("bookId"));
            Integer chapterNum = Integer.parseInt(request.getParameter("chapterNum"));
            String chapterTitle = request.getParameter("chapterTitle");
            String chapterContent = request.getParameter("chapterContent");

            // 封装Chapter对象
            Chapter chapter = new Chapter();
            chapter.setBookId(bookId);
            chapter.setChapterNum(chapterNum);
            chapter.setChapterTitle(chapterTitle);
            chapter.setChapterContent(chapterContent);

            // 调用Dao新增章节
            chapterDao.addChapter(chapter);

            // 录入成功，跳回录入页面，可继续录入
            request.setAttribute("msg", "章节录入成功！可继续录入下一章");
            List<Book> bookList = bookManageDao.findAllBook();
            request.setAttribute("bookList", bookList);
            request.getRequestDispatcher("/chapterAdd.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("msg", "参数格式错误，典籍ID、章节号必须是数字");
            request.getRequestDispatcher("/chapterAdd.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("msg", "章节录入失败：" + e.getMessage());
            request.getRequestDispatcher("/chapterAdd.jsp").forward(request, response);
        }
    }
}