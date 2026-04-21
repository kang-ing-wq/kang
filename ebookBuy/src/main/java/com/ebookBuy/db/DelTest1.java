package com.ebookBuy.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DelTest1 {
    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement("delete from user where id = ?");
        preparedStatement.setString(1,"u_fangyuan");
        preparedStatement.execute();
        preparedStatement.close();
        dbManager.close(connection);

    }
}
