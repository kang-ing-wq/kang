package com.ebookBuy.pojo;

import java.sql.Timestamp;

public class Cart {
    private String id;
    private String userId;
    private Long bookId;
    private Integer buyNum;
    private Timestamp createTime;
    private Timestamp updateTime;
    private Integer selected = 1;// 是否选中：1=选中，0=未选中
    private boolean stockWarn; // 库存不足预警标记（前端展示用）
    private boolean bookOffline; // 典籍下架标记（前端展示用）
    // 额外扩展：购物车展示需要的书籍信息（不用存数据库，查询时封装）
    private Book book;

    // 无参构造
    public Cart() {}

    // 全参构造
    public Cart(String id, String userId, Long bookId, Integer buyNum, Timestamp createTime, Timestamp updateTime) {
        this.id = id;
        this.userId = userId;
        this.bookId = bookId;
        this.buyNum = buyNum;
        this.createTime = createTime;
        this.updateTime = updateTime;
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

    public Long getBookId() {
        return (long) Math.toIntExact(bookId);
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Integer getBuyNum() {
        return buyNum;
    }

    public void setBuyNum(Integer buyNum) {
        this.buyNum = buyNum;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    // 对应的Getter和Setter
    public Integer getSelected() {
        return selected;
    }

    public void setSelected(Integer selected) {
        this.selected = selected;
    }

    public boolean isStockWarn() {
        return stockWarn;
    }

    public void setStockWarn(boolean stockWarn) {
        this.stockWarn = stockWarn;
    }

    public boolean isBookOffline() {
        return bookOffline;
    }

    public void setBookOffline(boolean bookOffline) {
        this.bookOffline = bookOffline;
    }
}