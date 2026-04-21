package com.ebookBuy.sevlet;

import com.alibaba.fastjson.JSON;
import com.ebookBuy.dao.ChapterDao;
import com.ebookBuy.dao.UserBookDao;
import com.ebookBuy.pojo.Chapter;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/bookContent")
public class BookContentServlet extends HttpServlet {

    private final ChapterDao chapterDao = new ChapterDao();
    private final UserBookDao userBookDao = new UserBookDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        String bookIdStr = request.getParameter("bookId");
        Map<String, Object> result = new HashMap<>();

        // 【核心修复1】先获取session和登录用户，避免空指针
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        try {
            // ================== 1. 基础参数校验 ==================
            if (action == null || action.trim().isEmpty()) {
                result.put("code", 400);
                result.put("msg", "请求参数错误：action不能为空");
                response.getWriter().write(JSON.toJSONString(result));
                return;
            }

            // 所有需要bookId的操作，先校验bookId格式
            Integer bookId = null;
            if ("list".equals(action) || "content".equals(action)) {
                if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
                    result.put("code", 400);
                    result.put("msg", "请求参数错误：bookId不能为空");
                    response.getWriter().write(JSON.toJSONString(result));
                    return;
                }
                try {
                    bookId = Integer.parseInt(bookIdStr.trim());
                } catch (NumberFormatException e) {
                    result.put("code", 400);
                    result.put("msg", "请求参数错误：bookId格式不正确");
                    response.getWriter().write(JSON.toJSONString(result));
                    return;
                }
            }

            // ================== 2. 登录与权限校验（仅需要bookId的操作） ==================
            if (bookId != null) {
                // 未登录直接拦截
                if (loginUser == null) {
                    result.put("code", 401);
                    result.put("msg", "道友请先登录，方可阅读典籍！");
                    response.getWriter().write(JSON.toJSONString(result));
                    return;
                }
                // 校验是否已购买解锁
                boolean hasAuth = userBookDao.checkUserHasBook(loginUser.getId(), bookId);
                if (!hasAuth) {
                    result.put("code", 403);
                    result.put("msg", "您尚未解锁此典籍，请先前往请购缔结道契！");
                    response.getWriter().write(JSON.toJSONString(result));
                    return;
                }
            }

            // ================== 3. 原有业务逻辑（完全保留，无修改） ==================
            if ("list".equals(action)) {
                List<Chapter> chapterList = chapterDao.findChapterListByBookId(bookId);
                result.put("code", 200);
                result.put("data", chapterList);
                result.put("msg", "获取成功");
            } else if ("content".equals(action)) {
                String chapterNumStr = request.getParameter("chapterNum");
                if (chapterNumStr == null || chapterNumStr.trim().isEmpty()) {
                    result.put("code", 400);
                    result.put("msg", "章节序号不能为空");
                } else {
                    Integer chapterNum = Integer.parseInt(chapterNumStr.trim());
                    Chapter chapter = chapterDao.findChapterContent(bookId, chapterNum);
                    if (chapter != null) {
                        result.put("code", 200);
                        result.put("data", chapter);
                        result.put("msg", "获取成功");
                        // 阅读成功后更新阅读进度
                        userBookDao.updateReadProgress(loginUser.getId(), bookId, chapterNum);
                    } else {
                        result.put("code", 404);
                        result.put("msg", "章节内容不存在");
                    }
                }
            } else {
                result.put("code", 400);
                result.put("msg", "不支持的action类型");
            }

        } catch (Exception e) {
            // 【核心修复2】详细打印异常到控制台，方便你排查问题
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "系统异常：" + e.getMessage());
        }

        // 最终返回结果
        response.getWriter().write(JSON.toJSONString(result));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}