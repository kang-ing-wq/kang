<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>仙缘订单 - Online藏书阁</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background-color: #0f2629;
            color: #e6d5b8;
            font-family: "KaiTi", "STKaiti", serif;
            min-height: 100vh;
        }
        .container {
            display: flex;
            min-height: 100vh;
        }
        /* 左侧导航栏，和tushuguan.jsp完全一致 */
        .sidebar {
            width: 220px;
            background-color: #132e32;
            border-right: 2px solid #c9a961;
            padding: 30px 0;
        }
        .sidebar-header {
            text-align: center;
            margin-bottom: 50px;
        }
        .sidebar-header h1 {
            font-size: 32px;
            color: #e6d5b8;
            line-height: 1.2;
        }
        .menu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 30px;
            color: #e6d5b8;
            text-decoration: none;
            font-size: 20px;
            transition: all 0.3s;
        }
        .menu-item:hover, .menu-item.active {
            background-color: #1a3f45;
            border-left: 4px solid #c9a961;
        }
        /* 右侧主内容区 */
        .main-content {
            flex: 1;
            padding: 40px 60px;
        }
        .page-title {
            text-align: center;
            font-size: 48px;
            color: #e6d5b8;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 2px solid #c9a961;
            text-shadow: 0 0 10px rgba(201, 169, 97, 0.5);
        }
        /* Tab导航 */
        .tab-nav {
            display: flex;
            margin-bottom: 40px;
            border-bottom: 1px solid #33555a;
        }
        .tab-item {
            padding: 15px 40px;
            font-size: 22px;
            color: #e6d5b8;
            text-decoration: none;
            margin-right: 20px;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        .tab-item.active {
            border-bottom: 3px solid #c9a961;
            color: #c9a961;
        }
        .tab-item:hover {
            color: #c9a961;
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
            color: #b8a990;
        }
        .btn {
            display: inline-block;
            padding: 12px 35px;
            background-color: #1a3f45;
            color: #e6d5b8;
            text-decoration: none;
            border: 1px solid #c9a961;
            border-radius: 4px;
            font-size: 20px;
            transition: all 0.3s;
            font-family: "KaiTi", "STKaiti", serif;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #c9a961;
            color: #0f2629;
        }
        .btn-danger {
            background-color: #3a1a1a;
            border-color: #c96161;
        }
        .btn-danger:hover {
            background-color: #c96161;
        }
        /* 订单列表 */
        .order-list {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        .order-card {
            background-color: #132e32;
            border: 1px solid #33555a;
            border-radius: 8px;
            padding: 25px;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #33555a;
            margin-bottom: 20px;
        }
        .order-id {
            font-size: 18px;
            color: #c9a961;
        }
        .order-status {
            font-size: 18px;
            font-weight: bold;
        }
        .status-wait { color: #e6c06e; }
        .status-unlock { color: #6eb8e6; }
        .status-done { color: #6bc17f; }
        .status-cancel { color: #999; }
        /* 订单明细 */
        .order-item-list {
            margin-bottom: 20px;
        }
        .order-item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            font-size: 18px;
        }
        .book-info {
            flex: 1;
        }
        .book-name {
            font-size: 20px;
            margin-bottom: 5px;
        }
        .book-author {
            color: #b8a990;
            font-size: 16px;
        }
        .item-price {
            width: 120px;
            text-align: center;
        }
        .item-num {
            width: 80px;
            text-align: center;
        }
        .item-subtotal {
            width: 120px;
            text-align: right;
            color: #c9a961;
        }
        /* 订单底部 */
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #33555a;
        }
        .total-amount {
            font-size: 22px;
            color: #c9a961;
        }
        .btn-group {
            display: flex;
            gap: 15px;
        }
        /* 提示信息 */
        .msg-box {
            text-align: center;
            padding: 15px;
            background-color: #1a3f45;
            border: 1px solid #c9a961;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 18px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 左侧导航栏，和主页面完全一致 -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h1>Online藏书阁</h1>
        </div>
        <a href="${pageContext.request.contextPath}/tushuguan" class="menu-item">
            <span>🏠</span> 图书管理首页
        </a>
        <a href="${pageContext.request.contextPath}/tushuguan#books" class="menu-item">
            <span>📚</span> 全本藏书
        </a>
        <a href="${pageContext.request.contextPath}/orderList" class="menu-item active">
            <span>📜</span> 我的道契中心
        </a>
        <a href="${pageContext.request.contextPath}/usersList.jsp" class="menu-item">
            <span>👥</span> 人员注册名录
        </a>
        <a href="${pageContext.request.contextPath}/tushuguan" class="menu-item">
            <span>←</span> 返回藏书阁
        </a>
    </div>

    <!-- 右侧主内容区 -->
    <div class="main-content">
        <h1 class="page-title">仙缘订单</h1>

        <!-- 提示信息 -->
        <c:if test="${not empty msg}">
            <div class="msg-box">${msg}</div>
        </c:if>

        <!-- Tab导航 -->
        <div class="tab-nav">
            <a href="${pageContext.request.contextPath}/orderList?status=0" class="tab-item ${currentStatus == 0 ? 'active' : ''}">待结香火</a>
            <a href="${pageContext.request.contextPath}/orderList" class="tab-item ${currentStatus == null ? 'active' : ''}">全部道契</a>
        </div>

        <!-- 订单列表 -->
        <c:if test="${empty orderList}">
            <div class="empty-box">
                <p>道友暂无相关道契记录<br>快去藏书阁请购心仪的典籍吧</p>
                <a href="${pageContext.request.contextPath}/tushuguan" class="btn">前往藏书阁</a>
            </div>
        </c:if>

        <c:if test="${not empty orderList}">
            <div class="order-list">
                <c:forEach items="${orderList}" var="order">
                    <div class="order-card">
                        <!-- 订单头部 -->
                        <div class="order-header">
                            <span class="order-id">道契编号：${order.id}</span>
                            <span class="order-status
                                ${order.orderStatus == 0 ? 'status-wait' : ''}
                                ${order.orderStatus == 1 ? 'status-unlock' : ''}
                                ${order.orderStatus == 2 ? 'status-done' : ''}
                                ${order.orderStatus == 3 ? 'status-cancel' : ''}
                            ">${order.statusText}</span>
                        </div>

                        <!-- 订单明细 -->
                        <div class="order-item-list">
                            <c:forEach items="${order.itemList}" var="item">
                                <div class="order-item-row">
                                    <div class="book-info">
                                        <div class="book-name">《${item.bookName}》</div>
                                        <div class="book-author">作者：${item.author}</div>
                                    </div>
                                    <div class="item-price">${item.price} 灵石</div>
                                    <div class="item-num">× ${item.buyNum}</div>
                                    <div class="item-subtotal">小计：${item.subTotal} 灵石</div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 订单底部 -->
                        <div class="order-footer">
                            <div class="total-amount">总香火：${order.totalAmount} 灵石</div>
                            <div class="btn-group">
                                <!-- 1. 待支付（0）：供奉 + 作废 -->
                                <c:if test="${order.isCanPay()}">
                                    <a href="${pageContext.request.contextPath}/orderPay?orderId=${order.id}" class="btn">前往供奉</a>
                                    <a href="${pageContext.request.contextPath}/orderCancel?orderId=${order.id}" class="btn btn-danger" onclick="return confirm('确定要作废此道契吗？')">作废道契</a>
                                </c:if>

                                <!-- 2. 待解锁（1）：收入藏经（核心新增！） -->
                                <c:if test="${order.orderStatus == 1}">
                                    <a href="${pageContext.request.contextPath}/orderFinish?orderId=${order.id}" class="btn" onclick="return confirm('确定将此典籍收入藏经阁，永久解锁吗？')">收入藏经</a>
                                </c:if>

                                <!-- 3. 已入藏经（2）：再次阅读 -->
                                <c:if test="${order.orderStatus == 2}">
                                    <a href="${pageContext.request.contextPath}/tushuguan" class="btn">再次阅读</a>
                                </c:if>

                                <!-- 4. 已作废（3）：再次请购 -->
                                <c:if test="${order.orderStatus == 3}">
                                    <a href="${pageContext.request.contextPath}/tushuguan" class="btn">再次请购</a>
                                </c:if>
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>