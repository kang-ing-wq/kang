<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/12
  Time: 15:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
购物车的页面<br>
<a href="">购物</a><br>
<a href="gouwu.jsp">显示商品</a>

<fieldset>
    目前的登录人数为：<%= application.getAttribute("pcount")==null? 0:application.getAttribute("pcount")%>
    --登录--
    <form action="applicationTest.jsp" method="post">
        用户名：<input type="text" name="username"><br>
        密码：<input type="password" name="password"><br>
        <input type="submit" value="登录">
    </form>
</fieldset>

<fieldset>
    --错误页面示范！！--
    <form action="errorCreate.jsp" method="post">
        <input type="submit" value="go to 神秘之地">

    </form>
</fieldset>
</body>
</html>

