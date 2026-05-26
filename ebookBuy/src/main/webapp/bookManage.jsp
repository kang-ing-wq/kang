<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>典籍总录 - Online藏书阁</title>
    <style>
        /* ========== 原有所有样式完全保留 ========== */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --bg-deepest: #0a1a20; --bg-dark: #0f252b; --bg-mid: #1a3a3f; --bg-light: #173036;
            --gold-dark: #a88a44; --gold-mid: #c9a866; --gold-light: #e6c888;
            --gold-gradient: linear-gradient(90deg, transparent, var(--gold-mid), var(--gold-light), var(--gold-mid), transparent);
            --red: #a86666; --green: #7aa88a;
            --text-primary: #f0e2c0; --text-secondary: #d4c7b0; --text-tertiary: #b8a990;
        }
        body {
            font-family: "SimSun", "Times New Roman", serif;
            background: radial-gradient(ellipse at 30% 20%, rgba(26, 58, 63, 0.8) 0%, transparent 50%),
            linear-gradient(135deg, var(--bg-deepest) 0%, var(--bg-mid) 50%, var(--bg-dark) 100%);
            color: var(--text-secondary); overflow-x: hidden;
        }

        /* 左侧导航 */
        .nav-sidebar {
            position: fixed; top: 0; left: 0; width: 280px; height: 100vh;
            background: linear-gradient(180deg, rgba(13, 31, 36, 0.96) 0%, rgba(23, 48, 54, 0.96) 100%);
            border-right: 3px solid var(--gold-dark); overflow-y: auto; padding: 40px 0; z-index: 999;
            box-shadow: 5px 0 25px rgba(0,0,0,0.85);
        }
        .nav-sidebar .logo { text-align: center; color: var(--text-primary); font-size: 28px; font-weight: bold; margin-bottom: 50px; text-shadow: 0 0 20px var(--gold-mid), 0 0 40px rgba(201, 168, 102, 0.6); padding: 0 15px; letter-spacing: 5px; animation: logoBreath 3s ease-in-out infinite; }
        @keyframes logoBreath { 0%, 100% { text-shadow: 0 0 20px var(--gold-mid), 0 0 40px rgba(201, 168, 102, 0.6); } 50% { text-shadow: 0 0 30px var(--gold-light), 0 0 60px rgba(230, 200, 136, 0.8); } }
        .nav-sidebar .nav-item { display: block; width: 100%; padding: 18px 30px; color: var(--text-secondary); text-decoration: none; font-size: 20px; border-left: 5px solid transparent; transition: all 0.4s ease; letter-spacing: 2px; }
        .nav-sidebar .nav-item:hover, .nav-sidebar .nav-item.active { background: rgba(138, 163, 184, 0.12); border-left: 5px solid var(--gold-mid); color: var(--text-primary); text-shadow: 0 0 10px var(--text-primary); transform: translateX(5px); }
        .avatar-wrap { display: flex; flex-direction: column; align-items: center; padding: 30px 0 20px; border-bottom: 1px solid rgba(201, 168, 102, 0.3); margin-bottom: 20px; }
        /* ✅ 最终版：双层独立渲染，彻底解决遮挡 */
        .avatar-box {
            position: relative; /* 作为绝对定位容器 */
            width: 92px; /* 精确匹配头像框比例，完整容纳所有翅膀 */
            height: 92px;
            border: none;
            overflow: visible; /* 绝对不裁剪任何内容 */
            /* 移除背景图，改用独立元素渲染 */
            background: none;
            box-shadow: 0 0 20px rgba(255, 105, 180, 0.4); /* 适配粉色头像框的发光效果 */
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        /* ✅ 头像框层（底层，完整显示所有花纹） */
        .avatar-frame {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: contain; /* 按原比例完整显示，绝不拉伸 */
            z-index: 1; /* 底层：头像框在下面 */
            pointer-events: none; /* 不阻挡头像的点击事件 */
        }
        /* ✅ 用户头像层（顶层，精确嵌入中间圆形） */
        .user-avatar {
            position: absolute;
            /* 像素级对齐：92-60=32，上下左右各16px，刚好居中 */
            top: 16px;
            left: 16px;
            width: 60px; /* 精确缩小，完全露出头像框内圈粉色花纹 */
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            z-index: 2; /* 顶层：头像在上面 */
        }
        /* ✅ hover效果：整体同步放大，发光更明显 */
        .avatar-box:hover {
            transform: scale(1.1);
            box-shadow: 0 0 35px rgba(255, 105, 180, 0.7); /* 适配粉色头像框的hover发光 */
        }
        .user-name { color: var(--text-primary); font-size: 20px; font-weight: bold; letter-spacing: 2px; margin-bottom: 5px; }
        .user-title { color: var(--gold-mid); font-size: 14px; letter-spacing: 1px; text-shadow: 0 0 10px rgba(201, 168, 102, 0.5); }

        /* 右侧主内容 */
        .content-wrap { margin-left: 280px; min-height: 100vh; padding: 50px 60px; }
        .page-title { font-size: 48px; text-align: center; color: var(--text-primary); margin-bottom: 30px; letter-spacing: 10px; text-shadow: 0 0 25px var(--gold-mid), 0 0 50px rgba(201, 168, 102, 0.7); animation: titleBreath 4s ease-in-out infinite; border-bottom: 2px solid rgba(201, 168, 102, 0.5); padding-bottom: 20px; }
        @keyframes titleBreath { 0%, 100% { text-shadow: 0 0 25px var(--gold-mid), 0 0 50px rgba(201, 168, 102, 0.7); } 50% { text-shadow: 0 0 35px var(--gold-light), 0 0 70px rgba(230, 200, 136, 0.9); } }

        /* 搜索栏 */
        .search-bar { display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap; align-items: center; justify-content: space-between; }
        .search-group { display: flex; gap: 15px; align-items: center; flex-wrap: wrap; }
        .search-input { padding: 10px 15px; background: rgba(255,255,255,0.1); border: 1px solid var(--gold-dark); border-radius: 5px; color: var(--text-primary); font-size: 16px; font-family: "SimSun", serif; width: 220px; }
        .search-input:focus { outline: none; border-color: var(--gold-mid); box-shadow: 0 0 12px rgba(201, 168, 102, 0.5); }

        /* 统一单选下拉样式（类型和主题共用） */
        .single-select-wrapper { position: relative; display: inline-block; }
        .single-select-trigger { padding: 10px 40px 10px 15px; background: rgba(255,255,255,0.1); border: 1px solid var(--gold-dark); border-radius: 5px; color: var(--text-primary); font-size: 16px; font-family: "SimSun", serif; cursor: pointer; min-width: 180px; text-align: left; position: relative; user-select: none; }
        .single-select-trigger::after { content: '▼'; position: absolute; right: 15px; top: 50%; transform: translateY(-50%); font-size: 12px; color: var(--gold-mid); transition: transform 0.3s ease; }
        .single-select-wrapper.open .single-select-trigger::after { transform: translateY(-50%) rotate(180deg); }
        .single-select-dropdown { display: none; position: absolute; top: 100%; left: 0; margin-top: 5px; background: var(--bg-dark); border: 1px solid var(--gold-dark); border-radius: 5px; box-shadow: 0 10px 30px rgba(0,0,0,0.7); z-index: 1000; max-height: 300px; overflow-y: auto; min-width: 220px; }
        .single-select-wrapper.open .single-select-dropdown { display: block; }
        .single-select-option { padding: 10px 15px; cursor: pointer; transition: background 0.2s ease; color: var(--text-secondary); }
        .single-select-option:hover, .single-select-option.selected { background: rgba(201, 168, 102, 0.1); color: var(--gold-light); font-weight: bold; }

        .magic-btn { padding: 10px 25px; background: linear-gradient(90deg, #173036, #244a52); color: var(--text-primary); text-decoration: none; font-size: 16px; border: 2px solid var(--gold-dark); border-radius: 5px; transition: all 0.3s ease; letter-spacing: 2px; cursor: pointer; font-family: "SimSun", serif; box-shadow: 0 4px 15px rgba(0,0,0,0.5); position: relative; overflow: hidden; }
        .magic-btn::before { content: ""; position: absolute; top: 0; left: -100%; width: 100%; height: 100%; background: var(--gold-gradient); opacity: 0.3; transition: all 0.6s ease; }
        .magic-btn:hover { background: linear-gradient(90deg, var(--gold-mid), var(--gold-light)); color: var(--bg-deepest); font-weight: bold; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6); }
        .magic-btn:hover::before { left: 100%; }
        .btn-sm { padding: 6px 12px; font-size: 14px; }
        .btn-danger { background: linear-gradient(90deg, #5a1a1a, #7a2a2a); border-color: #a83232; }
        .btn-danger:hover { background: linear-gradient(90deg, #a83232, #c84242); color: #fff; }
        .btn-success { background: linear-gradient(90deg, #1a5a2a, #2a7a3a); border-color: var(--green); }
        .btn-success:hover { background: linear-gradient(90deg, var(--green), #8ab89a); color: var(--bg-deepest); }

        /* ✅ 优化：文件上传组合样式（支持多文件） */
        .file-input-group {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        .file-input-group input[type="text"] {
            flex: 1;
            min-width: 200px;
        }
        .file-input-group input[type="file"] {
            display: none; /* 隐藏原生文件输入框 */
        }
        .uploading {
            opacity: 0.6;
            pointer-events: none;
        }
        .file-count {
            font-size: 12px;
            color: var(--gold-mid);
            margin-left: 5px;
        }

        /* 表格 */
        .book-table-wrap { width: 100%; overflow-x: auto; border-radius: 8px; border: 2px solid var(--gold-dark); box-shadow: 0 0 30px rgba(0,0,0,0.6); }
        .book-table { width: 100%; border-collapse: collapse; background: rgba(15, 37, 43, 0.9); }
        .book-table thead { background: linear-gradient(90deg, var(--bg-mid), var(--bg-light), var(--bg-mid)); border-bottom: 2px solid var(--gold-dark); }
        .book-table th { padding: 15px 12px; text-align: left; color: var(--gold-light); font-size: 18px; letter-spacing: 2px; font-weight: bold; white-space: nowrap; }
        .book-table tbody tr { border-bottom: 1px solid rgba(201, 168, 102, 0.2); transition: all 0.3s ease; }
        .book-table tbody tr:hover { background: rgba(201, 168, 102, 0.1); }
        .book-table td { padding: 12px; color: var(--text-secondary); font-size: 16px; line-height: 1.5; vertical-align: middle; }
        .book-cover-img { width: 60px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid var(--gold-dark); box-shadow: 0 2px 8px rgba(0,0,0,0.3); transition: transform 0.2s ease; }
        .book-cover-img:hover { transform: scale(1.05); border-color: var(--gold-mid); }
        .book-table .action-group { display: flex; gap: 6px; flex-wrap: wrap; }
        .table-empty { text-align: center; padding: 60px 0; color: var(--text-tertiary); font-size: 18px; letter-spacing: 2px; }

        /* 弹窗 */
        .form-modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); z-index: 9999; justify-content: center; align-items: center; }
        .form-card { background: linear-gradient(180deg, var(--bg-light) 0%, var(--bg-deepest) 100%); border: 3px solid var(--gold-mid); border-radius: 10px; padding: 40px; box-shadow: 0 0 50px rgba(201, 168, 102, 0.35); max-height: 90vh; overflow-y: auto; width: 720px; }
        .form-card h3 { text-align: center; font-size: 32px; color: var(--text-primary); margin-bottom: 30px; letter-spacing: 5px; text-shadow: 0 0 20px var(--gold-mid); }
        .form-row { margin-bottom: 20px; }
        .form-row label { display: block; font-size: 18px; color: var(--text-secondary); margin-bottom: 8px; letter-spacing: 1px; }
        .form-row input, .form-row select, .form-row textarea { width: 100%; padding: 12px 15px; background: rgba(255,255,255,0.1); border: 1px solid var(--gold-dark); border-radius: 5px; color: var(--text-primary); font-size: 16px; font-family: "SimSun", serif; }
        .form-row input:focus, .form-row textarea:focus { outline: none; border-color: var(--gold-mid); box-shadow: 0 0 12px rgba(201, 168, 102, 0.5); }
        .form-row textarea { resize: vertical; min-height: 80px; }
        .form-btn-group { display: flex; gap: 20px; justify-content: center; margin-top: 30px; }

        /* 符文特效 */
        .sword-wave { position: fixed; width: 60px; height: 60px; border: 3px solid #c9a866; border-radius: 50%; pointer-events: none; z-index: 99998; box-shadow: 0 0 15px #c9a866, 0 0 30px rgba(201, 168, 102, 0.6); }
        @keyframes waveExpand { 0% { opacity: 1; transform: translate(-50%, -50%) scale(0.5); } 100% { opacity: 0; transform: translate(-50%, -50%) scale(2.0); } }
        .wave-animate { animation: waveExpand 0.8s ease-out forwards; }
        .rune-text { position: fixed; font-family: "SimSun", "KaiTi", serif; font-size: 32px; font-weight: bold; color: #c9a866; text-shadow: 0 0 10px #c9a866, 0 0 20px rgba(201, 168, 102, 0.8); pointer-events: none; z-index: 99999; user-select: none; white-space: nowrap; }
        @keyframes runeFloat { 0% { opacity: 1; transform: translateY(0) scale(1); } 100% { opacity: 0; transform: translateY(-120px) scale(1.2); } }
        .rune-animate { animation: runeFloat 0.9s ease-out forwards; }

        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-track { background: var(--bg-deepest); border-radius: 4px; }
        ::-webkit-scrollbar-thumb { background: var(--gold-dark); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--gold-mid); }
    </style>
</head>
<body>
<c:if test="${empty sessionScope.loginUser}">
    <script>
        alert("道友请先登录，方可使用典籍管理功能！");
        window.location.href = "${pageContext.request.contextPath}/login.jsp";
    </script>
</c:if>

<div class="nav-sidebar">
    <div class="avatar-wrap">
        <div class="avatar-box">
            <img src="${pageContext.request.contextPath}/images/1.png" alt="头像框" class="avatar-frame">
            <img src="${pageContext.request.contextPath}${sessionScope.loginUser.avatarPath}" alt="头像" class="user-avatar">
        </div>
        <div class="user-name">${sessionScope.loginUser.username}</div>
        <div class="user-title">${sessionScope.loginUser.userTitle}</div>
    </div>
    <div class="logo">📜 Online藏书阁</div>
    <a href="zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
    <a href="tushuguan" class="nav-item">📚 全本藏书</a>
    <a href="${pageContext.request.contextPath}/bookManage" class="nav-item active">📋 典籍总录·管理</a>
    <a href="usersList" class="nav-item">👥 人员注册名录</a>
    <a href="${pageContext.request.contextPath}/chapterAdd" class="nav-item">📖 录入章节</a>
    <a href="javascript:openAddForm()" class="nav-item">✍️ 新增典籍</a>
</div>

<div class="content-wrap">
    <h1 class="page-title">藏经阁典籍总录</h1>

    <div class="search-bar">
        <input type="hidden" id="sortField" value="id">
        <input type="hidden" id="sortOrder" value="desc">
        <div class="search-group">
            <input type="text" class="search-input" id="searchInput" placeholder="典籍名称" value="${empty keyword ? '' : keyword}">
            <input type="text" class="search-input" id="authorSearchInput" placeholder="作者" value="${empty author ? '' : author}">

            <div class="single-select-wrapper" id="searchTypeWrapper">
                <div class="single-select-trigger" id="searchTypeTrigger">选择类型</div>
                <div class="single-select-dropdown" id="searchTypeDropdown">
                    <div class="single-select-option" data-value="1">玄幻修仙</div>
                    <div class="single-select-option" data-value="2">都市生活</div>
                    <div class="single-select-option" data-value="3">科幻未来</div>
                    <div class="single-select-option" data-value="4">历史武侠</div>
                    <div class="single-select-option" data-value="5">游戏竞技</div>
                    <div class="single-select-option" data-value="6">仙侠奇缘</div>
                    <div class="single-select-option" data-value="7">悬疑推理</div>
                    <div class="single-select-option" data-value="8">灵异神怪</div>
                </div>
            </div>
            <input type="hidden" id="searchTypeId" value="">

            <div class="single-select-wrapper" id="searchThemeWrapper">
                <div class="single-select-trigger" id="searchThemeTrigger">选择主题</div>
                <div class="single-select-dropdown" id="searchThemeDropdown">
                    <!-- 主题选项由JS动态生成 -->
                </div>
            </div>
            <input type="hidden" id="searchThemeNames" name="themeNames" value="">

            <button class="magic-btn" onclick="searchBook()">🔍 搜索</button>
            <button class="magic-btn" onclick="resetSearch()">重置</button>
        </div>
        <a href="javascript:openAddForm()" class="magic-btn">✍️ 新增典籍</a>
    </div>

    <div class="book-table-wrap">
        <table class="book-table" id="bookTable">
            <colgroup>
                <col style="width: 80px;"><col style="width: 60px;"><col style="width: 150px;">
                <col style="width: 120px;"><col style="width: 140px;"><col style="width: 130px;">
                <col style="width: 110px;"><col style="width: 90px;"><col style="width: 80px;">
                <col style="width: 80px;"><col style="width: 240px;">
            </colgroup>
            <thead>
            <tr>
                <th>封面</th>
                <th id="sortIdTh" style="cursor: pointer; user-select: none;" onclick="switchSort()">典籍ID <span id="sortArrow">↓</span></th>
                <th>典籍名称</th>
                <th>作者</th>
                <th>类型</th>
                <th>主题标签</th>
                <th>出版年份</th>
                <th>传阅次数</th>
                <th>格式</th>
                <th>价格</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="bookTableBody">
            <c:forEach items="${bookList}" var="book">
                <tr data-book-id="${book.id}"
                    data-title="${book.bookTitle}"
                    data-author="${book.bookAuthor}"
                    data-summary="${book.bookSummary}"
                    data-type-id="${book.typeIdsStr}"
                    data-type-name="${book.typeNamesStr}"
                    data-theme="${book.themesStr}"
                    data-pubyear="${book.bookPubYear}"
                    data-times="${book.downloadTimes}"
                    data-format="${book.bookFormat}"
                    data-price="${book.price}"
                    data-file="${book.bookFile}"
                    data-cover="${book.bookCover}">
                    <td>
                        <c:choose>
                            <c:when test="${not empty book.bookCover}">
                                <img src="${pageContext.request.contextPath}${book.bookCover}" alt="${book.bookTitle}" class="book-cover-img" loading="lazy" onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'60\' height=\'80\' viewBox=\'0 0 60 80\'%3E%3Crect width=\'60\' height=\'80\' fill=\'%233d5a5a\'/%3E%3Ctext x=\'8\' y=\'45\' font-family=\'SimSun\' font-size=\'12\' fill=\'%23c9a866\'%3E无封面%3C/text%3E%3C/svg%3E'">
                            </c:when>
                            <c:otherwise>
                                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='80' viewBox='0 0 60 80'%3E%3Crect width='60' height='80' fill='%233d5a5a'/%3E%3Ctext x='8' y='45' font-family='SimSun' font-size='12' fill='%23c9a866'%3E无封面%3C/text%3E%3C/svg%3E" alt="默认封面" class="book-cover-img">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${book.id}</td>
                    <td>${book.bookTitle}</td>
                    <td>${book.bookAuthor}</td>
                    <td>${book.typeNamesStr}</td>
                    <td class="theme-td">${book.themesStr}</td>
                    <td>${book.bookPubYear}</td>
                    <td>${book.downloadTimes}</td>
                    <td>${book.bookFormat}</td>
                    <td>${book.price}</td>
                    <td>
                        <div class="action-group">
                            <button class="magic-btn btn-sm" onclick="openEditModal(this.closest('tr'))">编辑</button>
                            <a href="${pageContext.request.contextPath}/gameManage?bookId=${book.id}" class="magic-btn btn-sm" style="background: #4a4a6a; border-color: #8a8ab8;">📝剧情</a>
                            <a href="${pageContext.request.contextPath}/chapterAdd?bookId=${book.id}" class="magic-btn btn-sm">录章节</a>
                            <a href="tushuguan?targetBookId=${book.id}" class="magic-btn btn-sm btn-success">预览</a>
                            <!-- ✅ 新增：典籍下载按钮 -->
                            <button class="magic-btn btn-sm" style="background: #2a4a6a; border-color: #6a8ab8;"
                                    onclick="downloadBookFile('${book.id}', '${book.bookFile}')">下载</button>
                            <a href="bookDelete?id=${book.id}" class="magic-btn btn-sm btn-danger" onclick="return confirm('确定要销毁这部典籍吗？此操作不可恢复！')">销毁</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookList}">
                <tr><td colspan="11" class="table-empty">藏经阁暂无典籍，快去录入新典籍吧</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- 新增弹窗（支持多文件上传） -->
<div class="form-modal" id="addFormModal">
    <div class="form-card">
        <h3>录入新典籍</h3>
        <form action="bookAdd" method="post" id="addForm">
            <div class="form-row"><label>典籍名称</label><input type="text" name="bookTitle" required></div>
            <div class="form-row"><label>典籍作者</label><input type="text" name="bookAuthor" required></div>
            <div class="form-row"><label>典籍简介</label><textarea name="bookSummary" required></textarea></div>
            <div class="form-row">
                <label>类型</label>
                <div class="single-select-wrapper" id="addTypeWrapper">
                    <div class="single-select-trigger" id="addTypeTrigger">请选择类型</div>
                    <div class="single-select-dropdown" id="addTypeDropdown">
                        <div class="single-select-option" data-value="1">玄幻修仙</div>
                        <div class="single-select-option" data-value="2">都市生活</div>
                        <div class="single-select-option" data-value="3">科幻未来</div>
                        <div class="single-select-option" data-value="4">历史武侠</div>
                        <div class="single-select-option" data-value="5">游戏竞技</div>
                        <div class="single-select-option" data-value="6">仙侠奇缘</div>
                        <div class="single-select-option" data-value="7">悬疑推理</div>
                        <div class="single-select-option" data-value="8">灵异神怪</div>
                    </div>
                </div>
                <input type="hidden" name="typeIds" id="addTypeId" value="">
            </div>
            <div class="form-row">
                <label>主题标签</label>
                <div class="single-select-wrapper" id="addThemeWrapper">
                    <div class="single-select-trigger" id="addThemeTrigger">请选择主题</div>
                    <div class="single-select-dropdown" id="addThemeDropdown">
                        <!-- 主题选项由JS动态生成 -->
                    </div>
                </div>
                <input type="hidden" name="themeNames" id="addThemeNames" value="">
            </div>
            <div class="form-row"><label>典籍价格</label><input type="number" name="price" step="0.01" value="0.00" required></div>
            <div class="form-row"><label>传阅次数</label><input type="number" name="downloadTimes" value="0" required></div>
            <div class="form-row"><label>出版年份</label><input type="date" name="bookPubYear" required></div>
            <div class="form-row">
                <label>典籍文件路径（支持批量上传PDF/EPUB）</label>
                <div class="file-input-group">
                    <input type="text" name="bookFile" id="add-book-file" value="/files/default.pdf">
                    <input type="file" id="add-book-file-input" accept=".pdf,.epub,.txt" multiple>
                    <button type="button" class="magic-btn btn-sm" onclick="document.getElementById('add-book-file-input').click()">选择文件</button>
                    <span class="file-count" id="add-file-count"></span>
                </div>
            </div>
            <div class="form-row">
                <label>典籍封面路径（支持批量上传图片）</label>
                <div class="file-input-group">
                    <input type="text" name="bookCover" id="add-book-cover" value="/cover/default.jpg">
                    <input type="file" id="add-cover-file" accept="image/*" multiple>
                    <button type="button" class="magic-btn btn-sm" onclick="document.getElementById('add-cover-file').click()">选择文件</button>
                    <span class="file-count" id="add-cover-count"></span>
                </div>
            </div>
            <div class="form-row">
                <label>典籍格式</label>
                <select name="bookFormat" required>
                    <option value="pdf">PDF</option><option value="epub">EPUB</option><option value="txt">TXT</option>
                </select>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn" onclick="beforeAddSubmit()">录入典籍</button>
                <button type="button" class="magic-btn" onclick="closeAddForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<!-- 编辑弹窗（支持多文件上传） -->
<div class="form-modal" id="editFormModal">
    <div class="form-card">
        <h3>编辑典籍信息</h3>
        <form id="editForm" method="post" action="bookUpdate">
            <input type="hidden" name="id" id="edit-book-id">
            <div class="form-row"><label>典籍名称</label><input type="text" name="bookTitle" id="edit-book-title" required></div>
            <div class="form-row"><label>典籍作者</label><input type="text" name="bookAuthor" id="edit-book-author" required></div>
            <div class="form-row"><label>典籍简介</label><textarea name="bookSummary" id="edit-book-summary" required></textarea></div>
            <div class="form-row">
                <label>类型</label>
                <div class="single-select-wrapper" id="editTypeWrapper">
                    <div class="single-select-trigger" id="editTypeTrigger">请选择类型</div>
                    <div class="single-select-dropdown" id="editTypeDropdown">
                        <div class="single-select-option" data-value="1">玄幻修仙</div>
                        <div class="single-select-option" data-value="2">都市生活</div>
                        <div class="single-select-option" data-value="3">科幻未来</div>
                        <div class="single-select-option" data-value="4">历史武侠</div>
                        <div class="single-select-option" data-value="5">游戏竞技</div>
                        <div class="single-select-option" data-value="6">仙侠奇缘</div>
                        <div class="single-select-option" data-value="7">悬疑推理</div>
                        <div class="single-select-option" data-value="8">灵异神怪</div>
                    </div>
                </div>
                <input type="hidden" name="typeIds" id="editTypeId" value="">
            </div>
            <div class="form-row">
                <label>主题标签</label>
                <div class="single-select-wrapper" id="editThemeWrapper">
                    <div class="single-select-trigger" id="editThemeTrigger">请选择主题</div>
                    <div class="single-select-dropdown" id="editThemeDropdown">
                        <!-- 主题选项由JS动态生成 -->
                    </div>
                </div>
                <input type="hidden" name="themeNames" id="editThemeNames" value="">
            </div>
            <div class="form-row"><label>典籍价格(灵石)</label><input type="number" name="price" id="edit-book-price" step="0.01" required></div>
            <div class="form-row"><label>传阅次数</label><input type="number" name="downloadTimes" id="edit-book-times" required></div>
            <div class="form-row"><label>出版年份</label><input type="date" name="bookPubYear" id="edit-book-pubyear" required></div>
            <div class="form-row">
                <label>典籍文件路径（支持批量上传PDF/EPUB）</label>
                <div class="file-input-group">
                    <input type="text" name="bookFile" id="edit-book-file">
                    <input type="file" id="edit-book-file-input" accept=".pdf,.epub,.txt" multiple>
                    <button type="button" class="magic-btn btn-sm" onclick="document.getElementById('edit-book-file-input').click()">选择文件</button>
                    <span class="file-count" id="edit-file-count"></span>
                </div>
            </div>
            <div class="form-row">
                <label>典籍封面路径（支持批量上传图片）</label>
                <div class="file-input-group">
                    <input type="text" name="bookCover" id="edit-book-cover">
                    <input type="file" id="edit-cover-file" accept="image/*" multiple>
                    <button type="button" class="magic-btn btn-sm" onclick="document.getElementById('edit-cover-file').click()">选择文件</button>
                    <span class="file-count" id="edit-cover-count"></span>
                </div>
            </div>
            <div class="form-row">
                <label>典籍格式</label>
                <select name="bookFormat" id="edit-book-format" required>
                    <option value="pdf">PDF</option><option value="epub">EPUB</option><option value="txt">TXT</option>
                </select>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn" onclick="beforeEditSubmit()">保存修改</button>
                <button type="button" class="magic-btn" onclick="closeEditForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<script>
    // ========== 原有所有JS代码完全保留 ==========
    var categoryThemes = {
        '1': ['凡人流','单女主','后宫','纯爱','无敌流','种田','系统流','重生','穿越','女频'],
        '2': ['商战','职场','纯爱','重生','系统流','种田','日常','搞笑','逆袭','年代文'],
        '3': ['星际','末世','无限流','进化','AI','赛博朋克','太空歌剧','基因','虚拟现实','外星'],
        '4': ['武侠','历史','争霸','权谋','纯爱','女频','穿越','重生','种田','系统流'],
        '5': ['电竞','网游','竞技','MOBA','FPS','卡牌','格斗','模拟','重生','系统流'],
        '6': ['仙侠','修真','洪荒','封神','西游','纯爱','女频','重生','系统流','种田'],
        '7': ['本格','社会派','密室','连环','侦探','法医','心理','悬疑','惊悚','反转'],
        '8': ['恐怖','灵异','鬼怪','民俗','克苏鲁','怪谈','惊悚','悬疑','探险','考古']
    };

    var selectEventHandlers = {};

    function initSingleSelect(wrapperId, triggerId, dropdownId, onChangeCallback, autoClose = true) {
        var wrapper = document.getElementById(wrapperId);
        var trigger = document.getElementById(triggerId);
        var dropdown = document.getElementById(dropdownId);
        var options = dropdown.querySelectorAll('.single-select-option');

        if (selectEventHandlers[wrapperId]) {
            trigger.removeEventListener('click', selectEventHandlers[wrapperId].triggerClick);
            document.removeEventListener('click', selectEventHandlers[wrapperId].documentClick);
            options.forEach(function(option, index) {
                option.removeEventListener('click', selectEventHandlers[wrapperId].optionClicks[index]);
            });
        }

        var handlers = {
            triggerClick: function(e) {
                e.stopPropagation();
                document.querySelectorAll('.single-select-wrapper').forEach(function(w) {
                    if (w.id !== wrapperId) w.classList.remove('open');
                });
                wrapper.classList.toggle('open');
            },
            documentClick: function(e) {
                if (!wrapper.contains(e.target)) wrapper.classList.remove('open');
            },
            optionClicks: []
        };

        trigger.addEventListener('click', handlers.triggerClick);
        document.addEventListener('click', handlers.documentClick);

        options.forEach(function(option) {
            var optionClick = function() {
                options.forEach(function(opt) { opt.classList.remove('selected'); });
                option.classList.add('selected');
                trigger.innerText = option.innerText;
                if (autoClose) {
                    wrapper.classList.remove('open');
                }
                if (onChangeCallback) onChangeCallback(option.dataset.value, option.innerText);
            };
            option.addEventListener('click', optionClick);
            handlers.optionClicks.push(optionClick);
        });

        selectEventHandlers[wrapperId] = handlers;
    }

    function closeSelectWrapper(wrapperId) {
        document.getElementById(wrapperId).classList.remove('open');
    }

    function closeAllSelectWrappers() {
        document.querySelectorAll('.single-select-wrapper').forEach(function(w) {
            w.classList.remove('open');
        });
    }

    function updateSearchThemeOptions(typeId, typeName) {
        document.getElementById('searchTypeId').value = typeId;
        var themeDropdown = document.getElementById('searchThemeDropdown');
        themeDropdown.innerHTML = '';

        var themes = categoryThemes[typeId] || [];
        themes.forEach(function(theme) {
            var div = document.createElement('div');
            div.className = 'single-select-option';
            div.dataset.value = theme;
            div.innerText = theme;
            themeDropdown.appendChild(div);
        });

        initSingleSelect('searchThemeWrapper', 'searchThemeTrigger', 'searchThemeDropdown', function(themeValue, themeText) {
            document.getElementById('searchThemeNames').value = themeValue;
            closeAllSelectWrappers();
            filterBookList();
        }, true);

        document.getElementById('searchThemeTrigger').innerText = '选择主题';
        document.getElementById('searchThemeNames').value = '';

        setTimeout(function() {
            document.getElementById('searchThemeWrapper').classList.add('open');
        }, 50);

        filterBookList();
    }

    function searchBook() {
        var keyword = document.getElementById('searchInput').value.trim();
        var author = document.getElementById('authorSearchInput').value.trim();
        var typeId = document.getElementById('searchTypeId').value;
        var themeNames = document.getElementById('searchThemeNames').value;
        var sortField = document.getElementById('sortField').value;
        var sortOrder = document.getElementById('sortOrder').value;

        var params = new URLSearchParams();
        if (keyword) params.append('keyword', keyword);
        if (author) params.append('author', author);
        if (typeId) params.append('typeId', typeId);
        if (themeNames) params.append('themeNames', themeNames);
        params.append('sortField', sortField);
        params.append('sortOrder', sortOrder);

        window.location.href = "${pageContext.request.contextPath}/bookManage?" + params.toString();
    }

    function resetSearch() {
        document.getElementById('searchInput').value = '';
        document.getElementById('authorSearchInput').value = '';
        document.getElementById('searchTypeTrigger').innerText = '选择类型';
        document.getElementById('searchTypeId').value = '';
        document.getElementById('searchThemeTrigger').innerText = '选择主题';
        document.getElementById('searchThemeNames').value = '';
        document.getElementById('searchThemeDropdown').innerHTML = '';
        document.getElementById('sortField').value = 'id';
        document.getElementById('sortOrder').value = 'desc';
        document.getElementById('sortArrow').innerText = '↓';
        window.location.href = "${pageContext.request.contextPath}/bookManage";
    }

    function openAddForm() {
        document.getElementById('addForm').reset();
        // 重置所有文件选择框和计数
        document.getElementById('add-cover-file').value = '';
        document.getElementById('add-book-file-input').value = '';
        document.getElementById('add-cover-count').innerText = '';
        document.getElementById('add-file-count').innerText = '';
        document.getElementById('addTypeTrigger').innerText = '请选择类型';
        document.getElementById('addTypeId').value = '';
        document.getElementById('addThemeTrigger').innerText = '请选择主题';
        document.getElementById('addThemeNames').value = '';
        document.getElementById('addThemeDropdown').innerHTML = '';
        addFormModal.style.display = 'flex';
    }

    function closeAddForm() { addFormModal.style.display = 'none'; }
    addFormModal.onclick = function(e) { if (e.target === this) closeAddForm(); };

    function beforeAddSubmit() {
        var typeId = document.getElementById('addTypeId').value;
        if (!typeId) { alert("请选择一个类型！"); event.preventDefault(); return; }
    }

    function updateAddThemeOptions(typeId, typeName) {
        document.getElementById('addTypeId').value = typeId;
        var themeDropdown = document.getElementById('addThemeDropdown');
        themeDropdown.innerHTML = '';

        var themes = categoryThemes[typeId] || [];
        themes.forEach(function(theme) {
            var div = document.createElement('div');
            div.className = 'single-select-option';
            div.dataset.value = theme;
            div.innerText = theme;
            themeDropdown.appendChild(div);
        });

        initSingleSelect('addThemeWrapper', 'addThemeTrigger', 'addThemeDropdown', function(themeValue, themeText) {
            document.getElementById('addThemeNames').value = themeValue;
            closeAllSelectWrappers();
        }, true);

        document.getElementById('addThemeTrigger').innerText = '请选择主题';
        document.getElementById('addThemeNames').value = '';

        setTimeout(function() {
            document.getElementById('addThemeWrapper').classList.add('open');
        }, 50);
    }

    function openEditModal(tr) {
        var ds = tr.dataset;
        document.getElementById('edit-book-id').value = ds.bookId;
        document.getElementById('edit-book-title').value = ds.title;
        document.getElementById('edit-book-author').value = ds.author;
        document.getElementById('edit-book-summary').value = ds.summary;
        // 重置所有文件选择框和计数
        document.getElementById('edit-cover-file').value = '';
        document.getElementById('edit-book-file-input').value = '';
        document.getElementById('edit-cover-count').innerText = '';
        document.getElementById('edit-file-count').innerText = '';

        var bookTypeId = ds.typeId || '';
        if (bookTypeId) {
            var typeOption = document.querySelector('#editTypeDropdown .single-select-option[data-value="' + bookTypeId + '"]');
            if (typeOption) {
                typeOption.click();
            }
        }

        var bookTheme = ds.theme || '';
        if (bookTheme && bookTypeId) {
            setTimeout(function() {
                var themeOption = document.querySelector('#editThemeDropdown .single-select-option[data-value="' + bookTheme + '"]');
                if (themeOption) {
                    themeOption.click();
                }
            }, 100);
        }

        document.getElementById('edit-book-price').value = ds.price;
        document.getElementById('edit-book-times').value = ds.times;
        document.getElementById('edit-book-pubyear').value = ds.pubyear;
        document.getElementById('edit-book-file').value = ds.file;
        document.getElementById('edit-book-cover').value = ds.cover;
        document.getElementById('edit-book-format').value = ds.format;

        editFormModal.style.display = 'flex';
    }

    function closeEditForm() { editFormModal.style.display = 'none'; }
    editFormModal.onclick = function(e) { if (e.target === this) closeEditForm(); };

    function beforeEditSubmit() {
        var typeId = document.getElementById('editTypeId').value;
        if (!typeId) { alert("请选择一个类型！"); event.preventDefault(); return; }
    }

    function updateEditThemeOptions(typeId, typeName) {
        document.getElementById('editTypeId').value = typeId;
        var themeDropdown = document.getElementById('editThemeDropdown');
        themeDropdown.innerHTML = '';

        var themes = categoryThemes[typeId] || [];
        themes.forEach(function(theme) {
            var div = document.createElement('div');
            div.className = 'single-select-option';
            div.dataset.value = theme;
            div.innerText = theme;
            themeDropdown.appendChild(div);
        });

        initSingleSelect('editThemeWrapper', 'editThemeTrigger', 'editThemeDropdown', function(themeValue, themeText) {
            document.getElementById('editThemeNames').value = themeValue;
            closeAllSelectWrappers();
        }, true);

        document.getElementById('editThemeTrigger').innerText = '请选择主题';
        document.getElementById('editThemeNames').value = '';

        setTimeout(function() {
            document.getElementById('editThemeWrapper').classList.add('open');
        }, 50);
    }

    function switchSort() {
        var sortOrderInput = document.getElementById('sortOrder');
        var sortArrow = document.getElementById('sortArrow');
        if (sortOrderInput.value === 'desc') {
            sortOrderInput.value = 'asc';
            sortArrow.innerText = '↑';
        } else {
            sortOrderInput.value = 'desc';
            sortArrow.innerText = '↓';
        }
        searchBook();
    }

    // ========== ✅ 优化：通用多文件上传函数（解决所有4个问题） ==========
    function uploadFiles(fileInputId, pathInputId, countSpanId, uploadType) {
        var fileInput = document.getElementById(fileInputId);
        var pathInput = document.getElementById(pathInputId);
        var countSpan = document.getElementById(countSpanId);
        var btn = pathInput.nextElementSibling.nextElementSibling;

        if (fileInput.files.length === 0) return;

        // ========== 问题3+4：前端预校验（大小+类型） ==========
        var allowedExts = uploadType === 'image'
            ? ['.jpg', '.jpeg', '.png', '.gif', '.webp']
            : ['.pdf', '.epub', '.txt'];
        var maxSize = 10 * 1024 * 1024; // 10MB
        var errorFiles = [];

        for (var i = 0; i < fileInput.files.length; i++) {
            var file = fileInput.files[i];
            var ext = file.name.substring(file.name.lastIndexOf(".")).toLowerCase();

            if (!allowedExts.includes(ext)) {
                errorFiles.push("「" + file.name + "」类型不允许");
            }
            if (file.size > maxSize) {
                errorFiles.push("「" + file.name + "」超过10MB");
            }
        }

        if (errorFiles.length > 0) {
            alert("文件校验失败：\n" + errorFiles.join("\n"));
            fileInput.value = '';
            return;
        }

        // 上传中状态
        btn.classList.add('uploading');
        btn.innerText = '上传中(' + fileInput.files.length + ')';
        countSpan.innerText = '已选择' + fileInput.files.length + '个文件';

        var formData = new FormData();
        formData.append('type', uploadType);
        // 添加所有文件
        for (var i = 0; i < fileInput.files.length; i++) {
            formData.append('file' + i, fileInput.files[i]);
        }

        // 异步上传
        fetch('${pageContext.request.contextPath}/fileUpload', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    // ========== 问题2：多文件路径用逗号分隔 ==========
                    pathInput.value = result.paths.join(',');
                    alert("成功上传" + result.paths.length + "个文件");
                } else {
                    alert("上传失败：" + result.message);
                }
            })
            .catch(error => {
                alert("上传失败：" + error.message);
            })
            .finally(() => {
                btn.classList.remove('uploading');
                btn.innerText = '选择文件';
            });
    }

    // 绑定所有文件上传事件
    // 封面上传（图片类型）
    document.getElementById('add-cover-file').addEventListener('change', function() {
        uploadFiles('add-cover-file', 'add-book-cover', 'add-cover-count', 'image');
    });
    document.getElementById('edit-cover-file').addEventListener('change', function() {
        uploadFiles('edit-cover-file', 'edit-book-cover', 'edit-cover-count', 'image');
    });
    // 典籍文件上传（文档类型）
    document.getElementById('add-book-file-input').addEventListener('change', function() {
        uploadFiles('add-book-file-input', 'add-book-file', 'add-file-count', 'document');
    });
    document.getElementById('edit-book-file-input').addEventListener('change', function() {
        uploadFiles('edit-book-file-input', 'edit-book-file', 'edit-file-count', 'document');
    });

    // ========== 原有所有JS代码完全保留 ==========
    window.onload = function() {
        initSingleSelect('searchTypeWrapper', 'searchTypeTrigger', 'searchTypeDropdown', updateSearchThemeOptions, false);
        initSingleSelect('addTypeWrapper', 'addTypeTrigger', 'addTypeDropdown', updateAddThemeOptions, false);
        initSingleSelect('editTypeWrapper', 'editTypeTrigger', 'editTypeDropdown', updateEditThemeOptions, false);

        var urlParams = new URLSearchParams(window.location.search);

        var sortOrder = urlParams.get('sortOrder');
        if (sortOrder === 'asc') {
            document.getElementById('sortOrder').value = 'asc';
            document.getElementById('sortArrow').innerText = '↑';
        }

        var keywordFromUrl = urlParams.get('keyword');
        if (keywordFromUrl) {
            document.getElementById('searchInput').value = keywordFromUrl;
        }

        var authorFromUrl = urlParams.get('author');
        if (authorFromUrl) {
            document.getElementById('authorSearchInput').value = authorFromUrl;
        }

        var typeIdFromUrl = urlParams.get('typeId');
        if (typeIdFromUrl) {
            var typeOption = document.querySelector('#searchTypeDropdown .single-select-option[data-value="' + typeIdFromUrl + '"]');
            if (typeOption) {
                typeOption.click();
            }
        }

        var themeFromUrl = urlParams.get('themeNames');
        if (themeFromUrl && typeIdFromUrl) {
            setTimeout(function() {
                var themeOption = document.querySelector('#searchThemeDropdown .single-select-option[data-value="' + themeFromUrl + '"]');
                if (themeOption) {
                    themeOption.click();
                }
            }, 100);
        }

        allBookRows = Array.from(document.querySelectorAll('#bookTableBody tr[data-book-id]'));
        filterBookList();
    };

    var allBookRows = [];
    function filterBookList() {
        var keyword = document.getElementById('searchInput').value.toLowerCase().trim();
        var author = document.getElementById('authorSearchInput').value.toLowerCase().trim();
        var searchTypeId = document.getElementById('searchTypeId').value;
        var themeFilter = document.getElementById('searchThemeNames').value;
        var hasMatch = false;

        allBookRows.forEach(function(row) {
            var ds = row.dataset;
            var kwMatch = !keyword || ds.title.toLowerCase().includes(keyword);
            var authorMatch = !author || ds.author.toLowerCase().includes(author);
            var typeMatch = !searchTypeId || ds.typeId === searchTypeId;
            var themeMatch = !themeFilter || ds.theme === themeFilter;

            var show = kwMatch && authorMatch && typeMatch && themeMatch;
            row.style.display = show ? '' : 'none';
            if (show) hasMatch = true;
        });

        var emptyRow = document.querySelector('#bookTableBody tr:has(.table-empty)');
        if (emptyRow) emptyRow.style.display = hasMatch ? 'none' : '';
    }

    document.getElementById('searchInput').addEventListener('input', filterBookList);
    document.getElementById('searchInput').addEventListener('keydown', function(e) { if (e.keyCode === 13) searchBook(); });
    document.getElementById('authorSearchInput').addEventListener('input', filterBookList);
    document.getElementById('authorSearchInput').addEventListener('keydown', function(e) { if (e.keyCode === 13) searchBook(); });

    // 符文特效
    var runeLibrary = ['临','兵','斗','者','皆','列','阵','在','前'];
    document.addEventListener('click', function(e) {
        if (e.target.closest('.nav-sidebar .nav-item') || e.target.closest('.avatar-wrap')) return;
        var wave = document.createElement('div'); wave.className = 'sword-wave';
        wave.style.left = e.clientX + 'px'; wave.style.top = e.clientY + 'px';
        document.body.appendChild(wave);
        setTimeout(function() { wave.classList.add('wave-animate'); }, 10);
        wave.addEventListener('animationend', function() { this.remove(); });
        var rune = runeLibrary[Math.floor(Math.random() * runeLibrary.length)];
        var runeEl = document.createElement('div'); runeEl.className = 'rune-text'; runeEl.innerText = rune;
        runeEl.style.left = (e.clientX - 16) + 'px'; runeEl.style.top = (e.clientY - 20) + 'px';
        document.body.appendChild(runeEl);
        setTimeout(function() { runeEl.classList.add('rune-animate'); }, 10);
        runeEl.addEventListener('animationend', function() { this.remove(); });
    });

    // ESC键关闭弹窗和所有下拉框
    document.onkeydown = function(e) {
        if (e.keyCode === 27) {
            closeAddForm(); closeEditForm();
            closeAllSelectWrappers();
        }
    };

    // ========== ✅ 纯原生JS下载函数（绝对不会和JSP冲突） ==========
    function downloadBookFile(bookId, filePath) {
        if (!filePath || filePath === '/files/default.pdf') {
            alert('该典籍暂无可下载的文件！');
            return;
        }

        var filePaths = filePath.split(',');
        var successCount = 0;
        var failCount = 0;
        var failMessages = [];
        var totalFiles = filePaths.length;
        var processedCount = 0;

        // 逐个下载，间隔500ms防止浏览器拦截
        function downloadNext(index) {
            if (index >= totalFiles) {
                // 所有文件处理完成，汇总提示
                var message = '';
                if (successCount > 0) {
                    message += '✅ 成功下载 ' + successCount + ' 个文件\n';
                }
                if (failCount > 0) {
                    message += '❌ 失败 ' + failCount + ' 个文件：\n' + failMessages.join('\n');
                }
                if (message) {
                    alert(message.trim());
                }
                return;
            }

            var path = filePaths[index].trim();
            if (!path) {
                processedCount++;
                downloadNext(index + 1);
                return;
            }

            // 先检查文件是否存在
            var xhr = new XMLHttpRequest();
            xhr.open('HEAD', '${pageContext.request.contextPath}/fileDownload?bookId=' + bookId + '&filePath=' + encodeURIComponent(path), true);

            xhr.onload = function() {
                if (xhr.status === 200) {
                    // 文件存在，触发下载
                    var a = document.createElement('a');
                    a.href = '${pageContext.request.contextPath}/fileDownload?bookId=' + bookId + '&filePath=' + encodeURIComponent(path);
                    a.target = '_blank';
                    a.style.display = 'none';
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                    successCount++;
                } else {
                    // 文件不存在，解析错误信息
                    try {
                        var error = JSON.parse(xhr.responseText);
                        failMessages.push('「' + path + '」：' + error.message);
                    } catch (e) {
                        failMessages.push('「' + path + '」：服务器错误');
                    }
                    failCount++;
                }

                processedCount++;
                // 间隔500ms下载下一个
                setTimeout(function() {
                    downloadNext(index + 1);
                }, 500);
            };

            xhr.onerror = function() {
                failMessages.push('「' + path + '」：网络错误');
                failCount++;
                processedCount++;
                setTimeout(function() {
                    downloadNext(index + 1);
                }, 500);
            };

            xhr.send();
        }

        // 开始下载第一个文件
        downloadNext(0);
    }
</script>
</body>
</html>