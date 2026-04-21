<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/9
  Time: 10:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>用户注册页面</h1>
<fieldset>
  <form action="zhuceed.jsp" method="post">
    用户名：<input type="text" name="username"><br>
    密码：<input type="password" name="password"><br>
    出生日期：<input type="date" name="date"><br>
    邮箱：<input type="text" name="youxiang"><br>
    性别：<input type="radio" name="sex" value="男" checked>男
    <input type="radio" name="sex" value="女">女<br>
    爱好：<input type="checkbox" name="hobby" value="看电影">看电影
    <input type="checkbox" name="hobby" value="看小说">看小说
    <input type="checkbox" name="hobby" value="打游戏">打游戏<br>
    <%-- 修复：给省份select添加name属性 --%>
    省份：<select name="province">
    <option value="北京">北京</option>
    <option value="四川">四川</option>
    <option value="河北">河北</option>
  </select><br>
    前女友：<select name="gf">
    <option value="小白">小白</option>
    <option value="小蓝">小蓝</option>
    <option value="小红">小红</option>
  </select><br>
    个人简介：<textarea name="msg" rows="6" cols="30"></textarea><br> <%-- 调整cols宽度，更友好 --%>
    <input type="submit" value="注册">
  </form>
</fieldset>
</body>
</html>
