<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/12
  Time: 15:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    Integer count;
    if (session.getAttribute("count")==null){
        count = 1;
        session.setAttribute("count",1);
    }else {
        count = (Integer)session.getAttribute("count");
        count++;
        session.setAttribute("count",count);
    }
    request.getRequestDispatcher("gouwu.jsp").forward(request,response);
%>
</body>
</html>
