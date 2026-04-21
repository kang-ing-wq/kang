package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.OrderItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class OrderItemDao {

    // 批量插入道契明细
    public int batchInsertOrderItem(List<OrderItem> itemList) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 关闭自动提交，开启事务
        connection.setAutoCommit(false);
        String sql = "INSERT INTO order_item (id, order_id, book_id, book_name, author, price, buy_num, sub_total) VALUES (UUID(),?,?,?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        for (OrderItem item : itemList) {
            preparedStatement.setString(1, item.getOrderId());
            preparedStatement.setInt(2, item.getBookId());
            preparedStatement.setString(3, item.getBookName());
            preparedStatement.setString(4, item.getAuthor());
            preparedStatement.setDouble(5, item.getPrice());
            preparedStatement.setInt(6, item.getBuyNum());
            preparedStatement.setDouble(7, item.getSubTotal());
            preparedStatement.addBatch();
        }

        int[] result = preparedStatement.executeBatch();
        connection.commit();
        preparedStatement.close();
        connection.close();
        return result.length;
    }

    // 根据道契编号查询明细列表
    public List<OrderItem> getOrderItemList(String orderId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM order_item WHERE order_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, orderId);
        ResultSet rs = preparedStatement.executeQuery();

        List<OrderItem> itemList = new java.util.ArrayList<>();
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
        preparedStatement.close();
        connection.close();
        return itemList;
    }
}