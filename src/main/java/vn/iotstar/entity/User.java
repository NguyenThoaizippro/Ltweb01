package vn.iotstar.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.sql.Date;

@SuppressWarnings("serial")
@Entity
@Table(name = "[User]")
@NamedQueries({
    @NamedQuery(name = "User.findAll", query = "SELECT u FROM User u ORDER BY u.id DESC"),
    @NamedQuery(name = "User.findByUsername", query = "SELECT u FROM User u WHERE u.userName = :username"),
    @NamedQuery(name = "User.findByEmail", query = "SELECT u FROM User u WHERE u.email = :email")
})
public class User implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "email", nullable = false, length = 150)
    private String email;

    @Column(name = "username", nullable = false, length = 50)
    private String userName;

    @Column(name = "fullname", length = 100)
    private String fullName;

    @Column(name = "password", nullable = false, length = 255)
    private String passWord;

    @Column(name = "avatar", length = 500)
    private String avatar;

    @Column(name = "roleid")
    private Integer roleid = 3;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "createdDate")
    private Date createdDate;

    @Column(name = "isActive")
    private Integer isActive = 1;

    public User() {
    }

    public User(int id, String email, String userName, String fullName, String passWord, String avatar, Integer roleid,
            String phone, Date createdDate) {
        this.id = id;
        this.email = email;
        this.userName = userName;
        this.fullName = fullName;
        this.passWord = passWord;
        this.avatar = avatar;
        this.roleid = roleid != null ? roleid : 3;
        this.phone = phone;
        this.createdDate = createdDate;
        this.isActive = 1;
    }

    public User(int id, String email, String userName, String fullName, String passWord, String avatar, Integer roleid,
            String phone, Date createdDate, Integer isActive) {
        this.id = id;
        this.email = email;
        this.userName = userName;
        this.fullName = fullName;
        this.passWord = passWord;
        this.avatar = avatar;
        this.roleid = roleid != null ? roleid : 3;
        this.phone = phone;
        this.createdDate = createdDate;
        this.isActive = isActive != null ? isActive : 1;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getImages() {
        return this.avatar;
    }

    public void setImages(String images) {
        this.avatar = images;
    }

    public Integer getRoleid() {
        return roleid != null ? roleid : 3;
    }

    public void setRoleid(Integer roleid) {
        this.roleid = roleid;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Integer getIsActive() {
        return isActive != null ? isActive : 1;
    }

    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
    }
}
