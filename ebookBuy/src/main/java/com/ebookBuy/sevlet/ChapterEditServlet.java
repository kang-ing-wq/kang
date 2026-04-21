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

@WebServlet("/chapterEdit")
public class ChapterEditServlet extends HttpServlet {

    private final ChapterDao chapterDao = new ChapterDao();

    // 打开编辑页面，加载要修改的章节内容
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String chapterIdStr = request.getParameter("chapterId");
        if (chapterIdStr == null || chapterIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/tushuguan");
            return;
        }

        try {
            Long chapterId = Long.parseLong(chapterIdStr);
            Chapter chapter = chapterDao.findChapterById(chapterId);
            if (chapter == null) {
                response.sendRedirect(request.getContextPath() + "/tushuguan");
                return;
            }
            request.setAttribute("chapter", chapter);
            request.getRequestDispatcher("/chapterEdit.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/tushuguan");
        }
    }

    // 处理章节修改提交
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 获取表单参数
        Long chapterId = Long.parseLong(request.getParameter("chapterId"));
        String chapterTitle = request.getParameter("chapterTitle");
        String chapterContent = request.getParameter("chapterContent");

        // 封装Chapter对象
        Chapter chapter = new Chapter();
        chapter.setId(chapterId);
        chapter.setChapterTitle(chapterTitle);
        chapter.setChapterContent(chapterContent);

        try {
            // 调用Dao修改章节
            chapterDao.updateChapter(chapter);
            // 修改成功，跳回藏书阁
            response.sendRedirect(request.getContextPath() + "/tushuguan");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // 修改失败，返回编辑页
            response.sendRedirect(request.getContextPath() + "/chapterEdit?chapterId=" + chapterId);
        }
    }
}