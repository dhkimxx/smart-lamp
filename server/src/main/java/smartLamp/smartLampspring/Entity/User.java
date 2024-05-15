package smartLamp.smartLampspring.Entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity(name="user")
public class User {
    @Id
    @Column(name = "user_id")
    private String userId;
    @Column(name = "user_pw")
    private String userPw;
    @Column(name = "user_name")
    private String userName;
    @Column
    private String phone;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    @JsonManagedReference
    private List<Unit> unitList;

    private boolean authenticated;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserPw() {
        return userPw;
    }

    public void setUserPw(String userPw) {
        this.userPw = userPw;
    }

    public boolean isAuthenticated() {
        return authenticated;
    }

    public void setAuthenticated(boolean authenticated) {
        this.authenticated = authenticated;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public List<Unit> getUnitList() {
        return unitList;
    }

    public void setUnitList(ArrayList<Unit> unitList) {
        this.unitList = unitList;
    }

    public void addUnit(Unit unit){
        if(!this.unitList.contains(unit)) this.unitList.add(unit);
        if(unit.getUser() != this){
            unit.setUser(this);
        }
    }
}
