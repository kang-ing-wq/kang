<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>宗门修士名录 - 玄元宗</title>
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
            color: #e6d7b9;
            overflow-x: hidden;
        }
        /* 左侧修仙风导航栏 */
        .nav-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 280px;
            height: 100vh;
            background: linear-gradient(180deg, #0d1f24 0%, #173036 100%);
            border-right: 3px solid #c9a866;
            overflow-y: auto;
            padding: 40px 0;
            z-index: 999;
            box-shadow: 5px 0 20px rgba(0,0,0,0.8);
        }
        .nav-sidebar .logo {
            text-align: center;
            color: #f0e2c0;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 50px;
            text-shadow: 0 0 15px #c9a866, 0 0 30px rgba(201, 168, 102, 0.5);
            padding: 0 15px;
            letter-spacing: 5px;
        }
        .nav-sidebar .nav-item {
            display: block;
            width: 100%;
            padding: 18px 30px;
            color: #e6d7b9;
            text-decoration: none;
            font-size: 20px;
            border-left: 5px solid transparent;
            transition: all 0.4s ease;
            letter-spacing: 2px;
        }
        .nav-sidebar .nav-item:hover, .nav-sidebar .nav-item.active {
            background: rgba(201, 168, 102, 0.2);
            border-left: 5px solid #c9a866;
            color: #fff;
            text-shadow: 0 0 10px #f0e2c0;
            transform: translateX(5px);
        }
        .nav-group-title {
            padding: 15px 25px;
            color: #c9a866;
            font-size: 16px;
            font-weight: bold;
            letter-spacing: 2px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            margin-top: 20px;
        }

        /* 右侧主内容区 */
        .content-wrap {
            margin-left: 280px;
            min-height: 100vh;
            padding: 40px;
        }
        .page-title {
            font-size: 40px;
            text-align: center;
            color: #f0e2c0;
            margin-bottom: 40px;
            letter-spacing: 10px;
            text-shadow: 0 0 20px #c9a866, 0 0 40px rgba(201, 168, 102, 0.6);
            border-bottom: 2px solid rgba(201, 168, 102, 0.5);
            padding-bottom: 20px;
        }

        /* 功能筛选区 */
        .tool-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
        }
        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .search-box input, .tool-bar select {
            padding: 10px 15px;
            background: rgba(255,255,255,0.1);
            border: 2px solid #c9a866;
            border-radius: 5px;
            color: #f0e2c0;
            font-size: 16px;
            font-family: "SimSun", serif;
        }
        .search-box input:focus, .tool-bar select:focus {
            outline: none;
            box-shadow: 0 0 10px rgba(201, 168, 102, 0.5);
        }
        .magic-btn-sm {
            padding: 10px 20px;
            background: linear-gradient(90deg, #173036, #244a52);
            color: #f0e2c0;
            border: 2px solid #c9a866;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            font-family: "SimSun", serif;
            transition: all 0.3s ease;
        }
        .magic-btn-sm:hover {
            background: linear-gradient(90deg, #c9a866, #e6c888);
            color: #0d1f24;
        }
        .btn-danger {
            background: linear-gradient(90deg, #5a1a1a, #7a2a2a);
            border-color: #a83232;
        }
        .btn-danger:hover {
            background: linear-gradient(90deg, #a83232, #c84242);
            color: #fff;
        }
        .btn-warning {
            background: linear-gradient(90deg, #664a10, #886a20);
            border-color: #c9a866;
        }
        .btn-warning:hover {
            background: linear-gradient(90deg, #c9a866, #e6c888);
            color: #0d1f24;
        }

        /* 修士名录表格 */
        .magic-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 18px;
            background: rgba(23, 48, 54, 0.9);
            border: 2px solid #c9a866;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
        }
        .magic-table thead tr {
            background: linear-gradient(90deg, #0d1f24, #173036);
            color: #f0e2c0;
        }
        .magic-table th, .magic-table td {
            padding: 15px 12px;
            text-align: left;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            vertical-align: middle;
        }
        .magic-table tbody tr {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .magic-table tbody tr:hover {
            background: rgba(201, 168, 102, 0.2);
            transform: scale(1.01);
        }
        .table-btn-group {
            display: flex;
            gap: 8px;
        }

        /* 弹窗通用样式 */
        .form-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.85);
            z-index: 99999;
            justify-content: center;
            align-items: center;
        }
        .form-card {
            width: 600px;
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.95) 0%, rgba(13, 31, 36, 0.98) 100%);
            border: 3px solid #c9a866;
            border-radius: 15px;
            padding: 50px 40px;
            box-shadow: 0 0 50px rgba(201, 168, 102, 0.3);
            max-height: 90vh;
            overflow-y: auto;
        }
        .form-card h3 {
            text-align: center;
            font-size: 32px;
            color: #f0e2c0;
            margin-bottom: 40px;
            letter-spacing: 5px;
            text-shadow: 0 0 20px #c9a866;
        }
        .form-row {
            margin-bottom: 22px;
        }
        .form-row label {
            display: block;
            font-size: 18px;
            color: #e6d7b9;
            margin-bottom: 10px;
            letter-spacing: 2px;
            font-weight: bold;
        }
        .form-row input, .form-row select {
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
        .form-row input:focus, .form-row select:focus {
            outline: none;
            box-shadow: 0 0 15px rgba(201, 168, 102, 0.6);
        }
        .form-btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }

        /* 滚动条样式 */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #0d1f24;
        }
        ::-webkit-scrollbar-thumb {
            background: #c9a866;
            border-radius: 4px;
        }

        /* ================== 登录头像与用户卡片样式 ================== */
        .avatar-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 30px 0 20px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            margin-bottom: 20px;
        }
        .avatar-box {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid #c9a866;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(201, 168, 102, 0.5);
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .avatar-box:hover {
            transform: scale(1.05);
            box-shadow: 0 0 30px rgba(201, 168, 102, 0.8);
        }
        .user-avatar {
            width: 100%;
            height: 100%;
            object-fit: cover;
            background: linear-gradient(135deg, #173036, #0f252b);
        }
        .guest-avatar {
            filter: grayscale(0.7);
            opacity: 0.7;
        }
        .user-name {
            color: #f0e2c0;
            font-size: 20px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-bottom: 5px;
        }
        .user-title {
            color: #c9a866;
            font-size: 14px;
            letter-spacing: 1px;
            text-shadow: 0 0 10px rgba(201, 168, 102, 0.5);
        }
        .user-tip {
            color: #d4c7b0;
            font-size: 14px;
            letter-spacing: 1px;
        }

        /* 用户悬浮卡片 */
        .user-card {
            position: fixed;
            top: 20px;
            left: 280px;
            width: 320px;
            background: linear-gradient(180deg, #173036 0%, #0d1f24 100%);
            border: 3px solid #c9a866;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0,0,0,0.8);
            z-index: 99999;
            padding: 25px;
            opacity: 0;
            visibility: hidden;
            transform: translateX(-10px);
            transition: all 0.3s ease;
        }
        .card-show {
            opacity: 1;
            visibility: visible;
            transform: translateX(0);
        }
        .card-header {
            display: flex;
            gap: 15px;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
        }
        .card-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: 2px solid #c9a866;
            object-fit: cover;
            background: linear-gradient(135deg, #173036, #0f252b);
        }
        .card-user-info {
            flex: 1;
        }
        .card-username {
            color: #f0e2c0;
            font-size: 22px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-bottom: 5px;
        }
        .card-title {
            color: #c9a866;
            font-size: 14px;
        }
        .card-data {
            display: flex;
            justify-content: space-around;
            padding: 15px 0;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            margin-bottom: 20px;
        }
        .data-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
        }
        .data-num {
            color: #e6c888;
            font-size: 24px;
            font-weight: bold;
            text-shadow: 0 0 10px rgba(201, 168, 102, 0.6);
        }
        .data-label {
            color: #d4c7b0;
            font-size: 14px;
        }
        .card-btn-group {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .card-btn {
            flex: 1;
            padding: 10px 0;
            background: linear-gradient(90deg, #173036, #244a52);
            border: 1px solid #a88a44;
            border-radius: 5px;
            color: #f0e2c0;
            font-size: 14px;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: "SimSun", serif;
        }
        .card-btn:hover {
            background: linear-gradient(90deg, #c9a866, #e6c888);
            color: #0d1f24;
            font-weight: bold;
        }
        .card-footer {
            border-top: 1px solid rgba(201, 168, 102, 0.3);
            padding-top: 15px;
            text-align: center;
        }
        .logout-btn {
            color: #ff6666;
            text-decoration: none;
            font-size: 16px;
            letter-spacing: 2px;
            transition: all 0.3s ease;
        }
        .logout-btn:hover {
            color: #ff6666;
            text-shadow: 0 0 10px rgba(255, 102, 102, 0.6);
        }
    </style>
</head>
<body>
<!-- 左侧导航栏 -->
<div class="nav-sidebar">
    <!-- 登录头像区域 -->
    <div class="avatar-wrap">
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <!-- 登录状态 -->
                <div class="avatar-box" id="loginAvatar">
                    <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatarPath}" alt="头像" class="user-avatar" id="avatarImg">
                </div>
                <div class="user-name">${sessionScope.loginUser.username}</div>
                <div class="user-title">${sessionScope.loginUser.userTitle}</div>
            </c:when>
            <c:otherwise>
                <!-- 未登录状态 -->
                <div class="avatar-box" id="guestAvatar">
                    <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="默认头像" class="user-avatar guest-avatar">
                </div>
                <div class="user-tip" title="暂未登录，请登录后使用">暂未登录</div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- 头像区域结束 -->

    <!-- 原有logo -->
    <div class="logo">📜 Online藏书阁</div>
    <!-- 原有导航项，注意把「人员注册名录」加上active类 -->
    <a href="zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
    <a href="login.jsp" class="nav-item">🔐 登录</a>
    <a href="register.jsp" class="nav-item">📝 注册成为藏书阁成员</a>
    <a href="tushuguan" class="nav-item">📚 藏书阁</a>
    <a href="usersList" class="nav-item active">👥 人员注册名录</a>

    <div class="nav-group-title">典籍分类</div>
    <a href="tushuguan?typeId=1" class="nav-item">🎴 玄幻修真</a>
    <a href="tushuguan?typeId=2" class="nav-item">🔬 科幻科技</a>
    <a href="tushuguan?typeId=3" class="nav-item">⚔️ 历史武侠</a>
    <a href="tushuguan?typeId=4" class="nav-item">📜 经典文学</a>
</div>

<!-- 登录后悬浮卡片 -->
<div class="user-card" id="userCard">
    <c:if test="${not empty sessionScope.loginUser}">
        <div class="card-header">
            <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatarPath}" alt="头像" class="card-avatar">
            <div class="card-user-info">
                <div class="card-username">${sessionScope.loginUser.username}</div>
                <div class="card-title" id="cardTitle">${sessionScope.loginUser.userTitle}</div>
            </div>
        </div>
        <div class="card-data">
            <div class="data-item">
                <span class="data-num">${sessionScope.loginUser.readBookNum}</span>
                <span class="data-label">已阅典籍</span>
            </div>
            <div class="data-item">
                <span class="data-num">${sessionScope.loginUser.readChapterNum}</span>
                <span class="data-label">已读章节</span>
            </div>
        </div>
        <div class="card-btn-group">
            <button class="card-btn" id="editTitleBtn">✏️ 编辑头衔</button>
            <a href="${pageContext.request.contextPath}/usersList" class="card-btn">📋 人员名录</a>
        </div>
        <div class="card-footer">
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">退出登录</a>
        </div>
    </c:if>
</div>

<!-- 编辑头衔弹窗 -->
<div class="form-modal" id="titleModal">
    <div class="form-card add-card">
        <h3>编辑我的头衔</h3>
        <form id="titleForm">
            <div class="form-row">
                <label>自定义头衔（最多10个字）</label>
                <input type="text" name="newTitle" id="newTitleInput" maxlength="10" value="${sessionScope.loginUser.userTitle}" required>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn-sm">保存修改</button>
                <button type="button" class="magic-btn-sm btn-danger" onclick="closeTitleModal()">取消</button>
            </div>
        </form>
    </div>
</div>

<!-- 右侧主内容区 -->
<div class="content-wrap">
    <h1 class="page-title">人员注册名录</h1>

    <!-- 功能筛选区 (支持多条件组合) -->
    <div class="tool-bar">
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="输入道号搜索修士...">
            <button class="magic-btn-sm" onclick="applyFilters()">搜索</button>
        </div>
        <div>
            <select id="sexFilter" onchange="applyFilters()" class="magic-btn-sm">
                <option value="all">全部性别</option>
                <option value="男">男</option>
                <option value="女">女</option>
            </select>
            <select id="ageSort" onchange="sortByAge()" class="magic-btn-sm">
                <option value="default">默认排序</option>
                <option value="asc">年龄升序</option>
                <option value="desc">年龄降序</option>
            </select>
            <button class="magic-btn-sm" onclick="openAddForm()">新增人员</button>
        </div>
    </div>

    <!-- 修士名录表格（新增头像列） -->
    <table class="magic-table" id="userTable">
        <thead>
        <tr>
            <th style="width: 80px;">头像</th>
            <th>用户名</th>
            <th>密码</th>
            <th>性别</th>
            <th>年龄</th>
            <th>邮箱</th>
            <th>宗门操作</th>
        </tr>
        </thead>
        <tbody id="userTableBody">
        <c:forEach items="${userList}" var="user">
            <tr
                    data-user-id="${user.id}"
                    data-username="${user.username}"
                    data-password="${user.password}"
                    data-sex="${user.sex}"
                    data-age="${user.age}"
                    data-email="${user.email}"
                    data-avatar="${user.avatarPath}">
                <!-- 头像列 -->
                <td>
                    <c:choose>
                        <c:when test="${not empty user.avatarPath}">
                            <img src="${pageContext.request.contextPath}${user.avatarPath}"
                                 alt="${user.username}"
                                 style="width: 50px; height: 50px; object-fit: cover; border-radius: 50%; border: 2px solid #c9a866; box-shadow: 0 2px 8px rgba(0,0,0,0.3);"
                                 loading="lazy"
                                 onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'50\' height=\'50\' viewBox=\'0 0 50 50\'%3E%3Ccircle cx=\'25\' cy=\'25\' r=\'25\' fill=\'%233d5a5a\'/%3E%3Ctext x=\'10\' y=\'30\' font-family=\'SimSun\' font-size=\'12\' fill=\'%23c9a866\'%3E无头像%3C/text%3E%3C/svg%3E'">
                        </c:when>
                        <c:otherwise>
                            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='50' height='50' viewBox='0 0 50 50'%3E%3Ccircle cx='25' cy='25' r='25' fill='%233d5a5a'/%3E%3Ctext x='10' y='30' font-family='SimSun' font-size='12' fill='%23c9a866'%3E无头像%3C/text%3E%3C/svg%3E"
                                 alt="默认头像"
                                 style="width: 50px; height: 50px; object-fit: cover; border-radius: 50%; border: 2px solid #c9a866; box-shadow: 0 2px 8px rgba(0,0,0,0.3);">
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${user.username}</td>
                <td>${user.password}</td>
                <td>${user.sex}</td>
                <td>${user.age}</td>
                <td>${user.email}</td>
                <td>
                    <div class="table-btn-group">
                        <button class="magic-btn-sm btn-warning" onclick="openUpdateForm(this)">修改信息</button>
                        <button class="magic-btn-sm btn-danger" onclick="deleteUser(this)">销毁</button>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- 修改用户信息弹窗（新增头像输入框） -->
<div class="form-modal" id="updateFormModal">
    <div class="form-card">
        <h3>修改修士信息</h3>
        <form id="updateForm" action="${pageContext.request.contextPath}/userUpdate" method="post">
            <input type="hidden" name="id" id="updateUserId">
            <div class="form-row">
                <label>用户名</label>
                <input type="text" name="username" id="updateUsername" required>
            </div>
            <div class="form-row">
                <label>密码</label>
                <input type="text" name="password" id="updatePassword" required>
            </div>
            <div class="form-row">
                <label>性别</label>
                <select name="sex" id="updateSex" required>
                    <option value="男">男</option>
                    <option value="女">女</option>
                </select>
            </div>
            <div class="form-row">
                <label>年龄</label>
                <input type="number" name="age" id="updateAge" min="1" max="1000" required>
            </div>
            <div class="form-row">
                <label>邮箱</label>
                <input type="email" name="email" id="updateEmail" required>
            </div>
            <!-- 新增：头像路径输入框 -->
            <div class="form-row">
                <label>修士头像路径</label>
                <input type="text" name="avatarPath" id="updateAvatar" placeholder="/images/xxx.jpg">
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn-sm">确认修改</button>
                <button type="button" class="magic-btn-sm btn-danger" onclick="closeUpdateForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<!-- 新增修士信息弹窗 -->
<div class="form-modal" id="addFormModal">
    <div class="form-card">
        <h3>录入新成员</h3>
        <form id="addForm" action="${pageContext.request.contextPath}/userAdd" method="post">
            <div class="form-row">
                <label>用户名</label>
                <input type="text" name="username" id="addUsername" required>
            </div>
            <div class="form-row">
                <label>密码</label>
                <input type="text" name="password" id="addPassword" required>
            </div>
            <div class="form-row">
                <label>性别</label>
                <select name="sex" id="addSex" required>
                    <option value="男">男</option>
                    <option value="女">女</option>
                </select>
            </div>
            <div class="form-row">
                <label>年龄</label>
                <input type="number" name="age" id="addAge" min="1" max="1000" value="20" required>
            </div>
            <div class="form-row">
                <label>邮箱</label>
                <input type="email" name="email" id="addEmail" required>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn-sm">注册</button>
                <button type="button" class="magic-btn-sm btn-danger" onclick="closeAddForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    // ================= 全局变量与辅助函数 =================
    var updateModal = document.getElementById('updateFormModal');
    var addModal = document.getElementById('addFormModal');
    var searchInput = document.getElementById('searchInput');
    var sexFilter = document.getElementById('sexFilter');

    // 获取所有行（原始数据，不包含隐藏/过滤状态）
    function getAllRows() {
        return document.querySelectorAll('#userTableBody tr');
    }

    // ---------- 核心：组合过滤函数（性别 + 关键词，完美恢复模糊搜索）----------
    function applyFilters() {
        var keyword = searchInput.value.trim().toLowerCase();
        var selectedSex = sexFilter.value;

        var rows = getAllRows();
        for (var i = 0; i < rows.length; i++) {
            var row = rows[i];
            // 【修复】从tr的data属性获取，不依赖列索引，更稳定
            var username = row.dataset.username.toLowerCase();
            var sex = row.dataset.sex;

            // 性别匹配：all 或 等于当前选择
            var sexMatch = (selectedSex === 'all' || sex === selectedSex);
            // 关键词匹配：用户名包含关键字（模糊搜索）
            var keywordMatch = (keyword === '' || username.indexOf(keyword) > -1);

            if (sexMatch && keywordMatch) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        }
    }

    // 为了兼容之前可能的调用，保留 searchUser 和 filterBySex 函数，但内部调用 applyFilters
    function searchUser() {
        applyFilters();
    }
    function filterBySex() {
        applyFilters();
    }

    // 回车触发搜索
    searchInput.onkeyup = function(e) {
        e = e || window.event;
        if (e.keyCode === 13) {
            applyFilters();
        }
    };

    // ---------- 年龄排序 (从data属性获取，不依赖列索引) ----------
    function sortByAge() {
        var sortType = document.getElementById('ageSort').value;
        var tbody = document.getElementById('userTableBody');
        var rows = [];
        var allRows = tbody.getElementsByTagName('tr');
        for (var i = 0; i < allRows.length; i++) {
            rows.push(allRows[i]);
        }

        if (sortType === 'asc') {
            rows.sort(function(a, b) {
                // 【修复】从data-age属性获取
                var ageA = parseInt(a.dataset.age, 10);
                var ageB = parseInt(b.dataset.age, 10);
                return ageA - ageB;
            });
        } else if (sortType === 'desc') {
            rows.sort(function(a, b) {
                var ageA = parseInt(a.dataset.age, 10);
                var ageB = parseInt(b.dataset.age, 10);
                return ageB - ageA;
            });
        } else {
            // 默认排序不重新排列，直接应用过滤（保持原顺序）
            applyFilters();
            return;
        }

        // 清空并重新添加排序后的行
        while (tbody.firstChild) {
            tbody.removeChild(tbody.firstChild);
        }
        for (var j = 0; j < rows.length; j++) {
            tbody.appendChild(rows[j]);
        }
        // 重新应用过滤条件
        applyFilters();
    }

    // ---------- 删除功能 (从data属性获取) ----------
    function deleteUser(btn) {
        var tr = btn.closest('tr');
        // 【修复】从data属性获取，不依赖列索引
        var userId = tr.dataset.userId;
        var username = tr.dataset.username;

        var confirmMsg = '确定要销毁【' + username + '】的道号吗？此操作不可恢复！';
        if (confirm(confirmMsg)) {
            window.location.href = '${pageContext.request.contextPath}/userDelete?id=' + userId;
        }
    }

    // ---------- 修改功能 (完美修复，从data属性回显，点击有反应) ----------
    function openUpdateForm(btn) {
        var tr = btn.closest('tr');

        // 【修复】全部从tr的data-*属性获取，不依赖列索引，100%准确
        document.getElementById('updateUserId').value = tr.dataset.userId;
        document.getElementById('updateUsername').value = tr.dataset.username;
        document.getElementById('updatePassword').value = tr.dataset.password;
        document.getElementById('updateSex').value = tr.dataset.sex;
        document.getElementById('updateAge').value = tr.dataset.age;
        document.getElementById('updateEmail').value = tr.dataset.email;
        document.getElementById('updateAvatar').value = tr.dataset.avatar;

        updateModal.style.display = 'flex';
    }

    function closeUpdateForm() {
        updateModal.style.display = 'none';
    }

    updateModal.onclick = function(e) {
        if (e.target === updateModal) closeUpdateForm();
    };

    // ---------- 新增功能 ----------
    function openAddForm() {
        document.getElementById('addForm').reset();
        addModal.style.display = 'flex';
    }

    function closeAddForm() {
        addModal.style.display = 'none';
    }

    addModal.onclick = function(e) {
        if (e.target === addModal) closeAddForm();
    };

    // 页面加载完成
    window.onload = function() {
        // 确保初始状态所有行显示
        applyFilters();
    };

    // ESC关闭弹窗
    document.onkeydown = function(e) {
        e = e || window.event;
        if (e.keyCode === 27) {
            closeUpdateForm();
            closeAddForm();
            closeTitleModal();
        }
    };

    // ================== 头像与用户卡片交互（保留原有逻辑） ==================
    var loginAvatar = document.getElementById('loginAvatar');
    var userCard = document.getElementById('userCard');
    var guestAvatar = document.getElementById('guestAvatar');
    var titleModal = document.getElementById('titleModal');
    var titleForm = document.getElementById('titleForm');

    if (loginAvatar) {
        loginAvatar.addEventListener('mouseenter', function() {
            userCard.classList.add('card-show');
        });
        userCard.addEventListener('mouseleave', function() {
            userCard.classList.remove('card-show');
        });
    }

    if (guestAvatar) {
        guestAvatar.addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/login.jsp';
        });
    }

    if (document.getElementById('editTitleBtn')) {
        document.getElementById('editTitleBtn').addEventListener('click', function() {
            userCard.classList.remove('card-show');
            titleModal.style.display = 'flex';
        });
    }

    function closeTitleModal() {
        if (titleModal) titleModal.style.display = 'none';
    }

    if (titleModal) {
        titleModal.onclick = function(e) {
            if (e.target === this) closeTitleModal();
        };
    }

    if (titleForm) {
        titleForm.onsubmit = function(e) {
            e.preventDefault();
            var newTitle = document.getElementById('newTitleInput').value.trim();

            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/updateTitle', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText);
                    if (res.code === 200) {
                        alert(res.msg);
                        closeTitleModal();
                        window.location.reload();
                    } else {
                        alert(res.msg);
                    }
                }
            };
            xhr.send('newTitle=' + encodeURIComponent(newTitle));
        };
    }
</script>
</body>
</html>