package com.ebookBuy.pojo;

public class Chapter {
    private Long id;
    private Long bookId;        // BIGINT类型
    private Integer chapterNum;
    private String chapterTitle;
    private String chapterContent;

    public Chapter() {}

    public Chapter(Long id, Long bookId, Integer chapterNum, String chapterTitle, String chapterContent) {
        this.id = id;
        this.bookId = bookId;
        this.chapterNum = chapterNum;
        this.chapterTitle = chapterTitle;
        this.chapterContent = chapterContent;
    }

    // Getter和Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getBookId() { return bookId; }
    public void setBookId(Long bookId) { this.bookId = bookId; }
    public Integer getChapterNum() { return chapterNum; }
    public void setChapterNum(Integer chapterNum) { this.chapterNum = chapterNum; }
    public String getChapterTitle() { return chapterTitle; }
    public void setChapterTitle(String chapterTitle) { this.chapterTitle = chapterTitle; }
    public String getChapterContent() { return chapterContent; }
    public void setChapterContent(String chapterContent) { this.chapterContent = chapterContent; }
}