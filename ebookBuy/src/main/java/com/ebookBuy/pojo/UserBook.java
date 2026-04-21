package com.ebookBuy.pojo;

import java.sql.Timestamp;

public class UserBook {
    private String id;
    private String userId;
    private Integer bookId;
    private String orderId;
    private Timestamp buyTime;
    private Timestamp lastReadTime;
    private Integer lastReadChapter;

    // 扩展：书籍信息
    private Book book;

    // 无参构造
    public UserBook() {}

    // 全参构造
    public UserBook(String id, String userId, Integer bookId, String orderId, Timestamp buyTime, Timestamp lastReadTime, Integer lastReadChapter) {
        this.id = id;
        this.userId = userId;
        this.bookId = bookId;
        this.orderId = orderId;
        this.buyTime = buyTime;
        this.lastReadTime = lastReadTime;
        this.lastReadChapter = lastReadChapter;
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

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Timestamp getBuyTime() {
        return buyTime;
    }

    public void setBuyTime(Timestamp buyTime) {
        this.buyTime = buyTime;
    }

    public Timestamp getLastReadTime() {
        return lastReadTime;
    }

    public void setLastReadTime(Timestamp lastReadTime) {
        this.lastReadTime = lastReadTime;
    }

    public Integer getLastReadChapter() {
        return lastReadChapter;
    }

    public void setLastReadChapter(Integer lastReadChapter) {
        this.lastReadChapter = lastReadChapter;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }
}