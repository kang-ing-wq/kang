package com.ebookBuy.sevlet;

import com.ebookBuy.dao.OrderDao;
import com.ebookBuy.dao.UserBookDao;
import com.ebookBuy.pojo.OrderInfo;
import com.ebookBuy.pojo.OrderItem;
import com.ebookBuy.pojo.User;
import com.ebookBuy.pojo.UserBook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/orderFinish")
public class OrderFinishServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();
    private UserBookDao userBookDao = new UserBookDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 登录校验
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录！");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        String userId = loginUser.getId();

        // 2. 获取道契编号
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orderList");
            return;
        }

        try {
            // 3. 校验道契归属
            OrderInfo order = orderDao.getOrderById(orderId);
            if (order == null || !order.getUserId().equals(userId)) {
                request.setAttribute("msg", "此道契不属于您，无法解锁！");
                response.sendRedirect(request.getContextPath() + "/orderList");
                return;
            }

            // 4. 仅「待解锁」状态可收入藏经
            if (order.getOrderStatus() != 1) {
                request.setAttribute("msg", "只有待解锁的道契，方可收入藏经！");
                response.sendRedirect(request.getContextPath() + "/orderList");
                return;
            }

            // 5. 执行状态流转：1→2 已入藏经
            int result = orderDao.finishOrder(orderId);
            if (result > 0) {
                // 【适配你的Dao】循环调用 addUserBook，插入每一本典籍
                for (OrderItem item : order.getItemList()) {
                    UserBook userBook = new UserBook();
                    userBook.setUserId(userId);
                    userBook.setBookId(item.getBookId());
                    userBook.setOrderId(orderId);
                    userBook.setBuyTime(new Timestamp(System.currentTimeMillis()));
                    userBook.setLastReadChapter(0); // 初始最后阅读章节为0
                    userBookDao.addUserBook(userBook);
                }
                request.setAttribute("msg", "典籍已成功收入藏经阁，永久解锁！可前往私人藏经阁阅读");
            } else {
                request.setAttribute("msg", "解锁失败，请重试！");
            }

            // 6. 跳回道契列表
            response.sendRedirect(request.getContextPath() + "/orderList");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "解锁典籍异常：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orderList");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}