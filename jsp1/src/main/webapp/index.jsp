<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/9
  Time: 8:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        .myimg{
            width: 300px;
            height: auto;
        }
    </style>
</head>
<body>
<%
    int a = 3;
    int b = 2;
    System.out.printf("==============" + (a + b));
%>
<img src="./images/111.jpg" class="myimg">
<a href="index2.jsp?name=zk">
    <button>gogogo1</button>
</a>
------跳转至其他页面

<%--带两个参数--%>
<a href="index2.jsp?name=zk&password=zkdawang666">
    <button>gogogo2</button>
</a>
------跳转到第二个页面

<%--post请求，带参数，登录--%>
<fieldset>
    <form action="index3.jsp" method="post">
        <legend>
            用户名：<input type="text" name="username"><br>
            密码：<input type="password" name="password"><br>
            <input type="submit" value="登录">
        </legend>
    </form>
</fieldset>

<%--注册！！！--%>
<a href="zhuce.jsp">
    <button>---注册---</button>
</a>
</body>
</html>
