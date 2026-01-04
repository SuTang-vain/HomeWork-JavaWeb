package ch05_4;

public class User {
    private int userid;
    private String username;
    private String sex;

    public User() {
    }

    public User(int userid, String username, String sex) {
        this.userid = userid;
        this.username = username;
        this.sex = sex;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }
}
