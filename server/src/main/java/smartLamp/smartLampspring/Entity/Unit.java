package smartLamp.smartLampspring.Entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import javax.persistence.*;


@Entity(name="unit")
public class Unit {
    @Id
    @Column(name = "unit_code")
    private String unitCode;
    @Column(name = "unit_name")
    private String unitName;
    private Integer distance;
    private Integer time;
    private Integer brightness;
    @ManyToOne
    @JoinColumn(name = "user_id")
    @JsonBackReference
    private User user;

    public String getUnitCode() {
        return unitCode;
    }

    public void setUnitCode(String unitCode) {
        this.unitCode = unitCode;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public Integer getDistance() {
        return distance;
    }

    public void setDistance(Integer distance) {
        this.distance = distance;
    }

    public Integer getTime() {
        return time;
    }

    public void setTime(Integer time) {
        this.time = time;
    }

    public Integer getBrightness() {
        return brightness;
    }

    public void setBrightness(Integer brightness) {
        this.brightness = brightness;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if(!user.getUnitList().contains(this)){
            user.addUnit(this);
        }
    }
}
