<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单结算 - 玄元宗藏经阁</title>
    <style>
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
            min-height: 100vh;
        }
        /* 左侧导航栏（与主页面统一） */
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
        /* 右侧主内容区 */
        .content-wrap {
            margin-left: 280px;
            min-height: 100vh;
            padding: 50px 60px;
        }
        .page-title {
            font-size: 48px;
            text-align: center;
            color: var(--text-primary);
            margin-bottom: 50px;
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
        .tab-group {
            display: flex;
            gap: 20px;
            margin-bottom: 40px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
            padding-bottom: 10px;
        }
        .tab-item {
            padding: 10px 30px;
            font-size: 20px;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
            letter-spacing: 2px;
        }
        .tab-item.active, .tab-item:hover {
            color: var(--gold-light);
            border-bottom: 3px solid var(--gold-mid);
            text-shadow: 0 0 10px var(--gold-mid);
        }
        /* 结算卡片 */
        .settle-card {
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.9) 0%, rgba(13, 31, 36, 0.94) 100%);
            border: 2px solid var(--gold-dark);
            border-radius: 10px;
            padding: 40px;
            margin-bottom: 40px;
            box-shadow: inset 0 0 20px rgba(0,0,0,0.35), 0 6px 18px rgba(0,0,0,0.5);
        }
        .settle-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.3);
        }
        .settle-title {
            font-size: 28px;
            color: var(--text-primary);
            letter-spacing: 3px;
        }
        .order-no {
            font-size: 16px;
            color: var(--text-tertiary);
        }
        /* 订单商品列表 */
        .order-book-list {
            margin-bottom: 30px;
        }
        .order-book-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
            border-bottom: 1px solid rgba(201, 168, 102, 0.2);
        }
        .book-info {
            flex: 1;
        }
        .book-info h4 {
            font-size: 22px;
            color: var(--text-primary);
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .book-info p {
            font-size: 16px;
            color: var(--text-secondary);
        }
        .book-price-info {
            text-align: right;
        }
        .book-price {
            font-size: 20px;
            color: var(--gold-light);
            font-weight: bold;
            margin-bottom: 5px;
        }
        .book-num {
            font-size: 16px;
            color: var(--text-tertiary);
        }
        /* 金额汇总 */
        .amount-summary {
            padding: 20px 0;
            border-top: 2px solid rgba(201, 168, 102, 0.3);
            margin-bottom: 30px;
        }
        .amount-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 18px;
        }
        .amount-row.total {
            font-size: 24px;
            font-weight: bold;
            color: var(--gold-light);
            padding-top: 15px;
            border-top: 1px solid rgba(201, 168, 102, 0.2);
        }
        /* 按钮组 */
        .btn-group {
            display: flex;
            gap: 20px;
            justify-content: flex-end;
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
        .btn-danger {
            background: linear-gradient(90deg, #5a1a1a, #7a2a2a);
            border-color: #a83232;
        }
        .btn-danger:hover {
            background: linear-gradient(90deg, #a83232, #c84242);
            color: #fff;
            box-shadow: 0 0 20px rgba(168, 50, 50, 0.6);
        }
        .btn-success {
            background: linear-gradient(90deg, #2a5a3a, #3a7a4a);
            border-color: var(--green);
        }
        .btn-success:hover {
            background: linear-gradient(90deg, var(--green), #8ab89a);
            color: #fff;
            box-shadow: 0 0 20px rgba(122, 168, 138, 0.6);
        }
        /* 订单列表 */
        .order-list-card {
            background: linear-gradient(180deg, rgba(23, 48, 54, 0.9) 0%, rgba(13, 31, 36, 0.94) 100%);
            border: 2px solid var(--gold-dark);
            border-radius: 10px;
            box-shadow: inset 0 0 20px rgba(0,0,0,0.35), 0 6px 18px rgba(0,0,0,0.5);
        }
        .order-list-header {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 1fr;
            padding: 20px 30px;
            border-bottom: 2px solid rgba(201, 168, 102, 0.3);
            font-size: 18px;
            color: var(--text-primary);
            font-weight: bold;
            letter-spacing: 1px;
        }
        .order-list-item {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 1fr;
            padding: 25px 30px;
            border-bottom: 1px solid rgba(201, 168, 102, 0.2);
            align-items: center;
            transition: all 0.3s ease;
        }
        .order-list-item:hover {
            background: rgba(201, 168, 102, 0.05);
        }
        .order-book-title {
            font-size: 18px;
            color: var(--text-primary);
            margin-bottom: 5px;
        }
        .order-book-author {
            font-size: 14px;
            color: var(--text-tertiary);
        }
        .order-status {
            font-weight: bold;
        }
        .status-unpay {
            color: var(--red);
        }
        .status-pay {
            color: var(--green);
        }
        .order-amount {
            color: var(--gold-light);
            font-weight: bold;
            font-size: 18px;
        }
        .order-empty {
            text-align: center;
            padding: 80px 0;
            font-size: 20px;
            color: var(--text-tertiary);
            line-height: 2;
        }
        /* 滚动条样式 */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: var(--bg-deepest);
        }
        ::-webkit-scrollbar-thumb {
            background: var(--gold-dark);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: var(--gold-mid);
        }
    </style>
</head>
<body>
<!-- 左侧导航栏 -->
<div class="nav-sidebar">
    <div class="logo">📜 Online藏书阁</div>
    <a href="zongmen.jsp" class="nav-item">🏠 图书管理首页</a>
    <a href="tushuguan.jsp" class="nav-item">📚 全本藏书</a>
    <a href="order.jsp" class="nav-item active">🧾 我的订单</a>
    <a href="usersList.jsp" class="nav-item">👥 人员名录</a>
    <a href="tushuguan.jsp" class="nav-item">⬅️ 返回藏书阁</a>
</div>

<!-- 右侧主内容区 -->
<div class="content-wrap">
    <h1 class="page-title">仙缘订单</h1>

    <!-- 标签切换 -->
    <div class="tab-group">
        <div class="tab-item active" data-tab="settle">待结算</div>
        <div class="tab-item" data-tab="all">全部订单</div>
    </div>

    <!-- 待结算面板 -->
    <div class="tab-content" id="settleTab">
        <c:choose>
            <c:when test="${not empty settleCartList}">
                <div class="settle-card">
                    <div class="settle-header">
                        <h3 class="settle-title">订单结算</h3>
                        <p class="order-no">订单编号：${orderNo}</p>
                    </div>

                    <!-- 商品列表 -->
                    <div class="order-book-list">
                        <c:forEach items="${settleCartList}" var="item">
                            <div class="order-book-item">
                                <div class="book-info">
                                    <h4>${item.book.bookTitle}</h4>
                                    <p>作者：${item.book.bookAuthor} | 典籍格式：${item.book.bookFormat}</p>
                                </div>
                                <div class="book-price-info">
                                    <p class="book-price"><fmt:formatNumber value="${item.book.price}" pattern="0.00"/> 灵石</p>
                                    <p class="book-num">x ${item.buyNum} 本</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- 金额汇总 -->
                    <div class="amount-summary">
                        <div class="amount-row">
                            <span>商品总价</span>
                            <span><fmt:formatNumber value="${totalAmount}" pattern="0.00"/> 灵石</span>
                        </div>
                        <div class="amount-row">
                            <span>宗门手续费</span>
                            <span>0.00 灵石</span>
                        </div>
                        <div class="amount-row total">
                            <span>实付金额</span>
                            <span><fmt:formatNumber value="${totalAmount}" pattern="0.00"/> 灵石</span>
                        </div>
                    </div>

                    <!-- 操作按钮 -->
                    <div class="btn-group">
                        <a href="tushuguan.jsp" class="magic-btn btn-danger">取消结算</a>
                        <button class="magic-btn btn-success" id="payBtn">确认支付</button>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="order-empty">
                    <p>道友暂无待结算的订单</p>
                    <p>快去藏书阁请购心仪的典籍吧</p>
                    <div class="btn-group" style="justify-content: center; margin-top: 30px;">
                        <a href="tushuguan.jsp" class="magic-btn">前往藏书阁</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 全部订单面板 -->
    <div class="tab-content" id="allTab" style="display: none;">
        <div class="order-list-card">
            <div class="order-list-header">
                <span>典籍信息</span>
                <span>订单编号</span>
                <span>支付金额</span>
                <span>订单状态</span>
                <span>创建时间</span>
            </div>

            <c:choose>
                <c:when test="${not empty orderList}">
                    <c:forEach items="${orderList}" var="order">
                        <div class="order-list-item">
                            <div>
                                <div class="order-book-title">${order.bookTitle}</div>
                                <div class="order-book-author">作者：${order.bookAuthor}</div>
                            </div>
                            <div>${order.orderNo}</div>
                            <div class="order-amount"><fmt:formatNumber value="${order.payAmount}" pattern="0.00"/> 灵石</div>
                            <div class="order-status ${order.status == 1 ? 'status-pay' : 'status-unpay'}">
                                    ${order.status == 1 ? '已支付' : '待支付'}
                            </div>
                            <div><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="order-empty">
                        <p>道友暂无历史订单</p>
                        <p>开启你的修仙藏书之旅吧</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    // 标签切换
    var tabItems = document.querySelectorAll('.tab-item');
    var tabContents = document.querySelectorAll('.tab-content');
    tabItems.forEach(function(item) {
        item.addEventListener('click', function() {
            var tab = this.dataset.tab;
            // 切换标签激活状态
            tabItems.forEach(function(i) { i.classList.remove('active'); });
            this.classList.add('active');
            // 切换内容显示
            tabContents.forEach(function(content) { content.style.display = 'none'; });
            document.getElementById(tab + 'Tab').style.display = 'block';
        });
    });

    // 支付按钮点击事件
    var payBtn = document.getElementById('payBtn');
    if (payBtn) {
        payBtn.addEventListener('click', function() {
            if (!confirm('确认支付该订单，兑换对应典籍吗？')) return;

            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/orderPay', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var res = JSON.parse(xhr.responseText);
                            alert(res.msg);
                            if (res.code === 200) {
                                window.location.reload();
                            }
                        } catch (e) {
                            alert('支付失败，请刷新页面重试');
                        }
                    } else {
                        alert('请求失败，服务器错误：' + xhr.status);
                    }
                }
            };
            xhr.send('orderNo=${orderNo}&totalAmount=${totalAmount}');
        });
    }
</script>
</body>
</html>