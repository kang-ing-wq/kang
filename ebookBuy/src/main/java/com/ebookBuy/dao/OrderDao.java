package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Cart;
import com.ebookBuy.pojo.OrderInfo;
import com.ebookBuy.pojo.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * 道契订单数据访问层
 */
public class OrderDao {
    private CartDao cartDao = new CartDao();
    private BookManageDao bookManageDao = new BookManageDao(); // 修正为你项目里的BookManageDao

    // ================== 核心业务：从藏经袋生成道契订单 ==================
    // 事务处理：生成订单主表+订单明细+清空藏经袋+扣减典籍库存，原子性操作
    public String createOrderFromCart(String userId, String remark) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        conn.setAutoCommit(false); // 开启事务，要么全成功，要么全回滚

        try {
            // 1. 查询用户藏经袋的所有典籍
            List<Cart> cartList = cartDao.findCartListByUserId(userId);
            if (cartList.isEmpty()) {
                throw new RuntimeException("道友的藏经袋空空如也，无法生成道契");
            }

            // 2. 生成道契编号（UUID去横线，和你现有ID规则一致）
            String orderId = UUID.randomUUID().toString().replace("-", "");
            double totalAmount = 0.0;

            // 3. 插入道契主表
            String orderSql = "INSERT INTO order_info(id, user_id, total_amount, order_status, create_time, remark) VALUES (?,?,?,0,NOW(),?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql);
            orderStmt.setString(1, orderId);
            orderStmt.setString(2, userId);
            orderStmt.setDouble(3, totalAmount); // 先占位，后面更新总金额
            orderStmt.setString(4, remark);
            orderStmt.executeUpdate();

            // 4. 批量插入订单明细，同时计算总香火、扣减库存
            String itemSql = "INSERT INTO order_item(id, order_id, book_id, book_name, author, price, buy_num, sub_total) VALUES (?,?,?,?,?,?,?,?)";
            PreparedStatement itemStmt = conn.prepareStatement(itemSql);

            for (Cart cart : cartList) {
                // 检查库存
                int stock = bookManageDao.getBookStock(cart.getBookId());
                if (stock < cart.getBuyNum()) {
                    throw new RuntimeException("典籍《" + cart.getBook().getBookTitle() + "》库存不足，无法生成道契");
                }

                // 计算金额
                double price = cart.getBook().getPrice();
                int num = cart.getBuyNum();
                double subTotal = price * num;
                totalAmount += subTotal;

                // 插入明细
                String itemId = UUID.randomUUID().toString().replace("-", "");
                itemStmt.setString(1, itemId);
                itemStmt.setString(2, orderId);
                itemStmt.setInt(3, cart.getBookId());
                itemStmt.setString(4, cart.getBook().getBookTitle());
                itemStmt.setString(5, cart.getBook().getBookAuthor());
                itemStmt.setDouble(6, price);
                itemStmt.setInt(7, num);
                itemStmt.setDouble(8, subTotal);
                itemStmt.addBatch();

                // 扣减典籍库存
                bookManageDao.updateBookStock(conn, cart.getBookId(), -num);
            }

            // 执行批量插入明细
            itemStmt.executeBatch();

            // 5. 更新订单总香火金额
            String updateTotalSql = "UPDATE order_info SET total_amount = ? WHERE id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateTotalSql);
            updateStmt.setDouble(1, totalAmount);
            updateStmt.setString(2, orderId);
            updateStmt.executeUpdate();

            // 6. 清空用户的藏经袋
            cartDao.clearCartByUserId(userId);

            // 提交事务，所有操作成功
            conn.commit();
            return orderId;

        } catch (Exception e) {
            conn.rollback(); // 任何异常都回滚，保证数据一致性
            throw e;
        } finally {
            conn.setAutoCommit(true); // 恢复自动提交
            conn.close();
        }
    }

    // ================== 查询用户的道契列表 ==================
    // status：null-查全部，0-待结香火，1-待解锁，2-已入藏经，3-已作废
    public List<OrderInfo> getOrderListByUserId(String userId, Integer status) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql;
        PreparedStatement pstmt;

        if (status == null) {
            sql = "SELECT * FROM order_info WHERE user_id = ? ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
        } else {
            sql = "SELECT * FROM order_info WHERE user_id = ? AND order_status = ? ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, status);
        }

        ResultSet rs = pstmt.executeQuery();
        List<OrderInfo> orderList = new ArrayList<>();
        while (rs.next()) {
            OrderInfo order = new OrderInfo();
            order.setId(rs.getString("id"));
            order.setUserId(rs.getString("user_id"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setOrderStatus(rs.getInt("order_status"));
            order.setPayTime(rs.getTimestamp("pay_time"));
            order.setCreateTime(rs.getTimestamp("create_time"));
            order.setCancelTime(rs.getTimestamp("cancel_time"));
            order.setRemark(rs.getString("remark"));
            orderList.add(order);
        }

        rs.close();
        pstmt.close();
        conn.close();
        return orderList;
    }

    // ================== 根据道契编号查询订单详情（含明细） ==================
    public OrderInfo getOrderById(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();

        // 1. 查询订单主信息
        String orderSql = "SELECT * FROM order_info WHERE id = ?";
        PreparedStatement orderStmt = conn.prepareStatement(orderSql);
        orderStmt.setString(1, orderId);
        ResultSet orderRs = orderStmt.executeQuery();

        OrderInfo order = null;
        if (orderRs.next()) {
            order = new OrderInfo();
            order.setId(orderRs.getString("id"));
            order.setUserId(orderRs.getString("user_id"));
            order.setTotalAmount(orderRs.getDouble("total_amount"));
            order.setOrderStatus(orderRs.getInt("order_status"));
            order.setPayTime(orderRs.getTimestamp("pay_time"));
            order.setCreateTime(orderRs.getTimestamp("create_time"));
            order.setCancelTime(orderRs.getTimestamp("cancel_time"));
            order.setRemark(orderRs.getString("remark"));

            // 2. 查询订单明细
            List<OrderItem> itemList = getOrderItemsByOrderId(orderId);
            order.setItemList(itemList);
        }

        orderRs.close();
        orderStmt.close();
        conn.close();
        return order;
    }

    // ================== 根据道契编号查询明细列表 ==================
    public List<OrderItem> getOrderItemsByOrderId(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT * FROM order_item WHERE order_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, orderId);
        ResultSet rs = pstmt.executeQuery();

        List<OrderItem> itemList = new ArrayList<>();
        while (rs.next()) {
            OrderItem item = new OrderItem();
            item.setId(rs.getString("id"));
            item.setOrderId(rs.getString("order_id"));
            item.setBookId(rs.getInt("book_id"));
            item.setBookName(rs.getString("book_name"));
            item.setAuthor(rs.getString("author"));
            item.setPrice(rs.getDouble("price"));
            item.setBuyNum(rs.getInt("buy_num"));
            item.setSubTotal(rs.getDouble("sub_total"));
            itemList.add(item);
        }

        rs.close();
        pstmt.close();
        conn.close();
        return itemList;
    }

    // ================== 香火供奉（订单支付） ==================
    // 更新订单状态为已付款，记录支付时间，同时解锁典籍阅读权限（为阶段五铺垫）
    public int payOrder(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        // 只允许更新「待结香火」状态的订单
        String sql = "UPDATE order_info SET order_status = 1, pay_time = NOW() WHERE id = ? AND order_status = 0";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, orderId);
        int result = pstmt.executeUpdate();

        pstmt.close();
        conn.close();
        return result;
    }

    // ================== 作废道契（取消订单） ==================
    // 更新订单状态为已作废，恢复典籍库存
    public int cancelOrder(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        conn.setAutoCommit(false); // 开启事务

        try {
            // 1. 检查订单状态，只允许取消「待结香火」的订单
            String checkSql = "SELECT * FROM order_info WHERE id = ? AND order_status = 0";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, orderId);
            ResultSet rs = checkStmt.executeQuery();
            if (!rs.next()) {
                return 0; // 订单不存在或状态不对，取消失败
            }

            // 2. 更新订单状态为已作废
            String cancelSql = "UPDATE order_info SET order_status = 3, cancel_time = NOW() WHERE id = ?";
            PreparedStatement cancelStmt = conn.prepareStatement(cancelSql);
            cancelStmt.setString(1, orderId);
            int result = cancelStmt.executeUpdate();

            // 3. 恢复典籍库存
            List<OrderItem> itemList = getOrderItemsByOrderId(orderId);
            for (OrderItem item : itemList) {
                bookManageDao.updateBookStock(conn, item.getBookId(), item.getBuyNum());
            }

            conn.commit();
            return result;

        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            conn.close();
        }
    }

    // ================== 超时订单自动作废（访问订单中心时触发） ==================
    public void cancelOverTimeOrder(String userId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        // 查找超过24小时的待支付订单
        String sql = "SELECT id FROM order_info WHERE user_id = ? AND order_status = 0 AND TIMESTAMPDIFF(HOUR, create_time, NOW()) > 24";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        List<String> overTimeOrderIds = new ArrayList<>();
        while (rs.next()) {
            overTimeOrderIds.add(rs.getString("id"));
        }

        rs.close();
        pstmt.close();
        conn.close();

        // 批量取消超时订单
        for (String orderId : overTimeOrderIds) {
            cancelOrder(orderId);
        }
    }

    // 标记道契为「已入藏经」（解锁典籍，状态1→2）
    public int finishOrder(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "UPDATE order_info SET order_status = 2 WHERE id = ? AND order_status = 1";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, orderId);
        int result = pstmt.executeUpdate();

        pstmt.close();
        conn.close();
        return result;
    }
}