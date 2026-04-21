<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/9
  Time: 8:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
历经五十四次劫
<%
    String name = request.getParameter("name");
    System.out.printf("name");
    String password = request.getParameter("password");

    System.out.printf("password");
%>
姓名：<%=name%>
密码：<%=password%>
劫云仍旧漫遮天
</body>
</html>
