package com.ebookBuy.db;

import com.ebookBuy.pojo.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class selectTest1 {
    public static void main(String[] args) throws ClassNotFoundException, SQLException {

        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement("select * from user");
        ResultSet rs = preparedStatement.executeQuery();
        ArrayList<User> userList = new ArrayList<User>();

        while (rs.next()){
            User user = new User();
            user.setId(rs.getString("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setAge(rs.getInt("age"));
            user.setSex(rs.getString("sex"));
            user.setEmail(rs.getString("email"));
            userList.add(user);


        }
        System.out.println(userList);
        rs.close();
        preparedStatement.close();
        dbManager.close(connection);
    }
}
