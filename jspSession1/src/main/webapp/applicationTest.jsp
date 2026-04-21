<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/16
  Time: 8:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    if (username.equals("zk") && password.equals("123")){
        if (application.getAttribute("pcount")==null){
            application.setAttribute("pcount",1);
        }
        else {
            Integer pcount = (Integer) application.getAttribute("pcount");
            pcount++;
            application.setAttribute("pcount",pcount);
        }
        request.getRequestDispatcher("index.jsp").forward(request,response);
    }
%>
</body>
</html>
