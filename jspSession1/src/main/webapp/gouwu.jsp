<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/12
  Time: 15:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
购物车商品如下：<br>
商品：<%=session.getAttribute("count")%><br>
<a href="maidongxi.jsp">继续购物</a>

</body>
</html>
