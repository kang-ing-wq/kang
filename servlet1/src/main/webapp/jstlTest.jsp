<%@ page import="java.lang.reflect.Array" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.pojo.Person" %><%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/24
  Time: 11:16
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%--<c:if test="true">--%>
<%--  你是我的谁？--%>
<%--</c:if>--%>
<%
//    int a = 10;
    int dengji = 1;
    int danjia = 100;
    int count = 2;
    int yuohui = 0;
    double total = 0;

    request.setAttribute("dengji",dengji);
    request.setAttribute("danjia",danjia);
    request.setAttribute("count",count);
    request.setAttribute("yuohui",yuohui);
    request.setAttribute("total",total);

    //后台传一个人类的集合
    ArrayList<Person> pList = new ArrayList<Person>();
    pList.add(new Person("张三",29));
    pList.add(new Person("李四",29));
    pList.add(new Person("王五",29));
    pList.add(new Person("刘六",29));
    session.setAttribute("pList",pList);


//    request.setAttribute("a",a);
%>
<%--<c:out value="${a}"></c:out>--%>
<c:if test="${dengji == 1}">
    <c:set var="yuohui" value="0.9"><%--打九折--%></c:set>
</c:if>

<c:if test="${dengji == 2}">
    <c:set var="yuohui" value="0.8"><%--打八折--%></c:set>
</c:if>

<c:if test="${dengji == 3}">
    <c:set var="yuohui" value="0.7"><%--打七折--%></c:set>
</c:if>

<c:set var="total" value="${danjia * count * yuohui}"></c:set>

最终结果
<p>购买的数量：<c:out value="${count}"></c:out></p>
<p>购买的价钱：<c:out value="${danjia}"></c:out></p>
<p>会员等级：<c:out value="${dengji}"></c:out></p>
<p>应该付款总价：<c:out value="${total}"></c:out></p>


<c:forEach items="${pList}" var="p">
<table>
    <tr>
        <td>
            <c:out value="${p.name}"></c:out>
        </td>
        <td>
            <c:out value="${p.age}"></c:out>
        </td>
    </tr>
    </c:forEach>

</table>
<fieldset>
    格式标签
    <%
        double price = 98.44599;
        request.setAttribute("price",price);
    %>

    <c:out value="${price}"></c:out>
    货币格式：<fmt:formatNumber value="${price}" type="currency"></fmt:formatNumber>
    百分比格式：<fmt:formatNumber value="${price}" type="percent"></fmt:formatNumber>
    四舍五入格式：<fmt:formatNumber value="${price}" maxFractionDigits="1"></fmt:formatNumber>
    <%
        java.util.Date nowDate = new java.util.Date();
        request.setAttribute("nowDate", nowDate);
    %>
    <p>日期格式 yyyy-MM-dd HH:mm:ss：
        <fmt:formatDate value="${nowDate}" pattern="yyyy-MM-dd HH:mm:ss" />
    </p>
</fieldset>



</body>
</html>
