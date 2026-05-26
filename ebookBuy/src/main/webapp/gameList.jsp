<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>声临其境 · 阅读篇</title>
    <style>
        /* 同上，保持原有样式不变 */
        * { margin:0; padding:0; box-sizing:border-box; }
        :root {
            --bg-deepest: #0a1a20; --bg-dark: #0f252b; --bg-mid: #1a3a3f; --bg-light: #173036;
            --gold-dark: #a88a44; --gold-mid: #c9a866; --gold-light: #e6c888;
            --text-primary: #f0e2c0; --text-secondary: #d4c7b0; --text-tertiary: #b8a990;
        }
        body {
            font-family: "SimSun","Times New Roman",serif;
            background: radial-gradient(ellipse at 30% 20%, rgba(26,58,63,0.8) 0%, transparent 50%),
            linear-gradient(135deg, var(--bg-deepest) 0%, var(--bg-mid) 50%, var(--bg-dark) 100%);
            color: var(--text-secondary); margin:0; padding:20px;
        }
        .container { max-width: 800px; margin:0 auto; }
        .page-title {
            font-size:42px; text-align:center; color:var(--text-primary); margin:20px 0 10px;
            letter-spacing:8px; text-shadow:0 0 20px var(--gold-mid);
        }
        .sub-title { text-align:center; color:var(--gold-mid); margin-bottom:30px; font-size:18px; }
        .game-table { width:100%; border-collapse:collapse; background:rgba(23,48,54,0.9); border:1px solid var(--gold-dark); border-radius:8px; overflow:hidden; }
        .game-table th, .game-table td { padding:15px; border-bottom:1px solid rgba(201,168,102,0.2); text-align:left; }
        .game-table th { background:#173036; color:var(--gold-light); font-size:18px; letter-spacing:2px; }
        .game-table tr:hover { background:rgba(201,168,102,0.1); }
        .cover-img { width:60px; height:80px; object-fit:cover; border-radius:4px; border:1px solid var(--gold-dark); }
        .book-title { font-size:20px; color:var(--text-primary); letter-spacing:1px; }
        .book-author { font-size:14px; color:var(--text-secondary); }
        .book-meta { font-size:13px; color:var(--text-tertiary); margin-top:4px; }
        .actions { display:flex; gap:10px; }
        .btn {
            padding:8px 15px; background:linear-gradient(90deg, #173036, #244a52); color:var(--text-primary);
            border:1px solid var(--gold-dark); border-radius:5px; text-decoration:none; font-size:14px;
            cursor:pointer; font-family:"SimSun",serif; transition:all 0.3s ease; white-space:nowrap;
        }
        .btn:hover { background:linear-gradient(90deg, var(--gold-mid), var(--gold-light)); color:var(--bg-deepest); font-weight:bold; }
        .btn-manage { background:#4a4a6a; border-color:#8a8ab8; }
        .btn-play { background:#2a4a1a; border-color:#8ab88a; }
        .empty-msg { text-align:center; padding:60px 20px; color:var(--text-tertiary); font-size:18px; }
        .empty-msg a { color:var(--gold-mid); text-decoration:none; }
        .empty-msg a:hover { text-shadow:0 0 10px; }
        .back-link { display:block; text-align:center; margin-top:30px; color:var(--gold-mid); text-decoration:none; font-size:16px; }
        .back-link:hover { text-shadow:0 0 10px; }
    </style>
</head>
<body>
<div class="container">
    <h1 class="page-title">📖 声临其境 · 阅读篇</h1>
    <p class="sub-title">化身书中主角，扭转命运乾坤</p>

    <c:choose>
        <c:when test="${empty gameBooks}">
            <div class="empty-msg">
                <p>暂无可用的游戏典籍</p>
                <p>您可以先到 <a href="${pageContext.request.contextPath}/bookManage">典籍总录</a> 为喜欢的书籍编写剧情。</p>
            </div>
        </c:when>
        <c:otherwise>
            <table class="game-table">
                <thead>
                <tr>
                    <th style="width:100px;">封面</th>
                    <th>典籍名称</th>
                    <th style="width:100px;">进度</th>
                    <th style="width:180px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${gameBooks}" var="book">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${not empty book.bookCover}">
                                    <img src="${pageContext.request.contextPath}${book.bookCover}" alt="${book.bookTitle}" class="cover-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='80' viewBox='0 0 60 80'%3E%3Crect width='60' height='80' fill='%233d5a5a'/%3E%3Ctext x='8' y='45' font-family='SimSun' font-size='12' fill='%23c9a866'%3E无封面%3C/text%3E%3C/svg%3E"
                                         alt="默认封面" class="cover-img">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="book-title">${book.bookTitle}</div>
                            <c:if test="${not empty book.bookAuthor}">
                                <div class="book-author">作者：${book.bookAuthor}</div>
                            </c:if>
                            <!-- 新增节点数和简介 -->
                            <div class="book-meta">
                                📄 ${book.nodeCount} 个剧情节点
                                <c:if test="${not empty book.brief}">
                                    <br>📝 ${book.brief}
                                </c:if>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${book.status eq '已通关'}">
                                    <span style="color:#8ab88a; font-weight:bold;">✅ 已通关</span>
                                </c:when>
                                <c:when test="${book.status eq '进行中'}">
                                    <span style="color:#e6c888;">📖 进行中</span>
                                </c:when>
                                <c:when test="${book.status eq '未开始'}">
                                    <span style="color:#b8a990;">⭐ 未开始</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#a86666;">🔒 ${book.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/gameManage?bookId=${book.id}" class="btn btn-manage">📝 管理剧情</a>
                                <a href="${pageContext.request.contextPath}/game?bookId=${book.id}" class="btn btn-play">🎮 ${book.status eq '进行中' ? '继续' : '开始'}游玩</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <a href="tushuguan" class="back-link">返回全本藏书</a>
</div>
</body>
</html>