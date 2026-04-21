<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/9
  Time: 9:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
OK啊，也是跳到这里了！
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username.equals("zk") && password.equals("123456")){
        request.getRequestDispatcher("chenggong.jsp").forward(request,response);
    }else {
        request.getRequestDispatcher("shibai.jsp").forward(request,response);
    }
%>
<%=username + "---" + password%>
</body>
</html>
