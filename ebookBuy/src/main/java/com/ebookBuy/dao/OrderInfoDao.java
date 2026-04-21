package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.OrderInfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderInfoDao {

    // 创建道契订单
    public int createOrder(OrderInfo order) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "INSERT INTO order_info (id, user_id, total_amount, order_status, create_time, remark) VALUES (?,?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, order.getId());
        preparedStatement.setString(2, order.getUserId());
        preparedStatement.setDouble(3, order.getTotalAmount());
        preparedStatement.setInt(4, order.getOrderStatus());
        preparedStatement.setTimestamp(5, new java.sql.Timestamp(order.getCreateTime().getTime()));
        preparedStatement.setString(6, order.getRemark());

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 根据道契编号查询订单
    public OrderInfo getOrderById(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM order_info WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, orderId);
        ResultSet rs = preparedStatement.executeQuery();

        OrderInfo order = null;
        if (rs.next()) {
            order = new OrderInfo();
            order.setId(rs.getString("id"));
            order.setUserId(rs.getString("user_id"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setOrderStatus(rs.getInt("order_status"));
            order.setPayTime(rs.getTimestamp("pay_time"));
            order.setCreateTime(rs.getTimestamp("create_time"));
            order.setCancelTime(rs.getTimestamp("cancel_time"));
            order.setRemark(rs.getString("remark"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return order;
    }

    // 查询道友的所有道契
    public List<OrderInfo> getOrderListByUserId(String userId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM order_info WHERE user_id = ? ORDER BY create_time DESC";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);
        ResultSet rs = preparedStatement.executeQuery();

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
        preparedStatement.close();
        connection.close();
        return orderList;
    }

    // 按状态查询道友的道契
    public List<OrderInfo> getOrderListByStatus(String userId, Integer status) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM order_info WHERE user_id = ? AND order_status = ? ORDER BY create_time DESC";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);
        preparedStatement.setInt(2, status);
        ResultSet rs = preparedStatement.executeQuery();

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
        preparedStatement.close();
        connection.close();
        return orderList;
    }

    // 更新道契状态（支付/取消）
    public int updateOrderStatus(String orderId, Integer status) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql;
        // 支付状态更新，同时更新支付时间
        if (status == 1) {
            sql = "UPDATE order_info SET order_status = ?, pay_time = NOW() WHERE id = ?";
        } else if (status == 3) {
            // 取消状态更新，同时更新取消时间
            sql = "UPDATE order_info SET order_status = ?, cancel_time = NOW() WHERE id = ?";
        } else {
            sql = "UPDATE order_info SET order_status = ? WHERE id = ?";
        }
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setInt(1, status);
        preparedStatement.setString(2, orderId);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 查询超时未支付的道契（24小时）
    public List<OrderInfo> getTimeoutUnpayOrder() throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM order_info WHERE order_status = 0 AND create_time < DATE_SUB(NOW(), INTERVAL 24 HOUR)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();

        List<OrderInfo> orderList = new ArrayList<>();
        while (rs.next()) {
            OrderInfo order = new OrderInfo();
            order.setId(rs.getString("id"));
            order.setUserId(rs.getString("user_id"));
            order.setTotalAmount(rs.getDouble("total_amount"));
            order.setOrderStatus(rs.getInt("order_status"));
            order.setCreateTime(rs.getTimestamp("create_time"));
            orderList.add(order);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return orderList;
    }
}