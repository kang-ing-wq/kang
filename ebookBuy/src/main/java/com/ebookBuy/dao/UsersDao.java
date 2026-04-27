package com.ebookBuy.dao;

import com.ebookBuy.db.DBManager;
import com.ebookBuy.pojo.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsersDao {

    // ================== 登录/注册相关方法 ==================
    // 根据用户名和密码查询用户（登录用）
    public User findUserByUsernameAndPwd(String username, String password) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, username);
        preparedStatement.setString(2, password);
        ResultSet rs = preparedStatement.executeQuery();

        User user = null;
        if (rs.next()) {
            user = new User();
            // 全字段赋值，和数据库表完全对应
            user.setId(rs.getString("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setSex(rs.getString("sex"));
            user.setAge(rs.getInt("age"));
            user.setEmail(rs.getString("email"));
            user.setUserTitle(rs.getString("user_title"));
            user.setAvatarPath(rs.getString("avatar_path"));
            user.setReadChapterNum(rs.getInt("read_chapter_num"));
            user.setReadBookNum(rs.getInt("read_book_num"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return user;
    }

    // 根据用户名查询用户（注册查重用）
    public User findUserByUsername(String username) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM user WHERE username = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, username);
        ResultSet rs = preparedStatement.executeQuery();

        User user = null;
        if (rs.next()) {
            user = new User();
            user.setId(rs.getString("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return user;
    }

    // 新增用户（注册+新增人员用，适配你表单的所有字段）
    public void addUser(User user) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 适配你的register.jsp表单：id, username, password, sex, age, email, user_title, avatar_path
        String sql = "INSERT INTO user(id, username, password, sex, age, email, user_title, avatar_path) VALUES (UUID(),?,?,?,?,?,?,?)";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, user.getUsername());
        preparedStatement.setString(2, user.getPassword());
        preparedStatement.setString(3, user.getSex());
        preparedStatement.setInt(4, user.getAge());
        preparedStatement.setString(5, user.getEmail());
        preparedStatement.setString(6, user.getUserTitle());
        preparedStatement.setString(7, user.getAvatarPath());

        preparedStatement.execute();
        preparedStatement.close();
        connection.close();
    }

    // 更新用户头衔
    public void updateUserTitle(String userId, String newTitle) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "UPDATE user SET user_title = ? WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, newTitle);
        preparedStatement.setString(2, userId);

        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
    }

    // ================== 人员名录原有方法（保留，适配String类型id） ==================
    // 查询所有用户（人员注册名录用）
    // 查询所有用户（人员注册名录用，【修改】新增头像字段）
    public List<User> findAllUsers() throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM user";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        ResultSet rs = preparedStatement.executeQuery();

        List<User> userList = new ArrayList<>();
        while (rs.next()) {
            User user = new User();
            user.setId(rs.getString("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setSex(rs.getString("sex"));
            user.setAge(rs.getInt("age"));
            user.setEmail(rs.getString("email"));
            user.setUserTitle(rs.getString("user_title"));
            // 【新增】封装头像路径
            user.setAvatarPath(rs.getString("avatar_path"));
            userList.add(user);
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return userList;
    }

    // 删除用户
    public void deleteUserById(String id) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "DELETE FROM user WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, id);
        preparedStatement.execute();
        preparedStatement.close();
        connection.close();
    }

    // 根据ID查询用户（【修改】新增头像字段，用于修改弹窗回显）
    public User findUserById(String id) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        String sql = "SELECT * FROM user WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, id);
        ResultSet rs = preparedStatement.executeQuery();

        User user = null;
        if (rs.next()) {
            user = new User();
            user.setId(rs.getString("id"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setSex(rs.getString("sex"));
            user.setAge(rs.getInt("age"));
            user.setEmail(rs.getString("email"));
            user.setUserTitle(rs.getString("user_title"));
            // 【新增】封装头像路径
            user.setAvatarPath(rs.getString("avatar_path"));
        }

        rs.close();
        preparedStatement.close();
        connection.close();
        return user;
    }

    // 更新用户信息
    // 更新用户信息（【修改】新增头像字段更新）
    public void updateUser(User user) throws SQLException, ClassNotFoundException {
        DBManager dbManager = new DBManager();
        Connection connection = dbManager.getConnection();
        // 【修改】SQL新增 avatar_path 字段更新
        String sql = "UPDATE user SET username = ?, password = ?, sex = ?, age = ?, email = ?, avatar_path = ? WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);

        preparedStatement.setString(1, user.getUsername());
        preparedStatement.setString(2, user.getPassword());
        preparedStatement.setString(3, user.getSex());
        preparedStatement.setInt(4, user.getAge());
        preparedStatement.setString(5, user.getEmail());
        // 【新增】设置头像路径参数
        preparedStatement.setString(6, user.getAvatarPath());
        preparedStatement.setString(7, user.getId());

        preparedStatement.executeUpdate();
        preparedStatement.close();
        connection.close();
    }

    public String getAllUsers() {
        return "";
    }
}