package com.ebookBuy.db;

import com.mysql.jdbc.Driver;

import javax.xml.transform.Result;
import java.sql.*;

public class DBManager {
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        String url = "jdbc:mysql://localhost:3306/ebook2";
        String username = "root";
        String password = "123456";
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connection = DriverManager.getConnection(url,username,password);
        System.out.println("数据库链接成功！！！");
        return  connection;
    }

    public static void close(Connection connection) throws SQLException {
        if(connection!=null){
            connection.close();
        }
    }


    public static void main(String[] args) throws ClassNotFoundException, SQLException {

        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement("select * from user");
        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()){
            System.out.println(rs.getString("username"));
            System.out.println(rs.getString("password"));
        }

        dbManager.close(connection);
    }

    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {

    }
}
