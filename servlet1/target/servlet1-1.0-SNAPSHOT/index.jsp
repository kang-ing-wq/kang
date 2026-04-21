<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/16
  Time: 11:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

你好，欢迎您<%=session.getAttribute("username")%>
第一个Servlet
<br>
<a href="myServlet">点击servlet1</a>
<a href="myServlet2">点击servlet2</a>
<a href="helloServlet">点击helloservlet</a>
<a href="myServlet?name=孙悟空">点击带参数的超链接跳转</a>
<a href="myServlet?name=马假期">点击马假期</a>
<a></a>

<fieldset>
    登录
    <form action="loing" method="post">
        用户名：<input name="username" type="text" >
        密码：<input name="password" type="password">
        <input type="submit" value="登录">
    </form>


</fieldset>


<fieldset>
    请求地址匹配
    1.都是仙qwq！！
    <a href="ts/swk">孙悟空</a>
    <a href="ts/zbj">猪八戒</a>
    <a href="ts/blm">白龙马</a>
    <a href="ts/swj">沙悟净</a>

    2.脑袋有项圈的
    <a href="swk.do">孙悟空</a>
    <a href="zbj.do">猪八戒</a>
    <a href="blm.do">白龙马</a>
    <a href="swj.do">沙悟净</a>
</fieldset>

<fieldset>
    <a href="javaBeanTest.jsp">跳转到Javatest里</a><br>
</fieldset>


<fieldset>
    EL表达式
    <a href="elservlet?name=山楂">这是山楂噢</a>

    <%
//        request.setAttribute("name1","苹果");
        session.setAttribute("name1","香蕉");
    %>
    <a href="pg.jsp?name=苹果">这是苹果噢</a>

    <a href="pServlet">这是水杯噢</a>
</fieldset>
<%--<jsp:forward page="xianggang.jsp"></jsp:forward>--%>
<jsp:include page="xianggang.jsp"></jsp:include>

<fieldset>
    <a href="jstlTest.jsp">会员购物入口</a>

</fieldset>
</body>
</html>
