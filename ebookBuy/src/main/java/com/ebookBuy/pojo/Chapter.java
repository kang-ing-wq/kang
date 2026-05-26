package com.ebookBuy.pojo;

import java.sql.Timestamp;

public class Chapter {
    // 和数据库book_chapter表字段完全对应
    private Long id; // 对应数据库bigint主键
    private Long bookId; // 对应数据库book_id bigint
    private Integer chapterNum; // 对应数据库chapter_num int
    private String chapterTitle; // 对应数据库chapter_title varchar
    private String chapterContent; // 对应数据库chapter_content text
    private Timestamp createTime; // 对应数据库create_time datetime

    // ================== 无参构造 ==================
    public Chapter() {
    }

    // ================== Getter & Setter 全量方法 ==================
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public Integer getChapterNum() {
        return chapterNum;
    }

    public void setChapterNum(Integer chapterNum) {
        this.chapterNum = chapterNum;
    }

    public String getChapterTitle() {
        return chapterTitle;
    }

    public void setChapterTitle(String chapterTitle) {
        this.chapterTitle = chapterTitle;
    }

    public String getChapterContent() {
        return chapterContent;
    }

    public void setChapterContent(String chapterContent) {
        this.chapterContent = chapterContent;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }
}