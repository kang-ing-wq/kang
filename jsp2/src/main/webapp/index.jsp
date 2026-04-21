<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/10
  Time: 8:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
欢迎光临！！
<p style="color: crimson"><%=request.getParameter("msg") == null ? "" : request.getParameter("msg")%></p>

<form action="denglu.jsp" method="post">
    用户名：<input type="text" name="username"><br>
    密码：<input type="password" name="password"><br>


    <input type="submit" value="登录">
</form>

网站：<select name="city">
    <option value="京东">京东</option>
    <option value="淘宝">淘宝</option>
    <option value="拼多多">拼多多</option>
    </select>


购物车的页面<br>
<a href="">购物</a><br>
<a href="../../../../jspSession1/src/main/webapp/gouwu.jsp">显示商品</a>


</body>
</html>
