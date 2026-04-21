<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>玄元宗 - 宗门首页</title>
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
            padding: 60px;
        }
        .welcome-bar {
            text-align: right;
            font-size: 20px;
            color: #c9a866;
            margin-bottom: 30px;
            letter-spacing: 2px;
        }
        .welcome-bar a {
            color: #e6c888;
            text-decoration: none;
            margin-left: 20px;
        }
        .welcome-bar a:hover {
            text-shadow: 0 0 10px #c9a866;
        }
        .main-title {
            font-size: 64px;
            text-align: center;
            color: #f0e2c0;
            margin-bottom: 30px;
            letter-spacing: 15px;
            text-shadow: 0 0 30px #c9a866, 0 0 60px rgba(201, 168, 102, 0.6);
        }
        .sub-title {
            font-size: 24px;
            text-align: center;
            color: #d4c7b0;
            margin-bottom: 60px;
            letter-spacing: 5px;
        }

        /* ========== 流动鎏金边框核心样式 ========== */
        /* 宗门介绍卡片 */
        .intro-card {
            position: relative;
            z-index: 1;
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.95) 0%, rgba(13, 31, 36, 0.98) 100%);
            border-radius: 15px;
            padding: 50px;
            margin-bottom: 50px;
            box-shadow: 0 0 20px rgba(201, 168, 102, 0.3),
            0 10px 40px rgba(0,0,0,0.8),
            inset 0 0 30px rgba(201, 168, 102, 0.1);
            transition: all 0.4s ease;
            /* 关键：边框透明，背景只填充内容区 */
            border: 3px solid transparent;
            background-clip: padding-box;
        }

        /* 流动边框伪元素 */
        .intro-card::after {
            content: "";
            position: absolute;
            top: -3px;
            left: -3px;
            right: -3px;
            bottom: -3px;
            z-index: -1;
            border-radius: 15px;
            /* 使用大尺寸渐变，通过移动背景位置产生流动效果 */
            background: linear-gradient(
                    135deg,
                    #a88a44 0%,
                    #e6c888 20%,
                    #c9a866 40%,
                    #f5e6b0 60%,
                    #a88a44 80%,
                    #e6c888 100%
            );
            background-size: 300% 300%;
            animation: goldBorderFlow 4s linear infinite;
            /* 挖空中间，只显示边框区域 */
            -webkit-mask:
                    linear-gradient(#fff 0 0) content-box,
                    linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask:
                    linear-gradient(#fff 0 0) content-box,
                    linear-gradient(#fff 0 0);
            mask-composite: exclude;
            pointer-events: none;
        }

        .intro-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 30px rgba(201, 168, 102, 0.5),
            0 15px 50px rgba(0,0,0,0.9),
            inset 0 0 40px rgba(201, 168, 102, 0.2);
        }

        /* 功能入口网格 */
        .btn-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        /* 功能入口按钮（流动鎏金边框） */
        .btn-grid .magic-btn {
            position: relative;
            z-index: 1;
            display: block;
            padding: 30px 20px;
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.95) 0%, rgba(13, 31, 36, 0.98) 100%);
            color: #f0e2c0;
            text-decoration: none;
            font-size: 24px;
            text-align: center;
            border-radius: 15px;
            letter-spacing: 3px;
            box-shadow: 0 0 15px rgba(201, 168, 102, 0.2),
            0 6px 25px rgba(0,0,0,0.7),
            inset 0 0 20px rgba(201, 168, 102, 0.05);
            transition: all 0.4s ease;
            border: 3px solid transparent;
            background-clip: padding-box;
        }

        .btn-grid .magic-btn::after {
            content: "";
            position: absolute;
            top: -3px;
            left: -3px;
            right: -3px;
            bottom: -3px;
            z-index: -1;
            border-radius: 15px;
            background: linear-gradient(
                    135deg,
                    #a88a44 0%,
                    #e6c888 20%,
                    #c9a866 40%,
                    #f5e6b0 60%,
                    #a88a44 80%,
                    #e6c888 100%
            );
            background-size: 300% 300%;
            animation: goldBorderFlow 4s linear infinite;
            -webkit-mask:
                    linear-gradient(#fff 0 0) content-box,
                    linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask:
                    linear-gradient(#fff 0 0) content-box,
                    linear-gradient(#fff 0 0);
            mask-composite: exclude;
            pointer-events: none;
        }

        .btn-grid .magic-btn:hover {
            background: linear-gradient(90deg, rgba(201, 168, 102, 0.2), rgba(230, 200, 136, 0.3));
            color: #e6c888;
            font-weight: bold;
            transform: translateY(-10px);
            box-shadow: 0 0 30px rgba(201, 168, 102, 0.6),
            0 12px 40px rgba(0,0,0,0.9),
            inset 0 0 30px rgba(201, 168, 102, 0.15);
            text-shadow: 0 0 15px #c9a866;
        }

        /* 流动动画关键帧 */
        @keyframes goldBorderFlow {
            0% { background-position: 0% 0%; }
            100% { background-position: 100% 100%; }
        }

        /* ========== 弹窗内按钮样式（不添加流动边框，保持简洁） ========== */
        .form-modal .magic-btn,
        .form-card .magic-btn {
            padding: 12px 30px;
            background: linear-gradient(90deg, #173036, #244a52);
            color: #f0e2c0;
            border: 2px solid #c9a866;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            font-family: "SimSun", serif;
            transition: all 0.3s ease;
            /* 重置可能被继承的属性 */
            position: static;
            display: inline-block;
            background-clip: border-box;
            box-shadow: none;
            transform: none;
        }
        .form-modal .magic-btn:hover,
        .form-card .magic-btn:hover {
            background: linear-gradient(90deg, #c9a866, #e6c888);
            color: #0d1f24;
            transform: none;
            box-shadow: none;
            text-shadow: none;
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
        .form-row input {
            width: 100%;
            padding: 12px 18px;
            background: rgba(255,255,255,0.1);
            border: 2px solid #c9a866;
            border-radius: 8px;
            color: #f0e2c0;
            font-size: 16px;
            font-family: "SimSun", serif;
        }
        .form-row input:focus {
            outline: none;
            box-shadow: 0 0 15px rgba(201, 168, 102, 0.6);
        }
        .form-btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<!-- 左侧导航栏 -->
<!-- 左侧导航栏 -->
<div class="nav-sidebar">
    <!-- ================== 登录头像区域 ================== -->
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
    <!-- ================== 头像区域结束 ================== -->

    <!-- 原有logo -->
    <div class="logo">📜 Online藏书阁</div>
    <!-- 原有导航项，注意把「图书管理首页」加上active类 -->
    <a href="zongmen.jsp" class="nav-item active">🏠 图书管理首页</a>
    <a href="login.jsp" class="nav-item">🔐 登录</a>
    <a href="register.jsp" class="nav-item">📝 注册成为藏书阁成员</a>
    <a href="tushuguan" class="nav-item">📚 全本藏书</a>
    <a href="javascript:openAddForm()" class="nav-item">✍️ 新增典籍</a>
    <a href="${pageContext.request.contextPath}/chapterAdd" class="nav-item">📖 录入章节</a>
    <a href="usersList" class="nav-item">👥 人员注册名录</a>
    <div class="nav-group-title">典籍分类</div>
    <a href="tushuguan?typeId=1" class="nav-item">🎴 玄幻修真</a>
    <a href="tushuguan?typeId=2" class="nav-item">🔬 科幻科技</a>
    <a href="tushuguan?typeId=3" class="nav-item">⚔️ 历史武侠</a>
    <a href="tushuguan?typeId=4" class="nav-item">📜 经典文学</a>
</div>

<!-- ================== 登录后悬浮卡片 ================== -->
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

<!-- ================== 编辑头衔弹窗 ================== -->
<div class="form-modal" id="titleModal">
    <div class="form-card add-card">
        <h3>编辑我的头衔</h3>
        <form id="titleForm">
            <div class="form-row">
                <label>自定义头衔（最多10个字）</label>
                <input type="text" name="newTitle" id="newTitleInput" maxlength="10" value="${sessionScope.loginUser.userTitle}" required>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn">保存修改</button>
                <button type="button" class="magic-btn" onclick="closeTitleModal()">取消</button>
            </div>
        </form>
    </div>
</div>

<!-- 右侧主内容区 -->
<div class="content-wrap">
    <!-- 登录状态欢迎栏 -->
    <div class="welcome-bar">
        <c:choose>
            <c:when test="${not empty loginUser}">
                欢迎回宗，${loginUser.username} 道友
                <a href="javascript:logout()">退出宗门</a>
            </c:when>
            <c:otherwise>
                道友，您还未登录，请先登录/加入宗门
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 宗门大标题 -->
    <h1 class="main-title">Online藏书阁</h1>
    <p class="sub-title">大道无涯，与君同修</p>

    <!-- 宗门介绍 -->
    <div class="intro-card">
        <h3>宗门介绍</h3>
        <p>玄元宗立于修仙界万载，藏天下典籍，聚四方修士。宗门藏书阁收录修真、科幻、历史、文学四大类典籍无数，助道友悟道修行，提升境界。</p>
        <p>凡入我宗门者，皆可自由阅览藏书阁典籍，与宗门万千道友一同修行，共探大道本源。</p>
    </div>

    <!-- 功能入口 -->
    <div class="btn-grid">
        <a href="tushuguan" class="magic-btn">进入藏书阁</a>
        <a href="usersList" class="magic-btn">查看修士名录</a>
        <a href="register.jsp" class="magic-btn">加入宗门</a>
        <a href="login.jsp" class="magic-btn">登录宗门</a>
    </div>
</div>

<script>
    // ================== 头像与用户卡片交互 ==================
    var loginAvatar = document.getElementById('loginAvatar');
    var userCard = document.getElementById('userCard');
    var guestAvatar = document.getElementById('guestAvatar');
    var titleModal = document.getElementById('titleModal');
    var titleForm = document.getElementById('titleForm');

    // 登录状态：hover显示卡片
    if (loginAvatar) {
        loginAvatar.addEventListener('mouseenter', function() {
            userCard.classList.add('card-show');
        });
        userCard.addEventListener('mouseleave', function() {
            userCard.classList.remove('card-show');
        });
    }

    // 未登录状态：点击跳转到登录页
    if (guestAvatar) {
        guestAvatar.addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/login.jsp';
        });
    }

    // 编辑头衔按钮点击
    if (document.getElementById('editTitleBtn')) {
        document.getElementById('editTitleBtn').addEventListener('click', function() {
            userCard.classList.remove('card-show');
            titleModal.style.display = 'flex';
        });
    }

    // 关闭头衔编辑弹窗
    function closeTitleModal() {
        if (titleModal) titleModal.style.display = 'none';
    }

    // 点击弹窗外部关闭
    if (titleModal) {
        titleModal.onclick = function(e) {
            if (e.target === this) closeTitleModal();
        };
    }

    // 头衔编辑表单提交
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

    // ESC键关闭弹窗
    var originalOnkeydown = document.onkeydown;
    document.onkeydown = function(e) {
        e = e || window.event;
        if (e.keyCode === 27) {
            closeTitleModal();
            // 兼容原有页面的弹窗关闭逻辑
            if (typeof closeAddForm === 'function') closeAddForm();
        }
        if (originalOnkeydown) originalOnkeydown(e);
    };

    // 退出登录
    function logout() {
        if(confirm("确定要退出宗门吗？")) {
            window.location.href = "${pageContext.request.contextPath}/logout";
        }
    }
</script>
</body>
</html>