package com.ebookBuy.sevlet;

import com.ebookBuy.dao.GameDao;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/gameList")
public class GameListServlet extends HttpServlet {

    private GameDao gameDao = new GameDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        try {
            List<Map<String, Object>> gameBooks = gameDao.getBooksWithGames();

            if (loginUser != null) {
                for (Map<String, Object> book : gameBooks) {
                    int bookId = (int) book.get("id");
                    try {
                        // 进度
                        var progress = gameDao.getProgress(loginUser.getId(), bookId);
                        if (progress == null) {
                            book.put("status", "未开始");
                        } else {
                            boolean finished = gameDao.isGameFinished(loginUser.getId(), bookId);
                            book.put("status", finished ? "已通关" : "进行中");
                        }

                        // 节点数量
                        int nodeCount = gameDao.getNodeCountByBookId(bookId);
                        book.put("nodeCount", nodeCount);

                        // 简介（取第一个剧情节点的前30字）
                        String firstText = gameDao.getFirstNodeTextByBookId(bookId);
                        if (firstText != null && firstText.length() > 30) {
                            firstText = firstText.substring(0, 30) + "...";
                        }
                        book.put("brief", firstText != null ? firstText : "暂无简介");

                    } catch (Exception e) {
                        book.put("status", "未知");
                        book.put("nodeCount", 0);
                        book.put("brief", "数据异常");
                    }
                }
            } else {
                for (Map<String, Object> book : gameBooks) {
                    book.put("status", "需登录");
                    book.put("nodeCount", "?");
                    book.put("brief", "登录后查看");
                }
            }
            request.setAttribute("gameBooks", gameBooks);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/gameList.jsp").forward(request, response);
    }
}