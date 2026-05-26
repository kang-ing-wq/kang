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
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final CartDao cartDao = new CartDao();
    private final BookManageDao bookDao = new BookManageDao();
    private final ObjectMapper objectMapper = new ObjectMapper(); // 用于返回JSON

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 基础设置
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        // 2. 登录校验（核心！未登录直接返回401，所有操作必须登录）
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401未登录
            result.put("code", 401);
            result.put("msg", "请先登录宗门账号，方可使用藏经袋功能");
            response.getWriter().write(objectMapper.writeValueAsString(result));
            return;
        }
        String userId = loginUser.getId();

        // 3. 获取action参数，分发处理
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "宗门指令无效，请重试");
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
                // ========== 【新增优化接口】 ==========
                case "select": // 单条商品选中/取消选中
                    updateCartSelected(request, response, userId, result);
                    break;
                case "selectAll": // 全选/反选全部商品
                    updateCartSelectAll(request, response, userId, result);
                    break;
                case "deleteBatch": // 批量删除选中/指定商品
                    deleteBatchCartItem(request, response, userId, result);
                    break;
                case "selectedList": // 查询选中的商品（结算专用）
                    getSelectedCartList(request, response, userId, result);
                    break;
                default:
                    result.put("code", 400);
                    result.put("msg", "无效的宗门指令");
                    break;
            }
        } catch (SQLException | ClassNotFoundException e) {
            // 捕获所有数据库异常，打印日志，返回友好提示
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "宗门藏经阁服务器异常：" + e.getMessage());
        }

        // 4. 返回JSON结果
        response.getWriter().write(objectMapper.writeValueAsString(result));
    }

    // ================== 【原有方法优化加固】 ==================
    // 1. 加入藏经袋（优化：幂等防重复、参数加固、主题提示、异常捕获）
    private void addToCart(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        // 获取参数+格式校验加固，防止数字格式异常
        String bookIdStr = request.getParameter("bookId");
        String buyNumStr = request.getParameter("buyNum");
        if (bookIdStr == null || bookIdStr.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "请选择要请购的典籍");
            return;
        }

        // 数量默认值：不传默认请购1本
        int buyNum = 1;
        if (buyNumStr != null && !buyNumStr.isEmpty()) {
            try {
                buyNum = Integer.parseInt(buyNumStr);
            } catch (NumberFormatException e) {
                result.put("code", 400);
                result.put("msg", "请购数量格式错误，请输入有效数字");
                return;
            }
        }

        Long bookId;
        try {
            bookId = Long.parseLong(bookIdStr);
        } catch (NumberFormatException e) {
            result.put("code", 400);
            result.put("msg", "典籍编号无效，请重试");
            return;
        }

        // 基础数量校验
        if (buyNum < 1) {
            result.put("code", 400);
            result.put("msg", "请购数量不能少于1本");
            return;
        }

        // 校验典籍是否存在+是否上架
        Book book = bookDao.findBookById(bookId);
        if (book == null) {
            result.put("code", 404);
            result.put("msg", "该典籍不存在，或已被宗门下架");
            return;
        }

        // 【优化1：售罄校验】
        if (book.getStock() == null || book.getStock() <= 0) {
            result.put("code", 400);
            result.put("msg", "此典籍已被宗门道友请购一空，暂无余量");
            return;
        }

        // 校验是否已在藏经袋
        Cart existCart = cartDao.checkCartExist(userId, bookId);
        int totalWantNum = buyNum;
        if (existCart != null) {
            totalWantNum = existCart.getBuyNum() + buyNum;
        }

        // 【优化2：总数量库存上限校验】
        if (totalWantNum > book.getStock()) {
            result.put("code", 400);
            result.put("msg", "该典籍仅剩 " + book.getStock() + " 本，你的藏经袋中已有 " + (existCart != null ? existCart.getBuyNum() : 0) + " 本，无法继续请购");
            return;
        }

        if (existCart != null) {
            // 已存在，更新数量+默认选中
            cartDao.updateBuyNum(existCart.getId(), totalWantNum);
            cartDao.updateSelected(existCart.getId(), 1);
            result.put("code", 200);
            result.put("msg", "典籍已在你的藏经袋中，数量已更新！");
            return;
        }

        // 不存在，新增藏经袋记录+默认选中
        cartDao.addToCart(userId, bookId, buyNum);
        result.put("code", 200);
        result.put("msg", "典籍已成功请入你的藏经袋！");
    }

    // 2. 查询藏经袋列表（优化：返回合计数据、商品状态标记、前端不用二次计算）
    private void getCartList(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        List<Cart> cartList = cartDao.findCartListByUserId(userId);

        // 【优化1：实时校验商品状态，给前端返回标记】
        int totalCount = 0; // 总商品数量
        int selectedCount = 0; // 选中商品数量
        String totalPrice = "0.00"; // 选中商品总价
        boolean hasStockWarn = false; // 是否有库存不足预警
        boolean hasOfflineBook = false; // 是否有下架典籍

        for (Cart cart : cartList) {
            Book book = cart.getBook();
            totalCount += cart.getBuyNum();

            // 标记下架商品
            if (book == null) {
                cart.setBookOffline(true);
                hasOfflineBook = true;
                continue;
            }

            // 标记库存不足商品
            if (book.getStock() < cart.getBuyNum()) {
                cart.setStockWarn(true);
                hasStockWarn = true;
            }

            // 计算选中商品总价
            if (cart.getSelected() != null && cart.getSelected() == 1) {
                selectedCount += cart.getBuyNum();
                // 计算总价：单价*数量，保留2位小数
                double itemTotal = book.getPrice() * cart.getBuyNum();
                totalPrice = String.format("%.2f", Double.parseDouble(totalPrice) + itemTotal);
            }
        }

        // 【优化2：把合计数据直接返回给前端，不用前端循环计算】
        result.put("code", 200);
        result.put("msg", "藏经袋查询成功");
        result.put("data", cartList);
        result.put("totalCount", totalCount); // 总数量
        result.put("selectedCount", selectedCount); // 选中数量
        result.put("totalPrice", totalPrice); // 选中总价
        result.put("hasStockWarn", hasStockWarn); // 库存预警标记
        result.put("hasOfflineBook", hasOfflineBook); // 下架商品标记
    }

    // 3. 更新请购数量（优化：越权校验加固、参数校验、主题提示）
    private void updateCartNum(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String cartId = request.getParameter("cartId");
        String newBuyNumStr = request.getParameter("newBuyNum");
        if (cartId == null || newBuyNumStr == null || cartId.isEmpty() || newBuyNumStr.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "参数不全，请重试");
            return;
        }

        Integer newBuyNum;
        try {
            newBuyNum = Integer.parseInt(newBuyNumStr);
        } catch (NumberFormatException e) {
            result.put("code", 400);
            result.put("msg", "请购数量格式错误，请输入有效数字");
            return;
        }

        // 数量下限校验
        if (newBuyNum < 1) {
            result.put("code", 400);
            result.put("msg", "请购数量不能少于1本，若无需此典籍可移出藏经袋");
            return;
        }

        // 【优化1：越权校验+记录存在性校验】
        Cart cart = cartDao.findCartById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            result.put("code", 403);
            result.put("msg", "你无权操作此藏经袋记录");
            return;
        }

        // 【优化2：库存上限校验】
        Book book = bookDao.findBookById(Long.valueOf(cart.getBookId()));
        if (book == null) {
            result.put("code", 404);
            result.put("msg", "该典籍不存在，或已被宗门下架");
            return;
        }
        if (newBuyNum > book.getStock()) {
            result.put("code", 400);
            result.put("msg", "该典籍仅剩 " + book.getStock() + " 本，无法更新为 " + newBuyNum + " 本");
            return;
        }

        // 执行更新
        cartDao.updateBuyNum(cartId, newBuyNum);
        result.put("code", 200);
        result.put("msg", "请购数量已更新");
    }

    // 4. 移出单条典籍（优化：修复越权漏洞、校验加固）
    private void deleteCartItem(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String cartId = request.getParameter("cartId");
        if (cartId == null || cartId.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "请选择要移出的典籍");
            return;
        }

        // 【修复核心安全漏洞：越权校验，只能删自己的藏经袋记录】
        Cart cart = cartDao.findCartById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            result.put("code", 403);
            result.put("msg", "你无权操作此藏经袋记录");
            return;
        }

        // 执行删除
        cartDao.deleteCartById(cartId);
        result.put("code", 200);
        result.put("msg", "典籍已成功移出你的藏经袋");
    }

    // 5. 清空藏经袋（优化：主题提示、权限加固）
    private void clearCart(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        cartDao.clearUserCart(userId);
        result.put("code", 200);
        result.put("msg", "你的藏经袋已全部清空");
    }

    // ================== 【新增极致优化核心方法】 ==================
    // 6. 单条商品选中/取消选中
    private void updateCartSelected(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String cartId = request.getParameter("cartId");
        String selectedStr = request.getParameter("selected");
        if (cartId == null || selectedStr == null || cartId.isEmpty() || selectedStr.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "参数不全，请重试");
            return;
        }

        Integer selected;
        try {
            selected = Integer.parseInt(selectedStr);
        } catch (NumberFormatException e) {
            result.put("code", 400);
            result.put("msg", "选中状态格式错误");
            return;
        }

        // 越权校验
        Cart cart = cartDao.findCartById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            result.put("code", 403);
            result.put("msg", "你无权操作此藏经袋记录");
            return;
        }

        // 执行更新
        cartDao.updateSelected(cartId, selected);
        result.put("code", 200);
        result.put("msg", selected == 1 ? "已选中此典籍" : "已取消选中此典籍");
    }

    // 7. 全选/反选全部商品
    private void updateCartSelectAll(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String selectedStr = request.getParameter("selected");
        if (selectedStr == null || selectedStr.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "参数不全，请重试");
            return;
        }

        Integer selected;
        try {
            selected = Integer.parseInt(selectedStr);
        } catch (NumberFormatException e) {
            result.put("code", 400);
            result.put("msg", "选中状态格式错误");
            return;
        }

        // 执行全选/反选
        cartDao.updateAllSelected(userId, selected);
        result.put("code", 200);
        result.put("msg", selected == 1 ? "已全选藏经袋所有典籍" : "已取消全选");
    }

    // 8. 批量删除选中/指定商品
    private void deleteBatchCartItem(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        String cartIdsStr = request.getParameter("cartIds");
        if (cartIdsStr == null || cartIdsStr.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "请选择要移出的典籍");
            return;
        }

        // 拆分cartId数组
        List<String> cartIdList = Arrays.asList(cartIdsStr.split(","));
        if (cartIdList.isEmpty()) {
            result.put("code", 400);
            result.put("msg", "请选择要移出的典籍");
            return;
        }

        // 执行批量删除（Dao内部已做userId校验，防止越权）
        cartDao.deleteBatchByIds(userId, cartIdList);
        result.put("code", 200);
        result.put("msg", "已批量移出选中的典籍");
    }

    // 9. 查询选中的商品列表（结算专用，只返回选中的、有效的商品）
    private void getSelectedCartList(HttpServletRequest request, HttpServletResponse response, String userId, Map<String, Object> result) throws SQLException, ClassNotFoundException {
        List<Cart> selectedCartList = cartDao.findSelectedCartListByUserId(userId);

        // 校验商品有效性，过滤下架、库存不足的商品
        boolean hasInvalid = false;
        String totalPrice = "0.00";
        int totalCount = 0;

        for (Cart cart : selectedCartList) {
            Book book = cart.getBook();
            // 过滤下架商品
            if (book == null) {
                selectedCartList.remove(cart);
                hasInvalid = true;
                continue;
            }
            // 过滤库存不足商品
            if (book.getStock() < cart.getBuyNum()) {
                selectedCartList.remove(cart);
                hasInvalid = true;
                continue;
            }

            // 计算总价和数量
            totalCount += cart.getBuyNum();
            double itemTotal = book.getPrice() * cart.getBuyNum();
            totalPrice = String.format("%.2f", Double.parseDouble(totalPrice) + itemTotal);
        }

        result.put("code", 200);
        result.put("msg", hasInvalid ? "部分典籍已失效，已自动过滤" : "查询成功");
        result.put("data", selectedCartList);
        result.put("totalCount", totalCount);
        result.put("totalPrice", totalPrice);
        result.put("hasInvalid", hasInvalid);
    }

    // 兼容GET请求
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}