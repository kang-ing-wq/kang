package com.ebookBuy.sevlet;

import com.ebookBuy.dao.BookManageDao;
import com.ebookBuy.dao.CartDao;
import com.ebookBuy.pojo.Cart;
import com.ebookBuy.pojo.Book;
import com.ebookBuy.pojo.User;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDao cartDao = new CartDao();
    private BookManageDao bookDao = new BookManageDao();
    private ObjectMapper objectMapper = new ObjectMapper(); // 用于返回JSON

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 基础设置
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        // 2. 登录校验（核心！未登录直接返回401）
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401未登录
            result.put("code", 401);
            result.put("msg", "请先登录");
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }
        String userId = loginUser.getId();

        // 3. 获取action参数，分发处理
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "参数错误");
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }

        try {
            switch (action) {
                case "add":
                    addToCart(request, response, userId, result);
                    break;
                case "list":
                    getCartList(request, response, userId, result);
                    break;
                case "update":
                    updateCartNum(request, response, userId, result);
                    break;
                case "delete":
                    deleteCartItem(request, response, userId, result);
                    break;
                case "clear":
                    clearCart(request, response, userId, result);
                    break;
                default:
                    result.put("code", 400);
                    result.put("msg", "无效的操作");
                    break;
            }
        } catch (SQLException | ClassNotFoundException e) {
            // 捕获所有数据库异常，打印日志，返回友好提示
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "服务器内部错误：" + e.getMessage());
        }

        // 4. 返回JSON结果
        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    // ================== 购物车核心方法 ==================
    // 1. 加入购物车
    private void addToCart(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        // 获取参数
        String bookIdStr = request.getParameter("bookId");
        String buyNumStr = request.getParameter("buyNum");
        if (bookIdStr == null || buyNumStr == null) {
            result.put("code", 400);
            result.put("msg", "参数不全");
            return;
        }

        Long bookId = Long.parseLong(bookIdStr);
        Integer buyNum = Integer.parseInt(buyNumStr);

        // 校验典籍是否存在
        Book book = bookDao.findBookById(bookId);
        if (book == null) {
            result.put("code", 404);
            result.put("msg", "该典籍不存在");
            return;
        }

        // 校验是否已在购物车
        Cart existCart = cartDao.checkCartExist(userId, bookId);
        if (existCart != null) {
            // 已存在，更新数量
            cartDao.updateBuyNum(existCart.getId(), existCart.getBuyNum() + buyNum);
            result.put("code", 200);
            result.put("msg", "典籍已在藏经袋中，数量已更新！");
            return;
        }

        // 不存在，新增购物车
        cartDao.addToCart(userId, bookId, buyNum);
        result.put("code", 200);
        result.put("msg", "典籍已成功请入藏经袋！");
    }

    // 2. 查询购物车列表
    private void getCartList(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        List<Cart> cartList = cartDao.findCartListByUserId(userId);
        result.put("code", 200);
        result.put("msg", "查询成功");
        result.put("data", cartList);
    }

    // 3. 更新购物车数量
    private void updateCartNum(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String cartId = request.getParameter("cartId");
        String newBuyNumStr = request.getParameter("newBuyNum");
        if (cartId == null || newBuyNumStr == null) {
            result.put("code", 400);
            result.put("msg", "参数不全");
            return;
        }

        Integer newBuyNum = Integer.parseInt(newBuyNumStr);
        if (newBuyNum < 1) {
            result.put("code", 400);
            result.put("msg", "购买数量不能小于1");
            return;
        }

        cartDao.updateBuyNum(cartId, newBuyNum);
        result.put("code", 200);
        result.put("msg", "数量已更新");
    }

    // 4. 删除购物车项
    private void deleteCartItem(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String cartId = request.getParameter("cartId");
        if (cartId == null || cartId.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "参数不全");
            return;
        }

        cartDao.deleteCartById(cartId);
        result.put("code", 200);
        result.put("msg", "典籍已移出藏经袋");
    }

    // 5. 清空购物车
    private void clearCart(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        cartDao.clearUserCart(userId);
        result.put("code", 200);
        result.put("msg", "藏经袋已清空");
    }

    // 兼容GET请求
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}