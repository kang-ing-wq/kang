package com.ebookBuy.db;

import com.ebookBuy.pojo.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class selectTest2 {
    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement("select * from user where id=?");
        preparedStatement.setString(1,"u_fangyuan");

        ResultSet rs = preparedStatement.executeQuery();
        rs.next();
        User user = new User();
        user.setId(rs.getString("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setAge(rs.getInt("age"));
        user.setSex(rs.getString("sex"));
        user.setEmail(rs.getString("email"));
        System.out.println("=============="+user);



    }
}
