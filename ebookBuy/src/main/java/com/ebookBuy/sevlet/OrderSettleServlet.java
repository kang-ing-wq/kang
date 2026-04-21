package com.ebookBuy.sevlet;

import com.ebookBuy.dao.OrderDao;
import com.ebookBuy.pojo.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/orderSettle")
public class OrderSettleServlet extends HttpServlet {
    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 登录校验（和你现有项目逻辑完全一致）
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("msg", "道友请先登录，方可缔结道契");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        String userId = loginUser.getId();

        // 2. 接收道友备注（可选）
        String remark = request.getParameter("remark");
        if (remark == null) remark = "";

        try {
            // 3. 核心：从藏经袋生成道契订单（事务处理）
            String orderId = orderDao.createOrderFromCart(userId, remark);

            // 4. 生成成功，跳转到支付页面
            response.sendRedirect(request.getContextPath() + "/orderPay?orderId=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            // 生成失败，返回藏经袋页面，提示错误
            request.setAttribute("msg", "道契缔结失败：" + e.getMessage());
            request.getRequestDispatcher("/tushuguan").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}