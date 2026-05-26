package com.ebookBuy.pojo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 典籍实体类，完全对齐数据库表字段（支持多类型）
 */
public class Book {

    // 原有基础字段
    private Integer id;
    private String bookTitle;
    private String bookAuthor;
    private String bookSummary;
    private Integer typeId; // 保留兼容旧逻辑
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

    // ========== 【核心修改】真正的多类型字段 ==========
    private List<Integer> typeIds = new ArrayList<>(); // 初始化，防止空指针
    private List<String> typeNames = new ArrayList<>(); // 初始化，防止空指针

    private String themes; // 逗号分隔的主题字符串
    // 无参构造
    public Book() {}

    // ========== 【核心修改】JSP便捷方法（基于真实多类型数据） ==========

    // 直接返回多类型ID列表
    public List<Integer> getTypeIds() {
        return typeIds;
    }

    // 把多类型ID列表转成逗号分隔的字符串（给JSP的data属性用）
    public String getTypeIdsStr() {
        if (typeIds == null || typeIds.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < typeIds.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(typeIds.get(i));
        }
        return sb.toString();
    }

    // 把多类型名称列表转成中文逗号分隔的字符串（给表格显示用）
    public String getTypeNamesStr() {
        if (typeNames == null || typeNames.isEmpty()) {
            return "未分类";
        }
        return String.join("，", typeNames);
    }

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

    // getter & setter
    public String getThemes() { return themes; }
    public void setThemes(String themes) { this.themes = themes; }

    // 给 JSP 的 data-themes 属性使用
    public String getThemesStr() {
        return themes != null ? themes : "";
    }
    // 多类型的setter/getter
    public void setTypeIds(List<Integer> typeIds) { this.typeIds = typeIds; }
    public List<String> getTypeNames() { return typeNames; }
    public void setTypeNames(List<String> typeNames) { this.typeNames = typeNames; }
}