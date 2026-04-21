package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Book;
import com.ebookBuy.pojo.UserBook;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserBookDao {

    // 新增用户已购典籍记录
    public int addUserBook(UserBook userBook) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "INSERT INTO user_book (id, user_id, book_id, order_id, buy_time, last_read_chapter) VALUES (UUID(),?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, userBook.getUserId());
        preparedStatement.setInt(2, userBook.getBookId());
        preparedStatement.setString(3, userBook.getOrderId());
        preparedStatement.setTimestamp(4, userBook.getBuyTime());
        preparedStatement.setInt(5, userBook.getLastReadChapter());

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 检查用户是否已购买该典籍
    public boolean checkUserHasBook(String userId, Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM user_book WHERE user_id = ? AND book_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);
        preparedStatement.setInt(2, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        boolean hasBook = false;
        if (rs.next()) {
            hasBook = true;
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return hasBook;
    }

    // 查询用户的所有已购典籍
    // 【保底修复版】彻底解决Unknown column报错，只查核心必有的字段，确保页面正常加载
    public List<Book> getUserBookList(String userId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 只查book表中100%存在的核心字段，完全避开列名不匹配的问题
        String sql = "SELECT b.id, " +
                "b.book_title AS bookTitle, " +
                "b.book_author AS bookAuthor, " +
                "ub.last_read_chapter AS lastReadChapter, " +
                "ub.last_read_time AS lastReadTime, " +
                "ub.buy_time AS buyTime " +
                "FROM user_book ub LEFT JOIN book b ON ub.book_id = b.id " +
                "WHERE ub.user_id = ? ORDER BY ub.buy_time DESC";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);
        ResultSet rs = preparedStatement.executeQuery();

        List<Book> bookList = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            // 只封装核心字段，绝对不会因为字段不存在报错
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("bookTitle"));
            book.setBookAuthor(rs.getString("bookAuthor"));
            book.setLastReadChapter(rs.getInt("lastReadChapter"));
            book.setLastReadTime(rs.getTimestamp("lastReadTime"));
            book.setBuyTime(rs.getTimestamp("buyTime"));
            bookList.add(book);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return bookList;
    }

    // 更新用户阅读进度
    public int updateReadProgress(String userId, Integer bookId, Integer chapterNum) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE user_book SET last_read_chapter = ?, last_read_time = NOW() WHERE user_id = ? AND book_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setInt(1, chapterNum);
        preparedStatement.setString(2, userId);
        preparedStatement.setInt(3, bookId);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 查询用户最后阅读的章节
    public Integer getLastReadChapter(String userId, Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT last_read_chapter FROM user_book WHERE user_id = ? AND book_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);
        preparedStatement.setInt(2, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        Integer chapterNum = 0;
        if (rs.next()) {
            chapterNum = rs.getInt("last_read_chapter");
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapterNum;
    }
}