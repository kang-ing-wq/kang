package com.ebookBuy.sevlet;

import com.ebookBuy.dao.GameDao;
import com.ebookBuy.pojo.GameStory;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/gameManage")
public class GameManageServlet extends HttpServlet {

    private GameDao gameDao = new GameDao();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 主要用于跳转到管理页面（带数据）
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            int bookId = Integer.parseInt(bookIdStr);
            try {
                List<GameStory> storyList = gameDao.getStoryNodesByBookId(bookId);
                request.setAttribute("storyList", storyList);
                request.setAttribute("bookId", bookId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/gameManage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        String action = request.getParameter("action");
        JsonObject result = new JsonObject();

        try {
            if ("add".equals(action)) {
                GameStory story = extractStoryFromRequest(request);
                gameDao.addStoryNode(story);
                result.addProperty("code", 200);
                result.addProperty("msg", "添加成功");
            } else if ("update".equals(action)) {
                GameStory story = extractStoryFromRequest(request);
                story.setId(Integer.parseInt(request.getParameter("id")));
                gameDao.updateStoryNode(story);
                result.addProperty("code", 200);
                result.addProperty("msg", "更新成功");
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                gameDao.deleteStoryNode(id);
                result.addProperty("code", 200);
                result.addProperty("msg", "删除成功");
            } else if ("list".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                List<GameStory> list = gameDao.getStoryNodesByBookId(bookId);
                result.addProperty("code", 200);
                result.add("data", gson.toJsonTree(list));
            } else {
                result.addProperty("code", 400);
                result.addProperty("msg", "未知操作");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("code", 500);
            result.addProperty("msg", "服务器错误: " + e.getMessage());
        }
        response.getWriter().write(gson.toJson(result));
    }

    private GameStory extractStoryFromRequest(HttpServletRequest request) {
        GameStory story = new GameStory();
        story.setBookId(Integer.parseInt(request.getParameter("bookId")));
        String chapterId = request.getParameter("chapterId");
        if (chapterId != null && !chapterId.isEmpty()) {
            story.setChapterId(Integer.parseInt(chapterId));
        }
        story.setNodeId(request.getParameter("nodeId"));
        story.setNodeTitle(request.getParameter("nodeTitle"));
        story.setStoryText(request.getParameter("storyText"));
        story.setOptions(request.getParameter("options"));
        story.setRequirements(request.getParameter("requirements"));
        story.setRewards(request.getParameter("rewards"));
        return story;
    }
}