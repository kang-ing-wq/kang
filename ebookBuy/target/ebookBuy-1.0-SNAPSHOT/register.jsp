<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>加入宗门 - 玄元宗</title>
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
      padding: 50px 0;
    }
    .register-card {
      width: 600px;
      margin: 0 auto;
      background: linear-gradient(180deg, rgba(23, 48, 54, 0.95) 0%, rgba(13, 31, 36, 0.98) 100%);
      border: 3px solid #c9a866;
      border-radius: 15px;
      padding: 50px 40px;
      box-shadow: 0 0 50px rgba(201, 168, 102, 0.3);
    }
    .register-card h2 {
      text-align: center;
      font-size: 40px;
      color: #f0e2c0;
      margin-bottom: 40px;
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
      margin-bottom: 25px;
    }
    .form-item label {
      display: block;
      font-size: 18px;
      color: #e6d7b9;
      margin-bottom: 10px;
      letter-spacing: 2px;
      font-weight: bold;
    }
    .form-item input, .form-item select {
      width: 100%;
      padding: 12px 18px;
      background: rgba(255,255,255,0.1);
      border: 2px solid #c9a866;
      border-radius: 8px;
      color: #f0e2c0;
      font-size: 16px;
      font-family: "SimSun", serif;
      transition: all 0.3s ease;
    }
    .form-item input:focus, .form-item select:focus {
      outline: none;
      box-shadow: 0 0 15px rgba(201, 168, 102, 0.6);
    }
    .register-btn {
      width: 100%;
      padding: 16px;
      background: linear-gradient(90deg, #c9a866, #e6c888);
      color: #0d1f24;
      border: 2px solid #c9a866;
      border-radius: 8px;
      font-size: 20px;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.3s ease;
      font-family: "SimSun", serif;
      letter-spacing: 5px;
      margin-bottom: 20px;
    }
    .register-btn:hover {
      transform: translateY(-3px);
      box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6);
    }
    .link-group {
      text-align: center;
    }
    .link-group a {
      color: #c9a866;
      text-decoration: none;
      font-size: 16px;
    }
    .link-group a:hover {
      color: #fff;
      text-shadow: 0 0 10px #c9a866;
    }
    .back-home {
      display: block;
      text-align: center;
      margin-top: 20px;
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
<div class="register-card">
  <h2>注册成为藏书阁成员</h2>
  <c:if test="${not empty msg}">
    <p class="error-msg">${msg}</p>
  </c:if>
  <form action="register" method="post">
    <div class="form-item">
      <label>用户名</label>
      <input type="text" name="username" required placeholder="请输入您的道号">
    </div>
    <div class="form-item">
      <label>密码</label>
      <input type="password" name="password" required placeholder="请设置您的登录口令">
    </div>
    <div class="form-item">
      <label>性别</label>
      <select name="sex" required>
        <option value="男">男</option>
        <option value="女">女</option>
      </select>
    </div>
    <div class="form-item">
      <label>年龄</label>
      <input type="number" name="age" required min="1" max="1000" placeholder="请输入您的年龄">
    </div>
    <div class="form-item">
      <label>邮箱</label>
      <input type="email" name="email" required placeholder="请输入您的邮箱">
    </div>
    <button type="submit" class="register-btn">注册</button>
  </form>
  <div class="link-group">
    <a href="login.jsp">已经注册成为了图书借贷人？点击登录</a>
  </div>
  <!-- 所有页面的导航栏，首页链接统一改成zongmen.jsp -->
  <a href="zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
</div>
</body>
</html>