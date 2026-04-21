package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Cart;
import com.ebookBuy.pojo.Book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDao {

    // ================== 对齐CartServlet的调用 ==================
    // 1. 加入购物车
    public int addToCart(String userId, Long bookId, Integer buyNum) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "INSERT INTO cart(id, user_id, book_id, buy_num, create_time, update_time) VALUES (UUID(),?,?,?,NOW(),NOW())";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, userId);
        preparedStatement.setLong(2, bookId); // 数据库book_id是int，但用long兼容没问题
        preparedStatement.setInt(3, buyNum);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 2. 查询用户购物车列表（核心修复：100%对齐实体类+数据库）
    public List<Cart> findCartListByUserId(String userId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();

        // 核心SQL：给重复id起别名，字段名100%匹配数据库下划线
        String sql = "select " +
                "c.id as cart_id, c.user_id, c.book_id, c.buy_num, c.create_time, c.update_time, " +
                "b.id as book_id, b.book_title, b.book_author, b.book_summary, b.type_id, " +
                "b.download_times, b.book_pubYear, b.book_file, b.book_cover, b.book_format, " +
                "b.price, b.stock, b.is_sale, b.try_read_chapter " +
                "from cart c left join book b on c.book_id = b.id where c.user_id = ?";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        ResultSet rs = pstmt.executeQuery();

        List<Cart> cartList = new ArrayList<>();
        while (rs.next()) {
            // 1. 封装Cart对象，100%匹配Cart实体类
            Cart cart = new Cart();
            cart.setId(rs.getString("cart_id"));       // 购物车UUID用别名
            cart.setUserId(rs.getString("user_id"));
            cart.setBookId(rs.getInt("book_id"));     // 数据库book_id是int，对应实体类Integer
            cart.setBuyNum(rs.getInt("buy_num"));
            cart.setCreateTime(rs.getTimestamp("create_time"));
            cart.setUpdateTime(rs.getTimestamp("update_time"));

            // 2. 封装Book对象，100%匹配Book实体类和数据库字段
            Book book = new Book();
            book.setId(rs.getInt("book_id"));                // 数据库book.id是bigint，实体类是Integer，兼容
            book.setBookTitle(rs.getString("book_title"));   // 数据库book_title → 实体类bookTitle
            book.setBookAuthor(rs.getString("book_author")); // 数据库book_author → 实体类bookAuthor
            book.setBookSummary(rs.getString("book_summary"));// 数据库book_summary → 实体类bookSummary
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));// 数据库download_times → 实体类downloadTimes
            book.setBookPubYear(rs.getString("book_pubYear")); // 数据库book_pubYear → 实体类bookPubYear
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));

            // 3. 把Book对象设置到Cart里
            cart.setBook(book);
            cartList.add(cart);
        }

        // 关闭资源，和你其他方法保持一致
        rs.close();
        pstmt.close();
        conn.close();
        return cartList;
    }

    // 3. 更新购物车数量
    public int updateBuyNum(String cartId, Integer buyNum) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE cart SET buy_num = ?, update_time = NOW() WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, buyNum);
        preparedStatement.setString(2, cartId);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 4. 删除购物车项
    public int deleteCartById(String cartId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "DELETE FROM cart WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, cartId);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // 5. 检查购物车是否已有该书籍
    public Cart checkCartExist(String userId, Long bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM cart WHERE user_id = ? AND book_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);
        preparedStatement.setLong(2, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        Cart cart = null;
        if (rs.next()) {
            cart = new Cart();
            cart.setId(rs.getString("id"));
            cart.setUserId(rs.getString("user_id"));
            cart.setBookId(rs.getInt("book_id"));
            cart.setBuyNum(rs.getInt("buy_num"));
            cart.setCreateTime(rs.getTimestamp("create_time"));
            cart.setUpdateTime(rs.getTimestamp("update_time"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return cart;
    }

    // ================== 模块四用的清空购物车方法 ==================
    public int clearUserCart(String userId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "DELETE FROM cart WHERE user_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, userId);

        int result = preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
        return result;
    }

    // ================== 兼容方法（保持原样，不影响现有调用） ==================
    public List<Cart> getUserCartList(String userId) throws SQLException, ClassNotFoundException {
        return findCartListByUserId(userId);
    }

    public int addCart(Cart cart) throws SQLException, ClassNotFoundException {
        return addToCart(cart.getUserId(), Long.valueOf(cart.getBookId()), cart.getBuyNum());
    }

    public int updateCartNum(String cartId, Integer num) throws SQLException, ClassNotFoundException {
        return updateBuyNum(cartId, num);
    }

    public int clearCartByUserId(String userId) throws SQLException, ClassNotFoundException {
        return clearUserCart(userId);
    }
}