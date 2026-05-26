package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.Chapter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ChapterDao {

    // ================== 核心方法 ==================
    /**
     * 根据典籍ID查询章节列表（用于目录渲染）
     */
    public List<Chapter> findChapterListByBookId(Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book_chapter WHERE book_id = ? ORDER BY chapter_num ASC";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        List<Chapter> chapterList = new ArrayList<>();
        while (rs.next()) {
            Chapter chapter = new Chapter();
            // 【修复】bigint用getLong读取，匹配Chapter的Long类型
            chapter.setId(rs.getLong("id"));
            chapter.setBookId(rs.getLong("book_id"));
            chapter.setChapterNum(rs.getInt("chapter_num"));
            chapter.setChapterTitle(rs.getString("chapter_title"));
            chapter.setChapterContent(rs.getString("chapter_content"));
            chapter.setCreateTime(rs.getTimestamp("create_time"));
            chapterList.add(chapter);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapterList;
    }

    /**
     * 根据典籍ID和章节号查询章节内容（用于阅读）
     */
    public Chapter findChapterContent(Integer bookId, Integer chapterNum) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book_chapter WHERE book_id = ? AND chapter_num = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, bookId);
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
            chapter.setCreateTime(rs.getTimestamp("create_time"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapter;
    }

    /**
     * 获取典籍的总章节数
     */
    public int getChapterCountByBookId(Integer bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT COUNT(*) FROM book_chapter WHERE book_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, bookId);
        ResultSet rs = preparedStatement.executeQuery();

        int count = 0;
        if (rs.next()) {
            count = rs.getInt(1);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return count;
    }

    /**
     * 新增章节（录入章节用）
     */
    public void addChapter(Chapter chapter) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "INSERT INTO book_chapter(book_id, chapter_num, chapter_title, chapter_content) VALUES (?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        // 【修复】Long类型用setLong设置
        preparedStatement.setLong(1, chapter.getBookId());
        preparedStatement.setInt(2, chapter.getChapterNum());
        preparedStatement.setString(3, chapter.getChapterTitle());
        preparedStatement.setString(4, chapter.getChapterContent());

        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
    }

    /**
     * 根据章节ID查询章节（编辑章节用）
     */
    public Chapter findChapterById(Long chapterId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM book_chapter WHERE id = ?";
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
            chapter.setCreateTime(rs.getTimestamp("create_time"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return chapter;
    }

    /**
     * 更新章节内容（编辑章节用）
     */
    public void updateChapter(Chapter chapter) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE book_chapter SET chapter_num = ?, chapter_title = ?, chapter_content = ? WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, chapter.getChapterNum());
        preparedStatement.setString(2, chapter.getChapterTitle());
        preparedStatement.setString(3, chapter.getChapterContent());
        preparedStatement.setLong(4, chapter.getId());

        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
    }

    /**
     * 根据典籍ID删除所有章节（删除典籍时级联删除）
     */
    public void deleteChapterByBookId(Long bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "DELETE FROM book_chapter WHERE book_id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setLong(1, bookId);

        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
    }
}