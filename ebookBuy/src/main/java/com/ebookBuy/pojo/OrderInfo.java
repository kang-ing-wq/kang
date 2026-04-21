package com.ebookBuy.pojo;

import java.sql.Timestamp;

public class OrderInfo {
    private String id;
    private String userId;
    private Double totalAmount;
    private Integer orderStatus;
    private Timestamp payTime;
    private Timestamp createTime;
    private Timestamp cancelTime;
    private String remark;

    // 扩展：订单明细列表（查询时封装）
    private java.util.List<OrderItem> itemList;

    // 无参构造
    public OrderInfo() {}

    // 全参构造
    public OrderInfo(String id, String userId, Double totalAmount, Integer orderStatus, Timestamp payTime, Timestamp createTime, Timestamp cancelTime, String remark) {
        this.id = id;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.orderStatus = orderStatus;
        this.payTime = payTime;
        this.createTime = createTime;
        this.cancelTime = cancelTime;
        this.remark = remark;
    }

    // getter和setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Integer getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(Integer orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Timestamp getPayTime() {
        return payTime;
    }

    public void setPayTime(Timestamp payTime) {
        this.payTime = payTime;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Timestamp getCancelTime() {
        return cancelTime;
    }

    public void setCancelTime(Timestamp cancelTime) {
        this.cancelTime = cancelTime;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public java.util.List<OrderItem> getItemList() {
        return itemList;
    }

    public void setItemList(java.util.List<OrderItem> itemList) {
        this.itemList = itemList;
    }

    // 辅助方法：获取订单状态的修仙风中文描述
    public String getStatusText() {
        if (orderStatus == null) return "未知状态";
        switch (orderStatus) {
            case 0: return "待结香火";
            case 1: return "待解锁";
            case 2: return "已入藏经";
            case 3: return "道契作废";
            default: return "未知状态";
        }
    }

    // 辅助方法：判断订单是否可支付
    public boolean isCanPay() {
        return orderStatus != null && orderStatus == 0;
    }

    // 辅助方法：判断订单是否可取消
    public boolean isCanCancel() {
        return orderStatus != null && orderStatus == 0;
    }
}