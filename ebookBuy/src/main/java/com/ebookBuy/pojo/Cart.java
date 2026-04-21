package com.ebookBuy.pojo;

import java.sql.Timestamp;

public class Cart {
    private String id;
    private String userId;
    private Integer bookId;
    private Integer buyNum;
    private Timestamp createTime;
    private Timestamp updateTime;

    // 额外扩展：购物车展示需要的书籍信息（不用存数据库，查询时封装）
    private Book book;

    // 无参构造
    public Cart() {}

    // 全参构造
    public Cart(String id, String userId, Integer bookId, Integer buyNum, Timestamp createTime, Timestamp updateTime) {
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

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
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
}