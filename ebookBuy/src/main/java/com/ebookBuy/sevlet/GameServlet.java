package com.ebookBuy.sevlet;

import com.ebookBuy.dao.GameDao;
import com.ebookBuy.pojo.GameProgress;
import com.ebookBuy.pojo.GameStory;
import com.ebookBuy.pojo.User;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/game")
public class GameServlet extends HttpServlet {

    private GameDao gameDao = new GameDao();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        request.setAttribute("bookId", bookId);
        request.getRequestDispatcher("/game.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loginUser");
        JsonObject result = new JsonObject();

        if (user == null) {
            result.addProperty("code", 401);
            result.addProperty("msg", "请先登录");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("start".equals(action)) {
                handleStart(request, user, result);
            } else if ("restart".equals(action)) {
                handleRestart(request, user, result);
            } else if ("node".equals(action)) {
                handleGetNode(request, user, result);
            } else if ("choose".equals(action)) {
                handleChoose(request, user, result);
            } else if ("savelist".equals(action)) {
                handleSaveList(request, user, result);
            } else if ("jump".equals(action)) {
                handleJump(request, user, result);
            } else if ("map".equals(action)) {
                handleMap(request, user, result);
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

    private void handleStart(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        GameProgress progress = gameDao.getProgress(user.getId(), bookId);

        if (progress == null) {
            Map<String, Integer> defaultAttrs = new HashMap<>();
            defaultAttrs.put("拳意", 10);
            defaultAttrs.put("剑意", 0);
            defaultAttrs.put("体魄", 100);
            defaultAttrs.put("灵气", 50);
            defaultAttrs.put("气运", (int)(Math.random() * 10) + 1);
            defaultAttrs.put("境界", 1);

            GameStory startNode = gameDao.getStoryByNodeId(bookId, "1-1");
            Map<String, Integer> customAttrs = null;
            if (startNode != null && startNode.getRewards() != null && !startNode.getRewards().isEmpty()) {
                try {
                    customAttrs = gson.fromJson(startNode.getRewards(),
                            new TypeToken<Map<String, Integer>>(){}.getType());
                } catch (Exception e) {}
            }
            Map<String, Integer> finalAttrs = new HashMap<>(defaultAttrs);
            if (customAttrs != null) finalAttrs.putAll(customAttrs);

            progress = new GameProgress();
            progress.setUserId(user.getId());
            progress.setBookId(bookId);
            progress.setCurrentNode("1-1");
            progress.setPlayerAttrs(gson.toJson(finalAttrs));
            progress.setChoicesHistory("[]");
            progress.setGameStatus(1);
            gameDao.saveProgress(progress);
        }

        String bookTitle = gameDao.getBookTitleById(bookId);
        result.addProperty("bookTitle", bookTitle != null ? bookTitle : "未知典籍");
        result.addProperty("code", 200);
        result.add("playerAttrs", gson.toJsonTree(
                gson.fromJson(progress.getPlayerAttrs(), Map.class)));
        result.addProperty("currentNode", progress.getCurrentNode());

        GameStory story = gameDao.getStoryByNodeId(bookId, progress.getCurrentNode());
        if (story != null) {
            result.addProperty("storyText", story.getStoryText());
            result.addProperty("options", story.getOptions());
            result.addProperty("nodeTitle", story.getNodeTitle());
        } else {
            result.addProperty("storyText", "暂无剧情，请联系管理员添加节点。");
            result.addProperty("options", "[]");
        }
    }

    private void handleRestart(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        gameDao.deleteProgress(user.getId(), bookId);
        handleStart(request, user, result);
    }

    private void handleGetNode(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        GameProgress progress = gameDao.getProgress(user.getId(), bookId);
        if (progress == null) {
            result.addProperty("code", 404);
            result.addProperty("msg", "没有游戏进度");
            return;
        }
        GameStory story = gameDao.getStoryByNodeId(bookId, progress.getCurrentNode());
        result.addProperty("code", 200);
        result.addProperty("storyText", story != null ? story.getStoryText() : "剧情缺失");
        result.addProperty("options", story != null ? story.getOptions() : "[]");
        result.addProperty("currentNode", progress.getCurrentNode());
        result.add("playerAttrs", gson.toJsonTree(
                gson.fromJson(progress.getPlayerAttrs(), Map.class)));
        String bookTitle = gameDao.getBookTitleById(bookId);
        result.addProperty("bookTitle", bookTitle != null ? bookTitle : "未知典籍");
    }

    private void handleChoose(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String targetNode = request.getParameter("targetNode");
        GameProgress progress = gameDao.getProgress(user.getId(), bookId);
        if (progress == null) {
            result.addProperty("code", 404);
            result.addProperty("msg", "游戏进度丢失");
            return;
        }

        GameStory targetStory = gameDao.getStoryByNodeId(bookId, targetNode);
        Map<String, Integer> attrs = gson.fromJson(progress.getPlayerAttrs(),
                new TypeToken<Map<String, Integer>>(){}.getType());
        if (targetStory != null && targetStory.getRewards() != null
                && !targetStory.getRewards().isEmpty()) {
            Map<String, Integer> rewards = gson.fromJson(targetStory.getRewards(),
                    new TypeToken<Map<String, Integer>>(){}.getType());
            for (String key : rewards.keySet()) {
                attrs.put(key, attrs.getOrDefault(key, 0) + rewards.get(key));
            }
        }

        progress.setCurrentNode(targetNode);
        progress.setPlayerAttrs(gson.toJson(attrs));
        gameDao.saveProgress(progress);

        GameStory nextStory = gameDao.getStoryByNodeId(bookId, targetNode);
        String bookTitle = gameDao.getBookTitleById(bookId);
        result.addProperty("bookTitle", bookTitle != null ? bookTitle : "未知典籍");
        result.addProperty("code", 200);
        result.addProperty("storyText", nextStory != null ? nextStory.getStoryText() : "剧情缺失");
        result.addProperty("options", nextStory != null ? nextStory.getOptions() : "[]");
        result.addProperty("nodeTitle", nextStory != null ? nextStory.getNodeTitle() : "");
        result.add("playerAttrs", gson.toJsonTree(attrs));
        result.addProperty("currentNode", targetNode);
    }

    private void handleSaveList(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        List<GameStory> allNodes = gameDao.getStoryNodesByBookId(bookId);
        List<Map<String, Object>> savePoints = new ArrayList<>();
        for (GameStory node : allNodes) {
            String req = node.getRequirements();
            if (req != null && req.contains("\"save\":true")) {
                Map<String, Object> sp = new HashMap<>();
                sp.put("nodeId", node.getNodeId());
                sp.put("nodeTitle", node.getNodeTitle());
                savePoints.add(sp);
            }
        }
        result.addProperty("code", 200);
        result.add("data", gson.toJsonTree(savePoints));
    }

    private void handleJump(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String targetNode = request.getParameter("targetNode");
        GameProgress progress = gameDao.getProgress(user.getId(), bookId);
        if (progress == null) {
            result.addProperty("code", 404);
            result.addProperty("msg", "没有游戏进度");
            return;
        }
        GameStory targetStory = gameDao.getStoryByNodeId(bookId, targetNode);
        if (targetStory == null) {
            result.addProperty("code", 400);
            result.addProperty("msg", "目标节点不存在");
            return;
        }
        progress.setCurrentNode(targetNode);
        gameDao.saveProgress(progress);
        GameStory nextStory = gameDao.getStoryByNodeId(bookId, targetNode);
        String bookTitle = gameDao.getBookTitleById(bookId);
        result.addProperty("bookTitle", bookTitle != null ? bookTitle : "未知典籍");
        result.addProperty("code", 200);
        result.addProperty("storyText", nextStory.getStoryText());
        result.addProperty("options", nextStory.getOptions());
        result.addProperty("nodeTitle", nextStory.getNodeTitle());
        result.add("playerAttrs", gson.toJsonTree(
                gson.fromJson(progress.getPlayerAttrs(), Map.class)));
        result.addProperty("currentNode", targetNode);
    }

    private void handleMap(HttpServletRequest request, User user, JsonObject result) throws Exception {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        List<GameStory> allNodes = gameDao.getStoryNodesByBookId(bookId);
        List<Map<String, Object>> nodes = new ArrayList<>();
        for (GameStory node : allNodes) {
            Map<String, Object> nodeMap = new HashMap<>();
            nodeMap.put("id", node.getNodeId());
            nodeMap.put("title", node.getNodeTitle());
            nodeMap.put("options", node.getOptions());
            // 新增章节ID（可能为 null）
            nodeMap.put("chapterId", node.getChapterId());
            nodes.add(nodeMap);
        }
        result.addProperty("code", 200);
        result.add("data", gson.toJsonTree(nodes));
    }
    // ==================================
}