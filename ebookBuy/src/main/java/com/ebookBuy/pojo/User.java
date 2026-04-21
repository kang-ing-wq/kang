package com.ebookBuy.pojo;

public class User {
  // 适配你的数据库：id是varchar字符串类型
  private String id;
  private String username;
  private String password;
  // 原有表字段
  private String sex;
  private Integer age;
  private String email;
  // 新增功能字段
  private String userTitle;
  private String avatarPath;
  private Integer readChapterNum;
  private Integer readBookNum;

  // 无参构造
  public User() {}

  // 全参构造
  public User(String id, String username, String password, String sex, Integer age, String email, String userTitle, String avatarPath, Integer readChapterNum, Integer readBookNum) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.sex = sex;
    this.age = age;
    this.email = email;
    this.userTitle = userTitle;
    this.avatarPath = avatarPath;
    this.readChapterNum = readChapterNum;
    this.readBookNum = readBookNum;
  }

  // 所有字段的getter和setter
  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getSex() {
    return sex;
  }

  public void setSex(String sex) {
    this.sex = sex;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getUserTitle() {
    return userTitle;
  }

  public void setUserTitle(String userTitle) {
    this.userTitle = userTitle;
  }

  public String getAvatarPath() {
    return avatarPath;
  }

  public void setAvatarPath(String avatarPath) {
    this.avatarPath = avatarPath;
  }

  public Integer getReadChapterNum() {
    return readChapterNum;
  }

  public void setReadChapterNum(Integer readChapterNum) {
    this.readChapterNum = readChapterNum;
  }

  public Integer getReadBookNum() {
    return readBookNum;
  }

  public void setReadBookNum(Integer readBookNum) {
    this.readBookNum = readBookNum;
  }
}