<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>藏书阁人员登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: "SimSun", "Times New Roman", serif;
            background: linear-gradient(135deg, #0a1a20 0%, #1a3a3f 50%, #0f252b 100%);
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .login-card {
            width: 500px;
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.95) 0%, rgba(13, 31, 36, 0.98) 100%);
            border: 3px solid #c9a866;
            border-radius: 15px;
            padding: 60px 40px;
            box-shadow: 0 0 50px rgba(201, 168, 102, 0.3);
        }
        .login-card h2 {
            text-align: center;
            font-size: 40px;
            color: #f0e2c0;
            margin-bottom: 50px;
            letter-spacing: 8px;
            text-shadow: 0 0 20px #c9a866;
        }
        .error-msg {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 25px;
            font-size: 18px;
            font-weight: bold;
        }
        .form-item {
            margin-bottom: 30px;
        }
        .form-item label {
            display: block;
            font-size: 20px;
            color: #e6d7b9;
            margin-bottom: 12px;
            letter-spacing: 2px;
            font-weight: bold;
        }
        .form-item input {
            width: 100%;
            padding: 15px 20px;
            background: rgba(255,255,255,0.1);
            border: 2px solid #c9a866;
            border-radius: 8px;
            color: #f0e2c0;
            font-size: 18px;
            font-family: "SimSun", serif;
            transition: all 0.3s ease;
        }
        .form-item input:focus {
            outline: none;
            box-shadow: 0 0 15px rgba(201, 168, 102, 0.6);
        }
        .login-btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(90deg, #c9a866, #e6c888);
            color: #0d1f24;
            border: 2px solid #c9a866;
            border-radius: 8px;
            font-size: 22px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: "SimSun", serif;
            letter-spacing: 5px;
            margin-bottom: 20px;
        }
        .login-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6);
        }
        .link-group {
            text-align: center;
        }
        .link-group a {
            color: #c9a866;
            text-decoration: none;
            font-size: 18px;
            transition: all 0.3s ease;
        }
        .link-group a:hover {
            color: #fff;
            text-shadow: 0 0 10px #c9a866;
        }
        .back-home {
            display: block;
            text-align: center;
            margin-top: 30px;
            color: #d4c7b0;
            text-decoration: none;
            font-size: 16px;
        }
        .back-home:hover {
            color: #c9a866;
        }
    </style>
</head>
<body>
<div class="login-card">
    <h2>登录</h2>
    <c:if test="${not empty msg}">
        <p class="error-msg">${msg}</p>
    </c:if>
    <form action="login" method="post">
        <div class="form-item">
            <label>姓名</label>
            <input type="text" name="username" required placeholder="请输入您的姓名">
        </div>
        <div class="form-item">
            <label>密码</label>
            <input type="password" name="password" required placeholder="请输入您的密码">
        </div>
        <button type="submit" class="login-btn">登入</button>
    </form>
    <div class="link-group">
        <a href="register.jsp">还未登录？点击立即注册！</a>
    </div>
    <a href="zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
</div>
</body>
</html>