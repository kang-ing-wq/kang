package com.ebookBuy;

import com.ebookBuy.dao.UsersDao;
import com.ebookBuy.pojo.User;

import java.sql.SQLException;

public class UserTest1 {

    public static  void main(String[] args) throws SQLException, ClassNotFoundException {
        UsersDao usersDao = new UsersDao();
        System.out.println("全表数据"+usersDao.getAllUsers());
        System.out.println("查询单行如下：");
        String id = "u_xufengnian";
//        usersDao.getUserById(id);

//        usersDao.delUser(id);
//        System.out.println("id为"+id+"的已经删除了");


        //把id为15行的修改为大王

//        User user = new User();
//        user.setId(id);
//        user.setUsername("大王");
//        user.setPassword("123456");
//        user.setSex("男");
//        user.setAge(13);
//        user.setEmail("12456@dsda.com");
//        usersDao.updateUser(user);


        // 新增用户
        User newUser = new User();
        newUser.setId("AAAApi_yujie");
        newUser.setUsername("yujie");
        newUser.setPassword("123456");
        newUser.setSex("女");
        newUser.setAge(38);
        newUser.setEmail("12456@yujie.com");
        usersDao.addUser(newUser);
        System.out.println("新增用户完成");

        System.out.println("新增后的全表数据"+usersDao.getAllUsers());

    }
}

