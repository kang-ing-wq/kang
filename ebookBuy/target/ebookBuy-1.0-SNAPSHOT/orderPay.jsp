<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>香火供奉 - Online藏书阁</title>
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
            padding: 50px;
        }
        .pay-container {
            max-width: 800px;
            margin: 0 auto;
            background-color: #132e32;
            border: 2px solid #c9a961;
            border-radius: 8px;
            padding: 40px;
        }
        .page-title {
            text-align: center;
            font-size: 42px;
            color: #e6d5b8;
            margin-bottom: 30px;
            text-shadow: 0 0 10px rgba(201, 169, 97, 0.5);
        }
        .order-info {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #33555a;
        }
        .order-info p {
            font-size: 20px;
            line-height: 2;
        }
        .order-id {
            color: #c9a961;
        }
        /* 明细列表 */
        .item-list {
            margin-bottom: 40px;
        }
        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            font-size: 18px;
            border-bottom: 1px dashed #33555a;
        }
        .book-name {
            flex: 1;
        }
        .item-subtotal {
            color: #c9a961;
        }
        /* 总金额 */
        .total-box {
            text-align: right;
            font-size: 26px;
            color: #c9a961;
            margin-bottom: 40px;
            font-weight: bold;
        }
        /* 按钮组 */
        .btn-group {
            display: flex;
            justify-content: center;
            gap: 30px;
        }
        .btn {
            padding: 15px 50px;
            font-size: 24px;
            font-family: "KaiTi", "STKaiti", serif;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
        }
        .btn-pay {
            background-color: #c9a961;
            color: #0f2629;
            border: none;
        }
        .btn-pay:hover {
            background-color: #e6c06e;
            box-shadow: 0 0 15px rgba(201, 169, 97, 0.6);
        }
        .btn-back {
            background-color: transparent;
            color: #e6d5b8;
            border: 1px solid #c9a961;
        }
        .btn-back:hover {
            background-color: #1a3f45;
        }
        .msg-box {
            text-align: center;
            padding: 15px;
            background-color: #1a3f45;
            border: 1px solid #c96161;
            border-radius: 4px;
            margin-bottom: 20px;
            font-size: 18px;
            color: #e69090;
        }
    </style>
</head>
<body>
<div class="pay-container">
    <h1 class="page-title">香火供奉</h1>

    <c:if test="${not empty msg}">
        <div class="msg-box">${msg}</div>
    </c:if>

    <c:if test="${empty order}">
        <div style="text-align: center; padding: 50px 0;">
            <p style="font-size: 22px; margin-bottom: 30px;">道契不存在，请返回重试</p>
            <a href="${pageContext.request.contextPath}/orderList" class="btn btn-back">返回道契中心</a>
        </div>
    </c:if>

    <c:if test="${not empty order}">
        <!-- 订单信息 -->
        <div class="order-info">
            <p>道契编号：<span class="order-id">${order.id}</span></p>
            <p>缔结时间：${order.createTime}</p>
        </div>

        <!-- 典籍明细 -->
        <div class="item-list">
            <c:forEach items="${order.itemList}" var="item">
                <div class="item-row">
                    <span class="book-name">《${item.bookName}》 × ${item.buyNum}</span>
                    <span class="item-subtotal">${item.subTotal} 灵石</span>
                </div>
            </c:forEach>
        </div>

        <!-- 总金额 -->
        <div class="total-box">
            合计需供奉：${order.totalAmount} 灵石
        </div>

        <!-- 按钮组 -->
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/orderList" class="btn btn-back">返回</a>
            <form action="${pageContext.request.contextPath}/orderPay" method="post" style="display: inline;">
                <input type="hidden" name="orderId" value="${order.id}">
                <button type="submit" class="btn btn-pay" onclick="return confirm('确定要供奉香火，缔结此道契吗？')">确认供奉</button>
            </form>
        </div>
    </c:if>
</div>
</body>
</html>