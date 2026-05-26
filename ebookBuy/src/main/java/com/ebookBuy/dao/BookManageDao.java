package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class BookManageDao {

    // ================== 核心：多条件查询（新增单独作者搜索） ==================
    // ✅ 方法签名新增author参数
    public List<Book> getBookList(String keyword, String author, List<Integer> typeIds, String themeNames, String sortField, String sortOrder)
            throws SQLException, ClassNotFoundException {

        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();

        // 解析主题列表
        List<String> themeList = new ArrayList<>();
        if (themeNames != null && !themeNames.trim().isEmpty()) {
            String[] arr = themeNames.split(",");
            for (String s : arr) {
                String trimmed = s.trim();
                if (!trimmed.isEmpty()) themeList.add(trimmed);
            }
        }

        StringBuilder sqlBuilder = new StringBuilder();
        List<Object> params = new ArrayList<>();

        boolean hasTypeFilter = typeIds != null && !typeIds.isEmpty();
        boolean hasThemeFilter = !themeList.isEmpty();

        if (hasTypeFilter || hasThemeFilter) {
            sqlBuilder.append("SELECT b.* FROM book b ");
            if (hasTypeFilter) {
                sqlBuilder.append("INNER JOIN book_type_rel rel ON b.id = rel.book_id ");
            }
            sqlBuilder.append("WHERE 1=1 ");

            // ✅ 1. 典籍名称搜索（仅匹配标题）
            if (keyword != null && !keyword.trim().isEmpty()) {
                sqlBuilder.append("AND b.book_title LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            }

            // ✅ 2. 新增：单独作者搜索（仅匹配作者）
            if (author != null && !author.trim().isEmpty()) {
                sqlBuilder.append("AND b.book_author LIKE ? ");
                params.add("%" + author.trim() + "%");
            }

            // 类型AND筛选
            if (hasTypeFilter) {
                sqlBuilder.append("AND rel.type_id IN (");
                for (int i = 0; i < typeIds.size(); i++) {
                    sqlBuilder.append(i == 0 ? "?" : ",?");
                    params.add(typeIds.get(i));
                }
                sqlBuilder.append(") ");
            }

            // 主题AND筛选
            if (hasThemeFilter) {
                for (String theme : themeList) {
                    sqlBuilder.append(" AND FIND_IN_SET(?, b.themes) > 0 ");
                    params.add(theme);
                }
            }

            // 分组与HAVING（仅当有类型筛选时需要）
            sqlBuilder.append("GROUP BY b.id ");
            if (hasTypeFilter) {
                sqlBuilder.append("HAVING COUNT(DISTINCT rel.type_id) = ? ");
                params.add(typeIds.size());
            }

        } else {
            // 无类型无主题，仅关键词+作者
            sqlBuilder.append("SELECT b.* FROM book b WHERE 1=1 ");

            // ✅ 1. 典籍名称搜索（仅匹配标题）
            if (keyword != null && !keyword.trim().isEmpty()) {
                sqlBuilder.append("AND b.book_title LIKE ? ");
                params.add("%" + keyword.trim() + "%");
            }

            // ✅ 2. 新增：单独作者搜索（仅匹配作者）
            if (author != null && !author.trim().isEmpty()) {
                sqlBuilder.append("AND b.book_author LIKE ? ");
                params.add("%" + author.trim() + "%");
            }
        }

        // 排序
        if ("id".equals(sortField) && "asc".equals(sortOrder)) {
            sqlBuilder.append(" ORDER BY b.id ASC");
        } else {
            sqlBuilder.append(" ORDER BY b.id DESC");
        }

        PreparedStatement ps = connection.prepareStatement(sqlBuilder.toString());
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        ResultSet rs = ps.executeQuery();

        // 使用LinkedHashMap保持顺序
        Map<Integer, Book> bookMap = new LinkedHashMap<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));           // 旧的主类型字段
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear"));
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            book.setThemes(rs.getString("themes"));
            bookMap.put(book.getId(), book);
        }
        rs.close();
        ps.close();

        // 批量查询关联的类型名
        if (!bookMap.isEmpty()) {
            List<Integer> bookIds = new ArrayList<>(bookMap.keySet());
            StringBuilder idPlaceholders = new StringBuilder();
            for (int i = 0; i < bookIds.size(); i++) {
                idPlaceholders.append(i == 0 ? "?" : ",?");
            }

            String typeSql = "SELECT rel.book_id, d.id type_id, d.type_name FROM book_type_rel rel " +
                    "INNER JOIN book_type_dict d ON rel.type_id = d.id " +
                    "WHERE rel.book_id IN (" + idPlaceholders + ")";
            ps = connection.prepareStatement(typeSql);
            for (int i = 0; i < bookIds.size(); i++) {
                ps.setInt(i + 1, bookIds.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                int bookId = rs.getInt("book_id");
                Book book = bookMap.get(bookId);
                if (book != null) {
                    book.getTypeIds().add(rs.getInt("type_id"));
                    book.getTypeNames().add(rs.getString("type_name"));
                }
            }
            rs.close();
            ps.close();
        }

        connection.close();
        return new ArrayList<>(bookMap.values());
    }

    // ================== 新增书籍（事务，包含多类型和主题） ==================
    public void addBook(Book book) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        connection.setAutoCommit(false);
        try {
            String sql = "INSERT INTO book(book_title, book_author, book_summary, type_id, download_times, " +
                    "book_pubYear, book_file, book_cover, book_format, price, stock, is_sale, try_read_chapter, themes) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, book.getBookTitle());
            ps.setString(2, book.getBookAuthor());
            ps.setString(3, book.getBookSummary());
            // 主类型取第一个（兼容旧逻辑）
            Integer firstType = (book.getTypeIds() != null && !book.getTypeIds().isEmpty()) ? book.getTypeIds().get(0) : 0;
            ps.setInt(4, firstType);
            ps.setObject(5, book.getDownloadTimes());
            ps.setString(6, book.getBookPubYear());
            ps.setString(7, book.getBookFile());
            ps.setString(8, book.getBookCover());
            ps.setString(9, book.getBookFormat());
            ps.setObject(10, book.getPrice());
            ps.setObject(11, book.getStock());
            ps.setObject(12, book.getIsSale());
            ps.setObject(13, book.getTryReadChapter());
            ps.setString(14, book.getThemes());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int bookId = 0;
            if (rs.next()) bookId = rs.getInt(1);
            rs.close();
            ps.close();

            // 插入类型关联
            if (bookId > 0 && book.getTypeIds() != null) {
                String relSql = "INSERT INTO book_type_rel (book_id, type_id) VALUES (?, ?)";
                ps = connection.prepareStatement(relSql);
                for (Integer tid : book.getTypeIds()) {
                    ps.setInt(1, bookId);
                    ps.setInt(2, tid);
                    ps.addBatch();
                }
                ps.executeBatch();
                ps.close();
            }
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }

    // ================== 更新书籍（事务，包含多类型和主题） ==================
    public void updateBook(Book book) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        connection.setAutoCommit(false);
        try {
            String sql = "UPDATE book SET book_title=?, book_author=?, book_summary=?, type_id=?, download_times=?, " +
                    "book_pubYear=?, book_file=?, book_cover=?, book_format=?, price=?, stock=?, is_sale=?, " +
                    "try_read_chapter=?, themes=? WHERE id=?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, book.getBookTitle());
            ps.setString(2, book.getBookAuthor());
            ps.setString(3, book.getBookSummary());
            Integer firstType = (book.getTypeIds() != null && !book.getTypeIds().isEmpty()) ? book.getTypeIds().get(0) : 0;
            ps.setInt(4, firstType);
            ps.setObject(5, book.getDownloadTimes());
            ps.setString(6, book.getBookPubYear());
            ps.setString(7, book.getBookFile());
            ps.setString(8, book.getBookCover());
            ps.setString(9, book.getBookFormat());
            ps.setObject(10, book.getPrice());
            ps.setObject(11, book.getStock());
            ps.setObject(12, book.getIsSale());
            ps.setObject(13, book.getTryReadChapter());
            ps.setString(14, book.getThemes());
            ps.setInt(15, book.getId());
            ps.executeUpdate();
            ps.close();

            // 删除旧类型关联
            ps = connection.prepareStatement("DELETE FROM book_type_rel WHERE book_id=?");
            ps.setInt(1, book.getId());
            ps.executeUpdate();
            ps.close();

            // 插入新类型关联
            if (book.getTypeIds() != null && !book.getTypeIds().isEmpty()) {
                ps = connection.prepareStatement("INSERT INTO book_type_rel (book_id, type_id) VALUES (?, ?)");
                for (Integer tid : book.getTypeIds()) {
                    ps.setInt(1, book.getId());
                    ps.setInt(2, tid);
                    ps.addBatch();
                }
                ps.executeBatch();
                ps.close();
            }
            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }

    // ================== 删除书籍（含关联） ==================
    public void deleteBook(Long bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        connection.setAutoCommit(false);
        try {
            PreparedStatement ps = connection.prepareStatement("DELETE FROM book_type_rel WHERE book_id=?");
            ps.setLong(1, bookId);
            ps.executeUpdate();
            ps.close();

            ps = connection.prepareStatement("DELETE FROM book WHERE id=?");
            ps.setLong(1, bookId);
            ps.executeUpdate();
            ps.close();

            connection.commit();
        } catch (Exception e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
            connection.close();
        }
    }

    // ================== 以下为原有方法（均已保留） ==================
    public List<Book> getAllBooks() throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book";
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        List<Book> list = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear"));
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            book.setThemes(rs.getString("themes"));
            list.add(book);
        }
        rs.close();
        ps.close();
        connection.close();
        return list;
    }

    public List<Book> getBooksByTypeId(int typeId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book WHERE type_id = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, typeId);
        ResultSet rs = ps.executeQuery();
        List<Book> list = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear"));
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            book.setThemes(rs.getString("themes"));
            list.add(book);
        }
        rs.close();
        ps.close();
        connection.close();
        return list;
    }

    public Book findBookById(Long bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book WHERE id = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setLong(1, bookId);
        ResultSet rs = ps.executeQuery();
        Book book = null;
        if (rs.next()) {
            book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear"));
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            book.setThemes(rs.getString("themes"));
        }
        rs.close();
        ps.close();
        connection.close();
        return book;
    }

    public int updateBookStock(Integer bookId, Integer num) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE book SET stock = stock - ? WHERE id = ? AND stock >= ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, num);
        ps.setInt(2, bookId);
        ps.setInt(3, num);
        int result = ps.executeUpdate();
        ps.close();
        connection.close();
        return result;
    }

    public List<Book> searchBooks(String keyword) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book WHERE book_title LIKE ? OR book_author LIKE ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, "%" + keyword + "%");
        ps.setString(2, "%" + keyword + "%");
        ResultSet rs = ps.executeQuery();
        List<Book> list = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            book.setBookSummary(rs.getString("book_summary"));
            book.setTypeId(rs.getInt("type_id"));
            book.setDownloadTimes(rs.getInt("download_times"));
            book.setBookPubYear(rs.getString("book_pubYear"));
            book.setBookFile(rs.getString("book_file"));
            book.setBookCover(rs.getString("book_cover"));
            book.setBookFormat(rs.getString("book_format"));
            book.setPrice(rs.getDouble("price"));
            book.setStock(rs.getInt("stock"));
            book.setIsSale(rs.getInt("is_sale"));
            book.setTryReadChapter(rs.getInt("try_read_chapter"));
            book.setThemes(rs.getString("themes"));
            list.add(book);
        }
        rs.close();
        ps.close();
        connection.close();
        return list;
    }

    public boolean updateBookStockTx(Connection conn, Integer bookId, int num) throws SQLException {
        String sql = "UPDATE book SET stock = stock - ? WHERE id = ? AND stock >= ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, num);
        pstmt.setInt(2, bookId);
        pstmt.setInt(3, num);
        int affectedRows = pstmt.executeUpdate();
        pstmt.close();
        return affectedRows > 0;
    }

    public int getBookStock(Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT stock FROM book WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, bookId);
        ResultSet rs = pstmt.executeQuery();
        int stock = 0;
        if (rs.next()) stock = rs.getInt("stock");
        rs.close();
        pstmt.close();
        conn.close();
        return stock;
    }

    public void updateBookStock(Connection conn, Integer bookId, int num) throws SQLException {
        String sql = "UPDATE book SET stock = stock + ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, num);
        pstmt.setInt(2, bookId);
        pstmt.executeUpdate();
        pstmt.close();
    }

    public List<Book> findAllBook() throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book ORDER BY id DESC";
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        List<Book> list = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId((int) rs.getLong("id"));
            book.setBookTitle(rs.getString("book_title"));
            book.setBookAuthor(rs.getString("book_author"));
            // 可根据需要添加其他字段
            list.add(book);
        }
        rs.close();
        ps.close();
        connection.close();
        return list;
    }

    // ================== 新增：增加典籍下载次数 ==================
    public void increaseDownloadTimes(int bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();

        String sql = "UPDATE book SET download_times = download_times + 1 WHERE id = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, bookId);
        ps.executeUpdate();

        ps.close();
        connection.close();
    }
}