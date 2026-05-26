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

@WebServlet("/orderDetail")
public class OrderDetailServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 登录校验
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录，方可查看道契详情");
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

            // 4. 把订单数据放到request域，传给详情页面
            request.setAttribute("order", order);

            // 5. 转发到详情页面（我们复用 orderPay.jsp 的风格，新建一个 orderDetail.jsp）
            // 如果你想直接用 orderPay.jsp 改，也可以，这里我们先 forward 到一个通用的详情页
            request.getRequestDispatcher("/orderDetail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "道契详情加载失败：" + e.getMessage());
            request.getRequestDispatcher("/orderList").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}