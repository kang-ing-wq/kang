package com.ebookBuy.pojo;

import java.util.Date;

/**
 * 典籍实体类，完全对齐数据库表字段
 */
public class Book {



    // 原有基础字段
    private Integer id;
    private String bookTitle;
    private String bookAuthor;
    private String bookSummary;
    private Integer typeId;
    private Integer downloadTimes;
    private String bookPubYear;
    private String bookFile;
    private String bookCover;
    private String bookFormat;

    // 新增售卖相关字段（模块四必须）
    private Double price;
    private Integer stock;
    private Integer isSale;
    private Integer tryReadChapter;

    // 阅读进度扩展字段（私人藏经阁用）
    private Integer lastReadChapter;
    private Date lastReadTime;
    private Date buyTime;

    // 无参构造
    public Book() {}

    // ================== 所有字段的set/get方法 ==================
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    public String getBookSummary() {
        return bookSummary;
    }

    public void setBookSummary(String bookSummary) {
        this.bookSummary = bookSummary;
    }

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public Integer getDownloadTimes() {
        return downloadTimes;
    }

    public void setDownloadTimes(Integer downloadTimes) {
        this.downloadTimes = downloadTimes;
    }

    public String getBookPubYear() {
        return bookPubYear;
    }

    public void setBookPubYear(String bookPubYear) {
        this.bookPubYear = bookPubYear;
    }

    public String getBookFile() {
        return bookFile;
    }

    public void setBookFile(String bookFile) {
        this.bookFile = bookFile;
    }

    public String getBookCover() {
        return bookCover;
    }

    public void setBookCover(String bookCover) {
        this.bookCover = bookCover;
    }

    public String getBookFormat() {
        return bookFormat;
    }

    public void setBookFormat(String bookFormat) {
        this.bookFormat = bookFormat;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Integer getIsSale() {
        return isSale;
    }

    public void setIsSale(Integer isSale) {
        this.isSale = isSale;
    }

    public Integer getTryReadChapter() {
        return tryReadChapter;
    }

    public void setTryReadChapter(Integer tryReadChapter) {
        this.tryReadChapter = tryReadChapter;
    }

    public Integer getLastReadChapter() {
        return lastReadChapter;
    }

    public void setLastReadChapter(Integer lastReadChapter) {
        this.lastReadChapter = lastReadChapter;
    }

    public Date getLastReadTime() {
        return lastReadTime;
    }

    public void setLastReadTime(Date lastReadTime) {
        this.lastReadTime = lastReadTime;
    }

    public Date getBuyTime() {
        return buyTime;
    }

    public void setBuyTime(Date buyTime) {
        this.buyTime = buyTime;
    }
}