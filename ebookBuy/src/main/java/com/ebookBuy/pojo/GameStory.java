package com.ebookBuy.pojo;

public class GameStory {
    private int id;
    private int bookId;
    private Integer chapterId;      // 可为空
    private String nodeId;
    private String nodeTitle;
    private String storyText;
    private String options;          // JSON格式的选项
    private String requirements;     // JSON格式的进入条件
    private String rewards;          // JSON格式的奖励

    // 无参构造
    public GameStory() {}

    // getter/setter 省略（需要您自行生成，或者我补充完整？建议用IDE生成）
    // 为了方便，我手动写出关键getter/setter，其他同理
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public Integer getChapterId() { return chapterId; }
    public void setChapterId(Integer chapterId) { this.chapterId = chapterId; }
    public String getNodeId() { return nodeId; }
    public void setNodeId(String nodeId) { this.nodeId = nodeId; }
    public String getNodeTitle() { return nodeTitle; }
    public void setNodeTitle(String nodeTitle) { this.nodeTitle = nodeTitle; }
    public String getStoryText() { return storyText; }
    public void setStoryText(String storyText) { this.storyText = storyText; }
    public String getOptions() { return options; }
    public void setOptions(String options) { this.options = options; }
    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }
    public String getRewards() { return rewards; }
    public void setRewards(String rewards) { this.rewards = rewards; }
}