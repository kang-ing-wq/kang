<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>典籍总录 - Online藏书阁</title>
    <style>
        /* ========== 全局重置与变量 ========== */
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
            --red: #a86666;
            --green: #7aa88a;
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
        }

        /* ========== 左侧导航栏样式 ========== */
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
        .user-avatar {
            width: 100%;
            height: 100%;
            object-fit: cover;
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

        /* ========== 右侧主内容区 ========== */
        .content-wrap {
            margin-left: 280px;
            min-height: 100vh;
            padding: 50px 60px;
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

        /* ========== 搜索筛选栏 ========== */
        .search-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
        }
        .search-group {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-input {
            padding: 10px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--gold-dark);
            border-radius: 5px;
            color: var(--text-primary);
            font-size: 16px;
            font-family: "SimSun", serif;
            width: 300px;
        }
        .search-input:focus {
            outline: none;
            border-color: var(--gold-mid);
            box-shadow: 0 0 12px rgba(201, 168, 102, 0.5);
        }
        .search-select {
            padding: 10px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--gold-dark);
            border-radius: 5px;
            color: var(--text-primary);
            font-size: 16px;
            font-family: "SimSun", serif;
            cursor: pointer;
        }
        .magic-btn {
            padding: 10px 25px;
            background: linear-gradient(90deg, #173036, #244a52);
            color: var(--text-primary);
            text-decoration: none;
            font-size: 16px;
            border: 2px solid var(--gold-dark);
            border-radius: 5px;
            transition: all 0.3s ease;
            letter-spacing: 2px;
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
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(201, 168, 102, 0.6);
        }
        .magic-btn:hover::before {
            left: 100%;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 14px;
        }
        .btn-danger {
            background: linear-gradient(90deg, #5a1a1a, #7a2a2a);
            border-color: #a83232;
        }
        .btn-danger:hover {
            background: linear-gradient(90deg, #a83232, #c84242);
            color: #fff;
        }
        .btn-success {
            background: linear-gradient(90deg, #1a5a2a, #2a7a3a);
            border-color: var(--green);
        }
        .btn-success:hover {
            background: linear-gradient(90deg, var(--green), #8ab89a);
            color: var(--bg-deepest);
        }

        /* ========== 典籍表格核心样式 ========== */
        .book-table-wrap {
            width: 100%;
            overflow-x: auto;
            border-radius: 8px;
            border: 2px solid var(--gold-dark);
            box-shadow: 0 0 30px rgba(0,0,0,0.6);
        }
        .book-table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(15, 37, 43, 0.9);
        }
        .book-table thead {
            background: linear-gradient(90deg, var(--bg-mid), var(--bg-light), var(--bg-mid));
            border-bottom: 2px solid var(--gold-dark);
        }
        .book-table th {
            padding: 15px 12px;
            text-align: left;
            color: var(--gold-light);
            font-size: 18px;
            letter-spacing: 2px;
            font-weight: bold;
            white-space: nowrap;
        }
        .book-table tbody tr {
            border-bottom: 1px solid rgba(201, 168, 102, 0.2);
            transition: all 0.3s ease;
        }
        .book-table tbody tr:hover {
            background: rgba(201, 168, 102, 0.1);
        }
        .book-table td {
            padding: 12px;
            color: var(--text-secondary);
            font-size: 16px;
            line-height: 1.5;
            vertical-align: middle;
        }
        /* 封面图片样式 */
        .book-cover-img {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid var(--gold-dark);
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            transition: transform 0.2s ease;
        }
        .book-cover-img:hover {
            transform: scale(1.05);
            border-color: var(--gold-mid);
        }
        .book-table .action-group {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }
        .table-empty {
            text-align: center;
            padding: 60px 0;
            color: var(--text-tertiary);
            font-size: 18px;
            letter-spacing: 2px;
        }

        /* ========== 弹窗通用样式 ========== */
        .form-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.85);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .form-card {
            background: linear-gradient(180deg, var(--bg-light) 0%, var(--bg-deepest) 100%);
            border: 3px solid var(--gold-mid);
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 0 50px rgba(201, 168, 102, 0.35);
            max-height: 90vh;
            overflow-y: auto;
            width: 700px;
        }
        .form-card h3 {
            text-align: center;
            font-size: 32px;
            color: var(--text-primary);
            margin-bottom: 30px;
            letter-spacing: 5px;
            text-shadow: 0 0 20px var(--gold-mid);
        }
        .form-row {
            margin-bottom: 20px;
        }
        .form-row label {
            display: block;
            font-size: 18px;
            color: var(--text-secondary);
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .form-row input, .form-row select, .form-row textarea {
            width: 100%;
            padding: 12px 15px;
            background: rgba(255,255,255,0.1);
            border: 1px solid var(--gold-dark);
            border-radius: 5px;
            color: var(--text-primary);
            font-size: 16px;
            font-family: "SimSun", serif;
        }
        .form-row input:focus, .form-row select:focus, .form-row textarea:focus {
            outline: none;
            border-color: var(--gold-mid);
            box-shadow: 0 0 12px rgba(201, 168, 102, 0.5);
        }
        .form-row textarea {
            resize: vertical;
            min-height: 80px;
        }
        .form-btn-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 30px;
        }

        /* ========== 符文波纹特效 ========== */
        .sword-wave {
            position: fixed;
            width: 60px;
            height: 60px;
            border: 3px solid #c9a866;
            border-radius: 50%;
            pointer-events: none;
            z-index: 99998;
            box-shadow: 0 0 15px #c9a866, 0 0 30px rgba(201, 168, 102, 0.6);
        }
        @keyframes waveExpand {
            0% { opacity: 1; transform: translate(-50%, -50%) scale(0.5); }
            100% { opacity: 0; transform: translate(-50%, -50%) scale(2.0); }
        }
        .wave-animate { animation: waveExpand 0.8s ease-out forwards; }
        .rune-text {
            position: fixed;
            font-family: "SimSun", "KaiTi", serif;
            font-size: 32px;
            font-weight: bold;
            color: #c9a866;
            text-shadow: 0 0 10px #c9a866, 0 0 20px rgba(201, 168, 102, 0.8);
            pointer-events: none;
            z-index: 99999;
            user-select: none;
            white-space: nowrap;
        }
        @keyframes runeFloat {
            0% { opacity: 1; transform: translateY(0) scale(1); }
            100% { opacity: 0; transform: translateY(-120px) scale(1.2); }
        }
        .rune-animate { animation: runeFloat 0.9s ease-out forwards; }

        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: var(--bg-deepest); }
        ::-webkit-scrollbar-thumb { background: var(--gold-dark); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--gold-mid); }
    </style>
</head>
<body>
<!-- 权限校验 -->
<c:if test="${empty sessionScope.loginUser}">
    <script>
        alert("道友请先登录，方可使用典籍管理功能！");
        window.location.href = "${pageContext.request.contextPath}/login.jsp";
    </script>
</c:if>

<!-- 左侧导航栏 -->
<div class="nav-sidebar">
    <div class="avatar-wrap">
        <div class="avatar-box">
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

<!-- 右侧主内容区 -->
<div class="content-wrap">
    <h1 class="page-title">藏经阁典籍总录</h1>

    <!-- 搜索筛选栏 -->
    <div class="search-bar">
        <!-- 排序状态隐藏域 -->
        <input type="hidden" id="sortField" value="id">
        <input type="hidden" id="sortOrder" value="desc">
        <div class="search-group">
            <input type="text" class="search-input" id="searchInput" placeholder="请输入典籍名称/作者搜索..." value="${empty keyword ? '' : keyword}">
            <select class="search-select" id="typeFilter">
                <option value="" ${empty typeId ? 'selected' : ''}>全部分类</option>
                <option value="1" ${typeId == '1' ? 'selected' : ''}>玄幻修真</option>
                <option value="2" ${typeId == '2' ? 'selected' : ''}>科幻科技</option>
                <option value="3" ${typeId == '3' ? 'selected' : ''}>历史武侠</option>
                <option value="4" ${typeId == '4' ? 'selected' : ''}>经典文学</option>
            </select>
            <button class="magic-btn" onclick="searchBook()">🔍 搜索</button>
            <button class="magic-btn" onclick="resetSearch()">重置</button>
        </div>
        <a href="javascript:openAddForm()" class="magic-btn">✍️ 新增典籍</a>
    </div>

    <!-- 典籍表格 -->
    <div class="book-table-wrap">
        <table class="book-table" id="bookTable">
            <colgroup>
                <col style="width: 80px;">
                <col style="width: 60px;">
                <col style="width: 150px;">
                <col style="width: 120px;">
                <col style="width: 100px;">
                <col style="width: 110px;">
                <col style="width: 90px;">
                <col style="width: 80px;">
                <col style="width: 100px;">
                <col style="width: 240px;">
            </colgroup>
            <thead>
            <tr>
                <th>封面</th>
                <th id="sortIdTh" style="cursor: pointer; user-select: none;" onclick="switchSort()">
                    典籍ID <span id="sortArrow">↓</span>
                </th>
                <th>典籍名称</th>
                <th>作者</th>
                <th>分类</th>
                <th>出版年份</th>
                <th>传阅次数</th>
                <th>格式</th>
                <th>价格(灵石)</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="bookTableBody">
            <c:forEach items="${bookList}" var="book">
                <tr
                        data-book-id="${book.id}"
                        data-title="${book.bookTitle}"
                        data-author="${book.bookAuthor}"
                        data-summary="${book.bookSummary}"
                        data-type-id="${book.typeId}"
                        data-pubyear="${book.bookPubYear}"
                        data-times="${book.downloadTimes}"
                        data-format="${book.bookFormat}"
                        data-price="${book.price}"
                        data-file="${book.bookFile}"
                        data-cover="${book.bookCover}">
                    <td>
                        <c:choose>
                            <c:when test="${not empty book.bookCover}">
                                <img src="${pageContext.request.contextPath}${book.bookCover}"
                                     alt="${book.bookTitle}"
                                     class="book-cover-img"
                                     loading="lazy"
                                     onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'60\' height=\'80\' viewBox=\'0 0 60 80\'%3E%3Crect width=\'60\' height=\'80\' fill=\'%233d5a5a\'/%3E%3Ctext x=\'8\' y=\'45\' font-family=\'SimSun\' font-size=\'12\' fill=\'%23c9a866\'%3E无封面%3C/text%3E%3C/svg%3E'">
                            </c:when>
                            <c:otherwise>
                                <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='80' viewBox='0 0 60 80'%3E%3Crect width='60' height='80' fill='%233d5a5a'/%3E%3Ctext x='8' y='45' font-family='SimSun' font-size='12' fill='%23c9a866'%3E无封面%3C/text%3E%3C/svg%3E"
                                     alt="默认封面"
                                     class="book-cover-img">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${book.id}</td>
                    <td>${book.bookTitle}</td>
                    <td>${book.bookAuthor}</td>
                    <td>
                        <c:choose>
                            <c:when test="${book.typeId == 1}">玄幻修真</c:when>
                            <c:when test="${book.typeId == 2}">科幻科技</c:when>
                            <c:when test="${book.typeId == 3}">历史武侠</c:when>
                            <c:when test="${book.typeId == 4}">经典文学</c:when>
                            <c:otherwise>未分类</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${book.bookPubYear}</td>
                    <td>${book.downloadTimes}</td>
                    <td>${book.bookFormat}</td>
                    <td>${book.price}</td>
                    <td>
                        <div class="action-group">
                            <button class="magic-btn btn-sm" onclick="openEditModal(this.closest('tr'))">编辑</button>
                            <a href="${pageContext.request.contextPath}/chapterAdd?bookId=${book.id}" class="magic-btn btn-sm">录章节</a>
                            <a href="tushuguan?targetBookId=${book.id}" class="magic-btn btn-sm btn-success">预览</a>
                            <a href="bookDelete?id=${book.id}" class="magic-btn btn-sm btn-danger" onclick="return confirm('确定要销毁这部典籍吗？此操作不可恢复！')">销毁</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookList}">
                <tr>
                    <td colspan="10" class="table-empty">藏经阁暂无典籍，快去录入新典籍吧</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- 新增典籍弹窗 -->
<div class="form-modal" id="addFormModal">
    <div class="form-card">
        <h3>录入新典籍</h3>
        <form action="bookAdd" method="post">
            <div class="form-row"><label>典籍名称</label><input type="text" name="bookTitle" required></div>
            <div class="form-row"><label>典籍作者</label><input type="text" name="bookAuthor" required></div>
            <div class="form-row"><label>典籍简介</label><textarea name="bookSummary" required></textarea></div>
            <div class="form-row">
                <label>典籍分类</label>
                <select name="typeId" required>
                    <option value="1">玄幻修真</option><option value="2">科幻科技</option>
                    <option value="3">历史武侠</option><option value="4">经典文学</option>
                </select>
            </div>
            <div class="form-row"><label>典籍价格(灵石)</label><input type="number" name="price" step="0.01" value="0.00" required></div>
            <div class="form-row"><label>传阅次数</label><input type="number" name="downloadTimes" value="0" required></div>
            <div class="form-row"><label>出版年份</label><input type="date" name="bookPubYear" required></div>
            <div class="form-row"><label>典籍文件路径</label><input type="text" name="bookFile" value="/files/default.pdf"></div>
            <div class="form-row"><label>典籍封面路径</label><input type="text" name="bookCover" value="/cover/default.jpg"></div>
            <div class="form-row">
                <label>典籍格式</label>
                <select name="bookFormat" required>
                    <option value="pdf">PDF</option><option value="epub">EPUB</option><option value="txt">TXT</option>
                </select>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn">录入典籍</button>
                <button type="button" class="magic-btn" onclick="closeAddForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<!-- 编辑典籍弹窗 -->
<div class="form-modal" id="editFormModal">
    <div class="form-card">
        <h3>编辑典籍信息</h3>
        <form id="editForm" method="post" action="bookUpdate">
            <input type="hidden" name="id" id="edit-book-id">
            <div class="form-row"><label>典籍名称</label><input type="text" name="bookTitle" id="edit-book-title" required></div>
            <div class="form-row"><label>典籍作者</label><input type="text" name="bookAuthor" id="edit-book-author" required></div>
            <div class="form-row"><label>典籍简介</label><textarea name="bookSummary" id="edit-book-summary" required></textarea></div>
            <div class="form-row">
                <label>典籍分类</label>
                <select name="typeId" id="edit-book-type" required>
                    <option value="1">玄幻修真</option><option value="2">科幻科技</option>
                    <option value="3">历史武侠</option><option value="4">经典文学</option>
                </select>
            </div>
            <div class="form-row"><label>典籍价格(灵石)</label><input type="number" name="price" id="edit-book-price" step="0.01" required></div>
            <div class="form-row"><label>传阅次数</label><input type="number" name="downloadTimes" id="edit-book-times" required></div>
            <div class="form-row"><label>出版年份</label><input type="date" name="bookPubYear" id="edit-book-pubyear" required></div>
            <div class="form-row"><label>典籍文件路径</label><input type="text" name="bookFile" id="edit-book-file"></div>
            <div class="form-row"><label>典籍封面路径</label><input type="text" name="bookCover" id="edit-book-cover"></div>
            <div class="form-row">
                <label>典籍格式</label>
                <select name="bookFormat" id="edit-book-format" required>
                    <option value="pdf">PDF</option><option value="epub">EPUB</option><option value="txt">TXT</option>
                </select>
            </div>
            <div class="form-btn-group">
                <button type="submit" class="magic-btn">保存修改</button>
                <button type="button" class="magic-btn" onclick="closeEditForm()">取消</button>
            </div>
        </form>
    </div>
</div>

<script>
    // ================== 全局变量 ==================
    var addFormModal = document.getElementById('addFormModal');
    var editFormModal = document.getElementById('editFormModal');
    var searchInput = document.getElementById('searchInput');
    var typeFilter = document.getElementById('typeFilter');
    var bookTableBody = document.getElementById('bookTableBody');
    var allBookRows = bookTableBody.querySelectorAll('tr:not(:has(.table-empty))'); // 缓存所有典籍行

    // ================== 【核心优化】实时筛选函数 ==================
    function filterBookList() {
        var keyword = searchInput.value.toLowerCase().trim();
        var selectedTypeId = typeFilter.value;
        var hasMatch = false;

        // 遍历所有典籍行，执行筛选
        allBookRows.forEach(function(row) {
            var dataset = row.dataset;
            // 关键词匹配：书名/作者
            var isKeywordMatch = dataset.title.toLowerCase().includes(keyword) || dataset.author.toLowerCase().includes(keyword);
            // 分类匹配
            var isTypeMatch = selectedTypeId === '' || dataset.typeId === selectedTypeId;

            // 同时满足才显示
            var isShow = isKeywordMatch && isTypeMatch;
            row.style.display = isShow ? '' : 'none';
            if (isShow) hasMatch = true;
        });

        // 无匹配时显示空提示
        var emptyRow = bookTableBody.querySelector('tr:has(.table-empty)');
        if (emptyRow) {
            emptyRow.style.display = hasMatch ? 'none' : '';
        }
    }

    // ================== 新增弹窗控制 ==================
    function openAddForm() { addFormModal.style.display = 'flex'; }
    function closeAddForm() { addFormModal.style.display = 'none'; }
    addFormModal.onclick = function(e) { if (e.target === this) closeAddForm(); };

    // ================== 编辑弹窗控制（全字段回显） ==================
    function openEditModal(tr) {
        var dataset = tr.dataset;
        document.getElementById('edit-book-id').value = dataset.bookId;
        document.getElementById('edit-book-title').value = dataset.title;
        document.getElementById('edit-book-author').value = dataset.author;
        document.getElementById('edit-book-summary').value = dataset.summary;
        document.getElementById('edit-book-type').value = dataset.typeId;
        document.getElementById('edit-book-price').value = dataset.price;
        document.getElementById('edit-book-times').value = dataset.times;
        document.getElementById('edit-book-pubyear').value = dataset.pubyear;
        document.getElementById('edit-book-file').value = dataset.file;
        document.getElementById('edit-book-cover').value = dataset.cover;
        document.getElementById('edit-book-format').value = dataset.format;
        editFormModal.style.display = 'flex';
    }
    function closeEditForm() { editFormModal.style.display = 'none'; }
    editFormModal.onclick = function(e) { if (e.target === this) closeEditForm(); };

    // ================== 后端搜索+排序（保留原有逻辑） ==================
    function searchBook() {
        var keyword = searchInput.value.toLowerCase().trim();
        var selectedTypeId = typeFilter.value;
        var sortField = document.getElementById('sortField').value;
        var sortOrder = document.getElementById('sortOrder').value;

        // 拼接参数，跳转Servlet重新查询
        var url = "${pageContext.request.contextPath}/bookManage?keyword=" + encodeURIComponent(keyword)
            + "&typeId=" + encodeURIComponent(selectedTypeId)
            + "&sortField=" + encodeURIComponent(sortField)
            + "&sortOrder=" + encodeURIComponent(sortOrder);

        // 跳转刷新，保留搜索和排序状态
        window.location.href = url;
    }

    // 重置搜索和排序
    function resetSearch() {
        searchInput.value = '';
        typeFilter.value = '';
        // 重置排序为默认降序
        document.getElementById('sortField').value = 'id';
        document.getElementById('sortOrder').value = 'desc';
        document.getElementById('sortArrow').innerText = '↓';
        // 重置后刷新页面
        window.location.href = "${pageContext.request.contextPath}/bookManage";
    }

    // ================== 【核心优化】事件绑定 ==================
    // 1. 分类切换立刻筛选
    typeFilter.addEventListener('change', filterBookList);
    // 2. 关键词输入实时筛选
    searchInput.addEventListener('input', filterBookList);
    // 3. 回车依然触发后端搜索
    searchInput.addEventListener('keydown', function(e) { if (e.keyCode === 13) searchBook(); });

    // ================== 键盘事件 ==================
    document.onkeydown = function(e) {
        e = e || window.event;
        if (e.keyCode === 27) { closeAddForm(); closeEditForm(); }
    };

    // ================== 符文特效 ==================
    var runeLibrary = ['临','兵','斗','者','皆','列','阵','在','前'];
    document.addEventListener('click', function(e) {
        if (e.target.closest('.nav-sidebar .nav-item')) return;
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

    // 切换ID升序/降序
    function switchSort() {
        var sortOrderInput = document.getElementById('sortOrder');
        var sortArrow = document.getElementById('sortArrow');

        // 切换排序方向
        if (sortOrderInput.value === 'desc') {
            sortOrderInput.value = 'asc';
            sortArrow.innerText = '↑';
        } else {
            sortOrderInput.value = 'desc';
            sortArrow.innerText = '↓';
        }

        // 重新执行搜索，带上排序参数
        searchBook();
    }

    // 页面加载完成后执行
    window.onload = function() {
        // 同步排序箭头状态
        var urlParams = new URLSearchParams(window.location.search);
        var sortOrder = urlParams.get('sortOrder');
        if (sortOrder === 'asc') {
            document.getElementById('sortOrder').value = 'asc';
            document.getElementById('sortArrow').innerText = '↑';
        } else {
            document.getElementById('sortOrder').value = 'desc';
            document.getElementById('sortArrow').innerText = '↓';
        }

        // 重新缓存典籍行，避免新增/编辑后数据不对
        allBookRows = bookTableBody.querySelectorAll('tr:not(:has(.table-empty))');
        // 页面加载后自动执行一次筛选，保证url参数和页面状态一致
        filterBookList();
    }
</script>
</body>
</html>