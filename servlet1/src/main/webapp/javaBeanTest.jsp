<%@ page import="com.pojo.Person" %><%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/23
  Time: 8:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    Person p2 = new Person();
    p2.setName("王五");
%><br>
<jsp:useBean id="p1" class="com.pojo.Person" scope="page">
    <jsp:setProperty name="p1" property="name" value="大爱仙尊--这是张三"></jsp:setProperty>
    <jsp:setProperty name="p1" property="age" value="1000"></jsp:setProperty>
</jsp:useBean><br>
=========================================================<br>
<jsp:getProperty name="p1" property="name"/><br>
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++<br>
<jsp:getProperty name="p1" property="age"/><br>
<%=p1.getName()%>
---------------------------------------------------------<br>
<jsp:useBean id="p3" class="com.pojo.Person" scope="session">
    <jsp:setProperty name="p3" property="name" value="红莲魔尊--这是王五"></jsp:setProperty>
    <jsp:setProperty name="p3" property="age" value="200000"></jsp:setProperty>
</jsp:useBean><br>
*********************************************************<br>
<fieldset>
    <a href="majiaqi.jsp">点击跳转精彩页面</a>
</fieldset>


你好，欢迎您<%=session.getAttribute("username")%>

<jsp:include page="xianggang.jsp"></jsp:include>

</body>
</html>
