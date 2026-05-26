package com.ebookBuy.pojo;

public class GameProgress {
    private int id;
    private String userId;
    private int bookId;
    private String currentNode;
    private String playerAttrs;     // JSON格式的玩家属性
    private String choicesHistory;  // JSON格式的历史选择
    private int gameStatus;         // 1-进行中 2-已完成

    public GameProgress() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public String getCurrentNode() { return currentNode; }
    public void setCurrentNode(String currentNode) { this.currentNode = currentNode; }
    public String getPlayerAttrs() { return playerAttrs; }
    public void setPlayerAttrs(String playerAttrs) { this.playerAttrs = playerAttrs; }
    public String getChoicesHistory() { return choicesHistory; }
    public void setChoicesHistory(String choicesHistory) { this.choicesHistory = choicesHistory; }
    public int getGameStatus() { return gameStatus; }
    public void setGameStatus(int gameStatus) { this.gameStatus = gameStatus; }
}