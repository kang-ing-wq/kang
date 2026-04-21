package com.ebookBuy.sevlet;

import com.ebookBuy.dao.OrderDao;
import com.ebookBuy.pojo.OrderInfo;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/orderCancel")
public class OrderCancelServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 登录校验
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // 2. 接收道契编号
        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orderList");
            return;
        }

        try {
            // 3. 校验订单归属
            OrderInfo order = orderDao.getOrderById(orderId);
            if (order == null || !order.getUserId().equals(loginUser.getId())) {
                request.setAttribute("msg", "道契不存在，或不属于您");
                response.sendRedirect(request.getContextPath() + "/orderList");
                return;
            }

            // 4. 执行取消订单
            int result = orderDao.cancelOrder(orderId);
            if (result > 0) {
                request.setAttribute("msg", "道契已作废，典籍库存已恢复");
            } else {
                request.setAttribute("msg", "作废失败，仅待结香火的道契可作废");
            }

            // 5. 跳回订单列表
            response.sendRedirect(request.getContextPath() + "/orderList");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "作废失败：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orderList");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}