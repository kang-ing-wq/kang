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
import java.util.List;

@WebServlet("/orderList")
public class OrderListServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 登录校验
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录，方可查看道契记录");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        String userId = loginUser.getId();

        try {
            // 2. 先自动处理超时24小时的待支付订单，自动作废
            orderDao.cancelOverTimeOrder(userId);

            // 3. 接收Tab状态参数：0-待结香火，null-全部订单
            String statusStr = request.getParameter("status");
            Integer status = null;
            if (statusStr != null && !statusStr.isEmpty()) {
                status = Integer.parseInt(statusStr);
            }

            // 4. 查询用户的道契列表
            List<OrderInfo> orderList = orderDao.getOrderListByUserId(userId, status);

            // 5. 把数据放到request域，传给JSP页面
            request.setAttribute("orderList", orderList);
            request.setAttribute("currentStatus", status);

            // 6. 转发到你的「我的订单」页面
            request.getRequestDispatcher("/orderList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "道契记录加载失败：" + e.getMessage());
            request.getRequestDispatcher("/tushuguan").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}