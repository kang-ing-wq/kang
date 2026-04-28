package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookManageDao {

    // ================== 对齐TushuguanServlet的调用 ==================
    // 对应Servlet里的 getAllBooks()
    public List<Book> getAllBooks() throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();

        List<Book> bookList = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            // 【100%匹配你的数据库字段名，一个字符都不差】
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear")); // 关键修正！和你的表字段一致
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            bookList.add(book);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return bookList;
    }

    // 对应Servlet里的 getBooksByTypeId(int typeId)
    public List<Book> getBooksByTypeId(int typeId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book WHERE type_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, typeId);
        ResultSet rs = preparedStatement.executeQuery();

        List<Book> bookList = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear")); // 关键修正
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            bookList.add(book);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return bookList;
    }

    // ================== 对齐BookDeleteServlet的调用 ==================
    // 对应Servlet里的 deleteBook(Long bookId)，兼容Integer/Long
    public void deleteBook(Long bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "DELETE FROM book WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setLong(1, bookId);
        preparedStatement.execute();
        preparedStatement.close();
        connection.close();
    }

    // ================== 对齐CartServlet的调用 ==================
    // 对应Servlet里的 findBookById(Long bookId)，兼容Integer/Long
    public Book findBookById(Long bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setLong(1, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        Book book = null;
        if (rs.next()) {
            book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear")); // 关键修正
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return book;
    }

    // ================== 原有功能方法（保留） ==================
    // 新增典籍（加固版）
    public void addBook(Book book) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "INSERT INTO book(book_title, book_author, book_summary, type_id, download_times, book_pubYear, book_file, book_cover, book_format, price, stock, is_sale, try_read_chapter) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, book.getBookTitle());
        preparedStatement.setString(2, book.getBookAuthor());
        preparedStatement.setString(3, book.getBookSummary());

        // 使用 setObject 替代 setInt/setDouble，防止 null 拆箱报错
        preparedStatement.setObject(4, book.getTypeId());
        preparedStatement.setObject(5, book.getDownloadTimes());
        preparedStatement.setString(6, book.getBookPubYear());
        preparedStatement.setString(7, book.getBookFile());
        preparedStatement.setString(8, book.getBookCover());
        preparedStatement.setString(9, book.getBookFormat());

        // 【关键加固】使用 setObject，null 会直接传给数据库
        preparedStatement.setObject(10, book.getPrice());
        preparedStatement.setObject(11, book.getStock());
        preparedStatement.setObject(12, book.getIsSale());
        preparedStatement.setObject(13, book.getTryReadChapter());

        preparedStatement.execute();
        preparedStatement.close();
        connection.close();
    }

    // 更新典籍库存（模块四用）
    public int updateBookStock(Integer bookId, Integer num) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE book SET stock = stock - ? WHERE id = ? AND stock >= ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setInt(1, num);
        preparedStatement.setInt(2, bookId);
        preparedStatement.setInt(3, num);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 搜索典籍（可选）
    public List<Book> searchBooks(String keyword) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book WHERE book_title LIKE ? OR book_author LIKE ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, "%" + keyword + "%");
        preparedStatement.setString(2, "%" + keyword + "%");
        ResultSet rs = preparedStatement.executeQuery();

        List<Book> bookList = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear")); // 关键修正
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            bookList.add(book);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return bookList;
    }

    // ================== 新增：查询典籍库存 ==================
    public int getBookStock(Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT stock FROM book WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, bookId);
        ResultSet rs = pstmt.executeQuery();

        int stock = 0;
        if (rs.next()) {
            stock = rs.getInt("stock");
        }

        rs.close();
        pstmt.close();
        conn.close();
        return stock;
    }

    // ================== 新增：更新典籍库存（支持事务） ==================
// num为正数是加库存，负数是减库存
    public void updateBookStock(Connection conn, Integer bookId, int num) throws SQLException {
        String sql = "UPDATE book SET stock = stock + ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, num);
        pstmt.setInt(2, bookId);
        pstmt.executeUpdate();
        pstmt.close();
    }
}