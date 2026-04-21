package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Book;
import com.ebookBuy.pojo.Chapter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ChapterDao {

    // 查询书籍的所有章节列表（只查序号和标题）
    public List<Chapter> findChapterListByBookId(Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 字段名和数据库book_chapter表完全匹配
        String sql = "SELECT id, book_id, chapter_num, chapter_title FROM book_chapter WHERE book_id = ? ORDER BY chapter_num ASC";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setLong(1, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        List<Chapter> chapterList = new ArrayList<>();
        while (rs.next()) {
            Chapter chapter = new Chapter();
            chapter.setId(rs.getLong("id"));
            chapter.setBookId(rs.getLong("book_id"));
            chapter.setChapterNum(rs.getInt("chapter_num"));
            chapter.setChapterTitle(rs.getString("chapter_title"));
            chapterList.add(chapter);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapterList;
    }

    // 根据书籍ID和章节序号，查询章节正文内容
    public Chapter findChapterContent(Integer bookId, Integer chapterNum) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 字段名和数据库完全匹配
        String sql = "SELECT id, book_id, chapter_num, chapter_title, chapter_content FROM book_chapter WHERE book_id = ? AND chapter_num = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setLong(1, bookId);
        preparedStatement.setInt(2, chapterNum);
        ResultSet rs = preparedStatement.executeQuery();

        Chapter chapter = null;
        if (rs.next()) {
            chapter = new Chapter();
            chapter.setId(rs.getLong("id"));
            chapter.setBookId(rs.getLong("book_id"));
            chapter.setChapterNum(rs.getInt("chapter_num"));
            chapter.setChapterTitle(rs.getString("chapter_title"));
            chapter.setChapterContent(rs.getString("chapter_content"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapter;
    }

    // 新增章节（录入小说内容用）
    public void addChapter(Chapter chapter) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 字段名和数据库book_chapter表完全匹配
        String sql = "INSERT INTO book_chapter(book_id, chapter_num, chapter_title, chapter_content) VALUES (?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setLong(1, chapter.getBookId());
        preparedStatement.setInt(2, chapter.getChapterNum());
        preparedStatement.setString(3, chapter.getChapterTitle());
        preparedStatement.setString(4, chapter.getChapterContent());

        preparedStatement.execute();
        preparedStatement.close();
        connection.close();
    }

    // 查询所有书籍列表（给录入页下拉框用）
    public List<Book> getAllBookList() throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 核心修正：数据库字段是book_title，用as别名对应Book类的bookTitle属性
        String sql = "select id, book_title as bookTitle from book";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();

        List<Book> bookList = new ArrayList<>();
        while (rs.next()) {
            Book book = new Book();
            book.setId((int) rs.getLong("id"));
            book.setBookTitle(rs.getString("bookTitle")); // 这里和别名对应，能正常拿到值
            bookList.add(book);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return bookList;
    }

    // 根据章节ID，查询单条章节的完整信息（编辑用）
    public Chapter findChapterById(Long chapterId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT id, book_id, chapter_num, chapter_title, chapter_content FROM book_chapter WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setLong(1, chapterId);
        ResultSet rs = preparedStatement.executeQuery();

        Chapter chapter = null;
        if (rs.next()) {
            chapter = new Chapter();
            chapter.setId(rs.getLong("id"));
            chapter.setBookId(rs.getLong("book_id"));
            chapter.setChapterNum(rs.getInt("chapter_num"));
            chapter.setChapterTitle(rs.getString("chapter_title"));
            chapter.setChapterContent(rs.getString("chapter_content"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapter;
    }

    // 修改章节的标题和正文（补内容、改内容用）
    public void updateChapter(Chapter chapter) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE book_chapter SET chapter_title=?, chapter_content=? WHERE id=?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, chapter.getChapterTitle());
        preparedStatement.setString(2, chapter.getChapterContent());
        preparedStatement.setLong(3, chapter.getId());

        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
    }
}