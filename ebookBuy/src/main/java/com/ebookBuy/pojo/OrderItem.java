package com.ebookBuy.pojo;

public class OrderItem {
    private String id;
    private String orderId;
    private Integer bookId;
    private String bookName;
    private String author;
    private Double price;
    private Integer buyNum;
    private Double subTotal;

    // 无参构造
    public OrderItem() {}

    // 全参构造
    public OrderItem(String id, String orderId, Integer bookId, String bookName, String author, Double price, Integer buyNum, Double subTotal) {
        this.id = id;
        this.orderId = orderId;
        this.bookId = bookId;
        this.bookName = bookName;
        this.author = author;
        this.price = price;
        this.buyNum = buyNum;
        this.subTotal = subTotal;
    }

    // getter和setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getBuyNum() {
        return buyNum;
    }

    public void setBuyNum(Integer buyNum) {
        this.buyNum = buyNum;
    }

    public Double getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(Double subTotal) {
        this.subTotal = subTotal;
    }
}