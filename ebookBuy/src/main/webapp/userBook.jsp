<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>私人藏经阁 - Online藏书阁</title>
    <style>
        /* ========== 全局重置与变量（和主页面完全一致） ========== */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        :root {
            --bg-deepest: #0a1a20;
            --bg-dark: #0f252b;
            --bg-mid: #1a3a3f;
            --bg-light: #173036;
            --gold-dark: #a88a44;
            --gold-mid: #c9a866;
            --gold-light: #e6c888;
            --gold-gradient: linear-gradient(90deg, transparent, var(--gold-mid), var(--gold-light), var(--gold-mid), transparent);
            --text-primary: #f0e2c0;
            --text-secondary: #d4c7b0;
            --text-tertiary: #b8a990;
        }
        body {
            font-family: "SimSun", "Times New Roman", serif;
            background: radial-gradient(ellipse at 30% 20%, rgba(26, 58, 63, 0.8) 0%, transparent 50%),
            linear-gradient(135deg, var(--bg-deepest) 0%, var(--bg-mid) 50%, var(--bg-dark) 100%);
            color: var(--text-secondary);
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* ========== 左侧导航栏（和主页面完全一致，修复头像样式） ========== */
        .nav-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 280px;
            height: 100vh;
            background: linear-gradient(180deg, rgba(13, 31, 36, 0.96) 0%, rgba(23, 48, 54, 0.96) 100%);
            border-right: 3px solid var(--gold-dark);
            overflow-y: auto;
            padding: 40px 0;
            z-index: 999;
            box-shadow: 5px 0 25px rgba(0,0,0,0.85);
        }
        /* 【关键修复】头像完整样式，彻底解决变大问题 */
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
            border: 3px solid var(--gold-mid);
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
        }
        .guest-avatar {
            filter: grayscale(0.7);
            opacity: 0.7;
        }
        .user-name {
            color: var(--text-primary);
            font-size: 20px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-bottom: 5px;
        }
        .user-title {
            color: var(--gold-mid);
            font-size: 14px;
            letter-spacing: 1px;
            text-shadow: 0 0 10px rgba(201, 168, 102, 0.5);
        }
        .user-tip {
            color: var(--text-tertiary);
            font-size: 14px;
            letter-spacing: 1px;
        }

        .nav-sidebar .logo {
            text-align: center;
            color: var(--text-primary);
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 50px;
            text-shadow: 0 0 20px var(--gold-mid), 0 0 40px rgba(201, 168, 102, 0.6);
            padding: 0 15px;
            letter-spacing: 5px;
            animation: logoBreath 3s ease-in-out infinite;
        }
        @keyframes logoBreath {
            0%, 100% { text-shadow: 0 0 20px var(--gold-mid), 0 0 40px rgba(201, 168, 102, 0.6); }
            50% { text-shadow: 0 0 30px var(--gold-light), 0 0 60px rgba(230, 200, 136, 0.8); }
        }
        .nav-group-title {
            padding: 15px 25px;
            color: var(--gold-dark);
            font-size: 16px;
            font-weight: bold;
            letter-spacing: 2px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            margin-top: 20px;
        }
        .nav-sidebar .nav-item {
            display: block;
            width: 100%;
            padding: 18px 30px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 20px;
            border-left: 5px solid transparent;
            transition: all 0.4s ease;
            letter-spacing: 2px;
        }
        .nav-sidebar .nav-item:hover, .nav-sidebar .nav-item.active {
            background: rgba(138, 163, 184, 0.12);
            border-left: 5px solid var(--gold-mid);
            color: var(--text-primary);
            text-shadow: 0 0 10px var(--text-primary);
            transform: translateX(5px);
        }

        /* ========== 右侧主内容区 ========== */
        .content-wrap {
            margin-left: 280px;
            min-height: 100vh;
            padding: 50px 60px;
            width: 100%;
        }
        .page-title {
            font-size: 48px;
            text-align: center;
            color: var(--text-primary);
            margin-bottom: 30px;
            letter-spacing: 10px;
            text-shadow: 0 0 25px var(--gold-mid), 0 0 50px rgba(201, 168, 102, 0.7);
            animation: titleBreath 4s ease-in-out infinite;
            border-bottom: 2px solid rgba(201, 168, 102, 0.5);
            padding-bottom: 20px;
        }
        @keyframes titleBreath {
            0%, 100% { text-shadow: 0 0 25px var(--gold-mid), 0 0 50px rgba(201, 168, 102, 0.7); }
            50% { text-shadow: 0 0 35px var(--gold-light), 0 0 70px rgba(230, 200, 136, 0.9); }
        }
        /* 错误提示框样式（和主页面统一） */
        .msg-box {
            text-align: center;
            padding: 15px;
            background: rgba(168, 50, 50, 0.2);
            border: 1px solid #a83232;
            border-radius: 5px;
            margin-bottom: 30px;
            font-size: 18px;
            color: #ff8888;
        }
        /* 空状态 */
        .empty-box {
            text-align: center;
            padding: 100px 0;
        }
        .empty-box p {
            font-size: 22px;
            line-height: 2;
            margin-bottom: 40px;
            color: var(--text-tertiary);
        }
        .magic-btn {
            padding: 15px 40px;
            background: linear-gradient(90deg, #173036, #244a52);
            color: var(--text-primary);
            text-decoration: none;
            font-size: 20px;
            border: 2px solid var(--gold-dark);
            border-radius: 5px;
            transition: all 0.3s ease;
            letter-spacing: 3px;
            cursor: pointer;
            font-family: "SimSun", serif;
            box-shadow: 0 4px 15px rgba(0,0,0,0.5);
            position: relative;
            overflow: hidden;
        }
        .magic-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--gold-gradient);
            opacity: 0.3;
            transition: all 0.6s ease;
        }
        .magic-btn:hover {
            background: linear-gradient(90deg, var(--gold-mid), var(--gold-light));
            color: var(--bg-deepest);
            font-weight: bold;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6);
        }
        .magic-btn:hover::before {
            left: 100%;
        }
        .btn-sm {
            padding: 8px 20px;
            font-size: 16px;
        }
        /* 典籍网格（和主页面完全统一） */
        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 35px;
            margin-top: 30px;
        }
        .book-card {
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.9) 0%, rgba(13, 31, 36, 0.94) 100%);
            border: 2px solid var(--gold-dark);
            border-radius: 10px;
            padding: 30px 25px;
            transition: all 0.4s ease;
            box-shadow: inset 0 0 20px rgba(0,0,0,0.35), 0 6px 18px rgba(0,0,0,0.5);
        }
        .book-card:hover {
            transform: translateY(-6px);
            border-color: var(--gold-light);
            box-shadow: inset 0 0 20px rgba(0,0,0,0.35), 0 0 20px rgba(201, 168, 102, 0.4);
        }
        .book-card h3 {
            font-size: 26px;
            color: var(--text-primary);
            margin-bottom: 12px;
            letter-spacing: 2px;
            text-shadow: 0 0 12px rgba(201, 168, 102, 0.6);
        }
        .book-card .author {
            font-size: 18px;
            color: var(--gold-mid);
            margin-bottom: 20px;
            font-style: italic;
        }
        .book-card .info {
            font-size: 15px;
            color: var(--text-tertiary);
            line-height: 2;
            margin-bottom: 20px;
        }
        .card-btn-group {
            display: flex;
            justify-content: center;
        }

        /* 滚动条样式统一 */
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: var(--bg-deepest); }
        ::-webkit-scrollbar-thumb { background: var(--gold-dark); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--gold-mid); }
    </style>
</head>
<body>
<div class="container">
    <!-- 左侧导航栏（和主页面完全一致） -->
    <div class="nav-sidebar">
        <div class="avatar-wrap">
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <div class="avatar-box" id="loginAvatar">
                        <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatarPath}" alt="头像" class="user-avatar">
                    </div>
                    <div class="user-name">${sessionScope.loginUser.username}</div>
                    <div class="user-title">${sessionScope.loginUser.userTitle}</div>
                </c:when>
                <c:otherwise>
                    <div class="avatar-box" id="guestAvatar">
                        <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="默认头像" class="user-avatar guest-avatar">
                    </div>
                    <div class="user-tip" title="暂未登录，请登录后使用">暂未登录</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="logo">📜 Online藏书阁</div>
        <a href="${pageContext.request.contextPath}/zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
        <a href="${pageContext.request.contextPath}/tushuguan" class="nav-item">📚 全本藏书</a>
        <a href="${pageContext.request.contextPath}/orderList" class="nav-item">📜 我的道契中心</a>
        <a href="${pageContext.request.contextPath}/userBook" class="nav-item active">📖 私人藏经阁</a>
        <a href="${pageContext.request.contextPath}/usersList" class="nav-item">👥 人员注册名录</a>
        <div class="nav-group-title">典籍分类</div>
        <a href="${pageContext.request.contextPath}/tushuguan?typeId=1" class="nav-item">🎴 玄幻修真</a>
        <a href="${pageContext.request.contextPath}/tushuguan?typeId=2" class="nav-item">🔬 科幻科技</a>
        <a href="${pageContext.request.contextPath}/tushuguan?typeId=3" class="nav-item">⚔️ 历史武侠</a>
        <a href="${pageContext.request.contextPath}/tushuguan?typeId=4" class="nav-item">📜 经典文学</a>
    </div>

    <!-- 右侧主内容区 -->
    <div class="content-wrap">
        <h1 class="page-title">私人藏经阁</h1>

        <!-- 错误提示信息 -->
        <!-- 只显示当前请求的错误提示，彻底解决残留报错 -->
        <c:if test="${not empty msg}">
            <div class="msg-box">${msg}</div>
            <!-- 显示完立刻清空，避免刷新重复显示 -->
            <c:remove var="msg" scope="request"/>
            <c:remove var="msg" scope="session"/>
        </c:if>

        <!-- 空状态 -->
        <c:if test="${empty bookList}">
            <div class="empty-box">
                <p>您的私人藏经阁空空如也<br>快去全本藏书请购心仪的典籍吧</p>
                <a href="${pageContext.request.contextPath}/tushuguan" class="magic-btn">前往请购典籍</a>
            </div>
        </c:if>

        <!-- 已解锁典籍列表 -->
        <c:if test="${not empty bookList}">
            <div class="book-grid">
                <c:forEach items="${bookList}" var="book">
                    <div class="book-card">
                        <h3>《${book.bookTitle}》</h3>
                        <p class="author">作者：${book.bookAuthor}</p>
                        <div class="info">
                            <p>解锁时间：${book.buyTime}</p>
                            <p>最后阅读：${book.lastReadTime == null ? '暂未阅读' : book.lastReadTime}</p>
                            <p>最后阅读章节：第${book.lastReadChapter}章</p>
                            <p>典籍格式：${book.bookFormat}</p>
                        </div>
                        <div class="card-btn-group">
                            <a href="${pageContext.request.contextPath}/tushuguan?targetBookId=${book.id}" class="magic-btn btn-sm">开始阅读</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<!-- 符文特效（和主页面统一，不拦截导航跳转） -->
<script>
    var runeLibrary = ['临','兵','斗','者','皆','列','阵','在','前'];
    document.addEventListener('click', function(e) {
        // 不拦截导航栏跳转
        if (e.target.closest('.nav-sidebar .nav-item')) {
            return;
        }
        var wave = document.createElement('div');
        wave.className = 'sword-wave';
        wave.style.left = e.clientX + 'px';
        wave.style.top = e.clientY + 'px';
        document.body.appendChild(wave);
        setTimeout(function() { wave.classList.add('wave-animate'); }, 10);
        wave.addEventListener('animationend', function() { this.remove(); });

        var rune = runeLibrary[Math.floor(Math.random() * runeLibrary.length)];
        var runeEl = document.createElement('div');
        runeEl.className = 'rune-text';
        runeEl.innerText = rune;
        runeEl.style.left = (e.clientX - 16) + 'px';
        runeEl.style.top = (e.clientY - 20) + 'px';
        document.body.appendChild(runeEl);
        setTimeout(function() { runeEl.classList.add('rune-animate'); }, 10);
        runeEl.addEventListener('animationend', function() { this.remove(); });
    });
</script>
</body>
</html>