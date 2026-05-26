package com.ebookBuy.sevlet;

import com.alibaba.fastjson.JSON;
import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.dao.ChapterDao;
import com.ebookBuy.dao.UserBookDao;
import com.ebookBuy.dao.UsersDao;
import com.ebookBuy.pojo.Book;
import com.ebookBuy.pojo.Chapter;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/bookContent")
public class BookContentServlet extends HttpServlet {

    private final ChapterDao chapterDao = new ChapterDao();
    private final UserBookDao userBookDao = new UserBookDao();
    private final BookManageDao bookManageDao = new BookManageDao();
    private final UsersDao usersDao = new UsersDao(); // 新增：用户数据DAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        String bookIdStr = request.getParameter("bookId");
        Map<String, Object> result = new HashMap<>();

        // 获取session和登录用户
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
            if ("list".equals(action) || "content".equals(action) || "lastChapter".equals(action)) {
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

            // ================== 2. 【模块3新增】获取用户最后阅读章节 ==================
            if ("lastChapter".equals(action)) {
                if (loginUser == null) {
                    result.put("code", 401);
                    result.put("msg", "道友请先登录，方可同步阅读进度！");
                    response.getWriter().write(JSON.toJSONString(result));
                    return;
                }
                // 查询用户最后阅读的章节
                Integer lastChapter = userBookDao.getLastReadChapter(loginUser.getId(), bookId);
                result.put("code", 200);
                result.put("data", lastChapter);
                result.put("msg", "获取成功");
                response.getWriter().write(JSON.toJSONString(result));
                return;
            }

            // ================== 3. 权限分级控制 ==================
            boolean isLogin = loginUser != null;
            boolean hasBuy = false;
            int tryReadChapter = 1; // 默认试读1章

            // 先获取典籍的试读章节数
            Book book = bookManageDao.findBookById(Long.valueOf(bookId));
            if (book != null && book.getTryReadChapter() != null) {
                tryReadChapter = book.getTryReadChapter();
            }

            // 校验用户是否已购买
            if (isLogin) {
                hasBuy = userBookDao.checkUserHasBook(loginUser.getId(), bookId);
            }

            // 章节列表：所有人都能看（不拦截）
            if ("list".equals(action)) {
                List<Chapter> chapterList = chapterDao.findChapterListByBookId(bookId);
                result.put("code", 200);
                result.put("data", chapterList);
                result.put("msg", "获取成功");
                // 给前端返回权限信息
                result.put("hasBuy", hasBuy);
                result.put("tryReadChapter", tryReadChapter);
                // 【模块3新增】返回用户最后阅读章节
                if (isLogin) {
                    Integer lastChapter = userBookDao.getLastReadChapter(loginUser.getId(), bookId);
                    result.put("lastReadChapter", lastChapter);
                }
            }

            // 章节内容：分级控制
            else if ("content".equals(action)) {
                String chapterNumStr = request.getParameter("chapterNum");
                if (chapterNumStr == null || chapterNumStr.trim().isEmpty()) {
                    result.put("code", 400);
                    result.put("msg", "章节序号不能为空");
                } else {
                    Integer chapterNum = Integer.parseInt(chapterNumStr.trim());
                    int totalChapter = chapterDao.getChapterCountByBookId(bookId); // 【需补充】获取总章节数

                    // 【核心权限规则】
                    // 1. 已购买用户：无限制
                    if (hasBuy) {
                        Chapter chapter = chapterDao.findChapterContent(bookId, chapterNum);
                        if (chapter != null) {
                            result.put("code", 200);
                            result.put("data", chapter);
                            result.put("msg", "获取成功");
                            result.put("totalChapter", totalChapter);

                            // 【模块3核心：事务更新阅读进度+用户数据】
                            Connection conn = null;
                            try {
                                // 1. 先判断是否是首次阅读该典籍（最后阅读章节为0，且当前是第1章）
                                Integer lastChapter = userBookDao.getLastReadChapter(loginUser.getId(), bookId);
                                boolean isFirstRead = (lastChapter == 0 && chapterNum == 1);

                                // 2. 开启事务，统一更新
                                conn = new com.ebookBuy.db.DBManager().getConnection();
                                conn.setAutoCommit(false);

                                // 3. 更新阅读进度
                                userBookDao.updateReadProgressTx(conn, loginUser.getId(), bookId, chapterNum);
                                // 4. 更新用户阅读数据
                                usersDao.updateReadDataTx(conn, loginUser.getId(), isFirstRead);

                                // 5. 提交事务
                                conn.commit();

                                // 6. 更新session里的用户数据
                                loginUser.setReadChapterNum(loginUser.getReadChapterNum() + 1);
                                if (isFirstRead) {
                                    loginUser.setReadBookNum(loginUser.getReadBookNum() + 1);
                                }
                                session.setAttribute("loginUser", loginUser);

                            } catch (Exception e) {
                                if (conn != null) conn.rollback();
                                e.printStackTrace();
                            } finally {
                                if (conn != null) {
                                    conn.setAutoCommit(true);
                                    conn.close();
                                }
                            }

                        } else {
                            result.put("code", 404);
                            result.put("msg", "章节内容不存在");
                        }
                    }
                    // 2. 未购买/未登录用户：只能看试读章节
                    else {
                        // 超过试读章节，拦截
                        if (chapterNum > tryReadChapter) {
                            if (!isLogin) {
                                result.put("code", 401);
                                result.put("msg", "此章节超出试读范围，请先登录后，缔结道契解锁全本！");
                            } else {
                                result.put("code", 403);
                                result.put("msg", "此章节超出试读范围，请先缔结道契解锁全本内容！");
                            }
                        }
                        // 试读章节，允许访问
                        else {
                            Chapter chapter = chapterDao.findChapterContent(bookId, chapterNum);
                            if (chapter != null) {
                                result.put("code", 200);
                                result.put("data", chapter);
                                result.put("msg", "【试读章节】购买后可解锁全本内容");
                                result.put("totalChapter", totalChapter);
                                // 【模块3新增】试读最后一章，返回解锁引导标记
                                result.put("isLastTryRead", chapterNum == tryReadChapter);
                            } else {
                                result.put("code", 404);
                                result.put("msg", "章节内容不存在");
                            }
                        }
                    }
                }
            } else {
                result.put("code", 400);
                result.put("msg", "不支持的action类型");
            }

        } catch (Exception e) {
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