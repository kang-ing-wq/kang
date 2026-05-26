<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>道契详情 - Online藏书阁</title>
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
        /* 左侧导航栏，和订单列表页保持一致 */
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
        /* 订单卡片 */
        .detail-card {
            background-color: #132e32;
            border: 1px solid #33555a;
            border-radius: 8px;
            padding: 30px;
            max-width: 1000px;
            margin: 0 auto;
        }
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #33555a;
        }
        .order-id {
            font-size: 20px;
            color: #c9a961;
        }
        .order-status {
            font-size: 20px;
            font-weight: bold;
        }
        .status-wait { color: #e6c06e; }
        .status-unlock { color: #6eb8e6; }
        .status-done { color: #6bc17f; }
        .status-cancel { color: #999; }
        /* 订单信息 */
        .info-group {
            margin-bottom: 25px;
        }
        .info-label {
            font-size: 18px;
            color: #b8a990;
            margin-bottom: 10px;
        }
        .info-value {
            font-size: 20px;
            color: #e6d5b8;
        }
        /* 订单明细 */
        .item-list {
            margin: 30px 0;
            border-top: 1px solid #33555a;
            border-bottom: 1px solid #33555a;
            padding: 20px 0;
        }
        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            font-size: 18px;
            border-bottom: 1px solid rgba(51, 85, 90, 0.5);
        }
        .item-row:last-child {
            border-bottom: none;
        }
        .book-name {
            flex: 1;
        }
        .item-price, .item-num, .item-subtotal {
            width: 120px;
            text-align: center;
        }
        .item-subtotal {
            color: #c9a961;
        }
        /* 底部 */
        .footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 30px;
        }
        .total-amount {
            font-size: 24px;
            color: #c9a961;
            font-weight: bold;
        }
        .btn-group {
            display: flex;
            gap: 15px;
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
    </style>
</head>
<body>
<div class="container">
    <!-- 左侧导航栏 -->
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
        <a href="${pageContext.request.contextPath}/orderList" class="menu-item">
            <span>←</span> 返回道契中心
        </a>
    </div>

    <!-- 右侧主内容区 -->
    <div class="main-content">
        <h1 class="page-title">道契详情</h1>

        <div class="detail-card">
            <!-- 订单头部 -->
            <div class="detail-header">
                <span class="order-id">道契编号：${order.id}</span>
                <span class="order-status
                    ${order.orderStatus == 0 ? 'status-wait' : ''}
                    ${order.orderStatus == 1 ? 'status-unlock' : ''}
                    ${order.orderStatus == 2 ? 'status-done' : ''}
                    ${order.orderStatus == 3 ? 'status-cancel' : ''}
                ">${order.statusText}</span>
            </div>

            <!-- 订单基础信息 -->
            <div class="info-group">
                <div class="info-label">创建时间</div>
                <div class="info-value">${order.createTime}</div>
            </div>
            <div class="info-group">
                <div class="info-label">支付时间</div>
                <div class="info-value">${order.payTime != null ? order.payTime : '暂未支付'}</div>
            </div>

            <!-- 订单明细 -->
            <div class="item-list">
                <div class="item-row" style="font-weight: bold; color: #c9a961;">
                    <div class="book-name">典籍名称</div>
                    <div class="item-price">单价</div>
                    <div class="item-num">数量</div>
                    <div class="item-subtotal">小计</div>
                </div>
                <c:forEach items="${order.itemList}" var="item">
                    <div class="item-row">
                        <div class="book-name">《${item.bookName}》</div>
                        <div class="item-price">${item.price} 灵石</div>
                        <div class="item-num">× ${item.buyNum}</div>
                        <div class="item-subtotal">${item.subTotal} 灵石</div>
                    </div>
                </c:forEach>
            </div>

            <!-- 底部 -->
            <div class="footer">
                <div class="total-amount">总香火：${order.totalAmount} 灵石</div>
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/orderList" class="btn">返回道契中心</a>
                    <c:if test="${order.orderStatus == 2}">
                        <a href="${pageContext.request.contextPath}/tushuguan" class="btn">前往藏书阁</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>