package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;          // 使用项目已有的数据库连接工具类
import com.ebookBuy.pojo.GameStory;
import com.ebookBuy.pojo.GameProgress;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GameDao {

    // ==================== 剧情管理 ====================

    // 查询某本书的所有剧情节点
    public List<GameStory> getStoryNodesByBookId(int bookId) throws SQLException, ClassNotFoundException {
        List<GameStory> list = new ArrayList<>();
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT * FROM game_story WHERE book_id = ? ORDER BY node_id";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, bookId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            GameStory story = new GameStory();
            story.setId(rs.getInt("id"));
            story.setBookId(rs.getInt("book_id"));
            story.setChapterId(rs.getObject("chapter_id") != null ? rs.getInt("chapter_id") : null);
            story.setNodeId(rs.getString("node_id"));
            story.setNodeTitle(rs.getString("node_title"));
            story.setStoryText(rs.getString("story_text"));
            story.setOptions(rs.getString("options"));
            story.setRequirements(rs.getString("requirements"));
            story.setRewards(rs.getString("rewards"));
            list.add(story);
        }
        rs.close();
        ps.close();
        conn.close();
        return list;
    }

    // 根据节点ID获取单个剧情节点
    public GameStory getStoryByNodeId(int bookId, String nodeId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT * FROM game_story WHERE book_id = ? AND node_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, bookId);
        ps.setString(2, nodeId);
        ResultSet rs = ps.executeQuery();

        GameStory story = null;
        if (rs.next()) {
            story = new GameStory();
            story.setId(rs.getInt("id"));
            story.setBookId(rs.getInt("book_id"));
            story.setChapterId(rs.getObject("chapter_id") != null ? rs.getInt("chapter_id") : null);
            story.setNodeId(rs.getString("node_id"));
            story.setNodeTitle(rs.getString("node_title"));
            story.setStoryText(rs.getString("story_text"));
            story.setOptions(rs.getString("options"));
            story.setRequirements(rs.getString("requirements"));
            story.setRewards(rs.getString("rewards"));
        }
        rs.close();
        ps.close();
        conn.close();
        return story;
    }

    // 新增剧情节点
    public void addStoryNode(GameStory story) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "INSERT INTO game_story (book_id, chapter_id, node_id, node_title, story_text, options, requirements, rewards) VALUES (?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, story.getBookId());
        if (story.getChapterId() != null) {
            ps.setInt(2, story.getChapterId());
        } else {
            ps.setNull(2, Types.INTEGER);
        }
        ps.setString(3, story.getNodeId());
        ps.setString(4, story.getNodeTitle());
        ps.setString(5, story.getStoryText());
        ps.setString(6, story.getOptions());
        ps.setString(7, story.getRequirements());
        ps.setString(8, story.getRewards());
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    // 更新剧情节点
    public void updateStoryNode(GameStory story) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "UPDATE game_story SET book_id=?, chapter_id=?, node_id=?, node_title=?, story_text=?, options=?, requirements=?, rewards=? WHERE id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, story.getBookId());
        if (story.getChapterId() != null) {
            ps.setInt(2, story.getChapterId());
        } else {
            ps.setNull(2, Types.INTEGER);
        }
        ps.setString(3, story.getNodeId());
        ps.setString(4, story.getNodeTitle());
        ps.setString(5, story.getStoryText());
        ps.setString(6, story.getOptions());
        ps.setString(7, story.getRequirements());
        ps.setString(8, story.getRewards());
        ps.setInt(9, story.getId());
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    // 删除剧情节点
    public void deleteStoryNode(int id) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "DELETE FROM game_story WHERE id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    public List<Map<String, Object>> getBooksWithGames() throws SQLException, ClassNotFoundException {
        List<Map<String, Object>> list = new ArrayList<>();
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        // 增加 book_cover 和 book_author 字段
        String sql = "SELECT DISTINCT b.id, b.book_title, b.book_cover, b.book_author FROM game_story g JOIN book b ON g.book_id = b.id";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> book = new HashMap<>();
            book.put("id", rs.getInt("id"));
            book.put("bookTitle", rs.getString("book_title"));
            book.put("bookCover", rs.getString("book_cover"));
            book.put("bookAuthor", rs.getString("book_author"));
            list.add(book);
        }
        rs.close();
        ps.close();
        conn.close();
        return list;
    }

    // ==================== 游戏进度管理 ====================

    // 获取用户某本书的游戏进度
    public GameProgress getProgress(String userId, int bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT * FROM game_progress WHERE user_id = ? AND book_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userId);
        ps.setInt(2, bookId);
        ResultSet rs = ps.executeQuery();

        GameProgress progress = null;
        if (rs.next()) {
            progress = new GameProgress();
            progress.setId(rs.getInt("id"));
            progress.setUserId(rs.getString("user_id"));
            progress.setBookId(rs.getInt("book_id"));
            progress.setCurrentNode(rs.getString("current_node"));
            progress.setPlayerAttrs(rs.getString("player_attrs"));
            progress.setChoicesHistory(rs.getString("choices_history"));
            progress.setGameStatus(rs.getInt("game_status"));
        }
        rs.close();
        ps.close();
        conn.close();
        return progress;
    }

    // 保存/更新游戏进度（先更新，无则插入）
    public void saveProgress(GameProgress progress) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        // 先尝试更新
        String updateSql = "UPDATE game_progress SET current_node=?, player_attrs=?, choices_history=?, game_status=? WHERE user_id=? AND book_id=?";
        PreparedStatement updatePs = conn.prepareStatement(updateSql);
        updatePs.setString(1, progress.getCurrentNode());
        updatePs.setString(2, progress.getPlayerAttrs());
        updatePs.setString(3, progress.getChoicesHistory());
        updatePs.setInt(4, progress.getGameStatus());
        updatePs.setString(5, progress.getUserId());
        updatePs.setInt(6, progress.getBookId());
        int rows = updatePs.executeUpdate();

        if (rows == 0) {
            // 不存在，则插入新记录
            String insertSql = "INSERT INTO game_progress (user_id, book_id, current_node, player_attrs, choices_history, game_status) VALUES (?,?,?,?,?,?)";
            PreparedStatement insertPs = conn.prepareStatement(insertSql);
            insertPs.setString(1, progress.getUserId());
            insertPs.setInt(2, progress.getBookId());
            insertPs.setString(3, progress.getCurrentNode());
            insertPs.setString(4, progress.getPlayerAttrs());
            insertPs.setString(5, progress.getChoicesHistory());
            insertPs.setInt(6, progress.getGameStatus());
            insertPs.executeUpdate();
            insertPs.close();
        }
        updatePs.close();
        conn.close();
    }

    public void deleteProgress(String userId, int bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "DELETE FROM game_progress WHERE user_id = ? AND book_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userId);
        ps.setInt(2, bookId);
        ps.executeUpdate();
        ps.close();
        conn.close();
    }
    // 获取书名
    public String getBookTitleById(int bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT book_title FROM book WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, bookId);
        ResultSet rs = ps.executeQuery();
        String title = null;
        if (rs.next()) {
            title = rs.getString("book_title");
        }
        rs.close();
        ps.close();
        conn.close();
        return title;
    }


    // 获取用户所有游戏进度，返回 Map<bookId, GameProgress>
    public Map<Integer, GameProgress> getProgressMapForUser(String userId) throws SQLException, ClassNotFoundException {
        Map<Integer, GameProgress> map = new HashMap<>();
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT * FROM game_progress WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            GameProgress p = new GameProgress();
            p.setId(rs.getInt("id"));
            p.setUserId(rs.getString("user_id"));
            p.setBookId(rs.getInt("book_id"));
            p.setCurrentNode(rs.getString("current_node"));
            p.setPlayerAttrs(rs.getString("player_attrs"));
            p.setChoicesHistory(rs.getString("choices_history"));
            p.setGameStatus(rs.getInt("game_status"));
            map.put(p.getBookId(), p);
        }
        rs.close();
        ps.close();
        conn.close();
        return map;
    }

    // 检查用户是否已通关（当前节点为结局节点）
    public boolean isGameFinished(String userId, int bookId) throws SQLException, ClassNotFoundException {
        GameProgress progress = getProgress(userId, bookId);
        if (progress == null) return false;
        GameStory currentStory = getStoryByNodeId(bookId, progress.getCurrentNode());
        if (currentStory == null) return true;  // 没有对应节点视为结束
        String options = currentStory.getOptions();
        return options == null || options.trim().isEmpty() || options.equals("[]");
    }

    // 获取某本书的剧情节点总数
    public int getNodeCountByBookId(int bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT COUNT(*) FROM game_story WHERE book_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, bookId);
        ResultSet rs = ps.executeQuery();
        int count = 0;
        if (rs.next()) {
            count = rs.getInt(1);
        }
        rs.close();
        ps.close();
        conn.close();
        return count;
    }

    // 获取某本书第一个节点的剧情文本（按节点ID排序取第一条）
    public String getFirstNodeTextByBookId(int bookId) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection conn = dbManager.getConnection();
        String sql = "SELECT story_text FROM game_story WHERE book_id = ? ORDER BY node_id LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, bookId);
        ResultSet rs = ps.executeQuery();
        String text = "";
        if (rs.next()) {
            text = rs.getString("story_text");
        }
        rs.close();
        ps.close();
        conn.close();
        return text;
    }
}