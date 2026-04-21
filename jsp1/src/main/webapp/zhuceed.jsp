<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/9
  Time: 10:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>注册结果</title>
</head>
<body>
<%
    // 修复1：设置请求编码，解决POST中文乱码问题
    request.setCharacterEncoding("UTF-8");

    // 获取表单参数，增加非空判断，避免显示null
    String username = request.getParameter("username") == null ? "" : request.getParameter("username");
    String password = request.getParameter("password") == null ? "" : request.getParameter("password");
    String date = request.getParameter("date") == null ? "" : request.getParameter("date");
    String youxiang = request.getParameter("youxiang") == null ? "" : request.getParameter("youxiang");
    String sex = request.getParameter("sex") == null ? "" : request.getParameter("sex");

    // 修复2：处理复选框（爱好），获取所有选中项并拼接
    String[] hobbies = request.getParameterValues("hobby");
    String hobbyStr = "";
    if (hobbies != null) {
        for (int i = 0; i < hobbies.length; i++) {
            hobbyStr += hobbies[i];
            if (i < hobbies.length - 1) {
                hobbyStr += "、";
            }
        }
    }

    String province = request.getParameter("province") == null ? "" : request.getParameter("province");
    String gf = request.getParameter("gf") == null ? "" : request.getParameter("gf");
    String msg = request.getParameter("msg") == null ? "" : request.getParameter("msg");
%>

<%-- 格式化输出，提升可读性 --%>
<h3>注册信息确认</h3>
<ul>
    <li>用户名：<%= username %></li>
    <li>密码：<%= password %></li>
    <li>出生日期：<%= date %></li>
    <li>邮箱：<%= youxiang %></li>
    <li>性别：<%= sex %></li>
    <li>爱好：<%= hobbyStr %></li>
    <li>省份：<%= province %></li>
    <li>前女友：<%= gf %></li>
    <li>个人简介：<%= msg %></li>
</ul>
</body>
</html>