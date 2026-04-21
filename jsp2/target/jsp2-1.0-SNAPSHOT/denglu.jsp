<%--
  Created by IntelliJ IDEA.
  User: 曾
  Date: 2026/3/10
  Time: 9:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    request.setAttribute("username",username);
    if (username.equals("孙悟空") && password.equals("123")){
//        out.print("登录成功");
//        response.sendRedirect();
        session.setAttribute("username",username);
        request.getRequestDispatcher("success.jsp").forward(request,response);
    } else{
        if (username == null || username == "" || password == null || password == ""){
            request.getRequestDispatcher("index.jsp?msg=用户名或密码不能为空").forward(request,response);
        }else{
            request.getRequestDispatcher("index.jsp?msg=用户名或密码错误").forward(request,response);
        }

    }

    String city = request.getParameter("city");
    request.setAttribute("city",city);

    String ur1="";
    if ("京东".equals(city)){
        ur1 = "https://www.jd.com";
    }else if ("淘宝".equals(city)){
        ur1 = "https://taobao.com";
    } else if ("拼多多".equals(city)) {
        ur1 = "https://pinduoduo.com";
    }else {
        ur1 = "inndex.jsp";
    }

    response.sendRedirect(ur1);
%>

</body>
</html>
