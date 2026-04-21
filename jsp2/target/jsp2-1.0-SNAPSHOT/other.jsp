<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/10
  Time: 11:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
这个办法不能获取用户ID！。。<br>
<%=request.getParameter("username")%><br>
------------------------------------------<br>
哦耶！！！成功获取用户ID！！<br>
<%=session.getAttribute("username")%><br>
</body>
</html>
