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

@WebServlet("/orderPay")
public class OrderPayServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 登录校验
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录，方可进行香火供奉");
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
            // 3. 查询订单详情，校验订单归属
            OrderInfo order = orderDao.getOrderById(orderId);
            if (order == null || !order.getUserId().equals(loginUser.getId())) {
                request.setAttribute("msg", "道契不存在，或不属于您");
                request.getRequestDispatcher("/orderList").forward(request, response);
                return;
            }

            // 4. 把订单数据放到request域，传给支付页面
            request.setAttribute("order", order);

            // 5. 转发到支付页面
            request.getRequestDispatcher("/orderPay.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "道契加载失败：" + e.getMessage());
            request.getRequestDispatcher("/orderList").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 处理支付提交请求
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String orderId = request.getParameter("orderId");
        if (orderId == null || orderId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orderList");
            return;
        }

        try {
            // 核心：执行支付，更新订单状态
            int result = orderDao.payOrder(orderId);
            if (result > 0) {
                request.setAttribute("msg", "香火供奉成功！典籍已收入您的私人藏经阁");
            } else {
                request.setAttribute("msg", "供奉失败，道契已过期或不存在");
            }

            // 支付完成，跳转到订单列表
            response.sendRedirect(request.getContextPath() + "/orderList");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "供奉失败：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orderList");
        }
    }
}