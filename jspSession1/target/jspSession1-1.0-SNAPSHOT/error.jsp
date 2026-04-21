<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/16
  Time: 9:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h3 style="color: crimson">出现错误了喵!</h3>
<img style="width: 200px; height: 200px;" src="img/111.jpg">
<%= exception.getMessage()%>
</body>
</html>
