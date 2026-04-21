<%@ page import="com.pojo.Person" %><%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/19
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%=request.getParameter("name")%>**********************
    Hello Majiaqi<br>
===============================<br>

<%
    Person p3 = (Person) session.getAttribute("p3");
%>
姓名：<%=p3.getName()%><br>
年龄：<%=p3.getAge()%>岁<br>
</body>
</html>
