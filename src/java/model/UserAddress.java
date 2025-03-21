/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author 84395
 */
@Entity
@Table(name = "user_address")
@NamedQueries({
    @NamedQuery(name = "UserAddress.findAll", query = "SELECT u FROM UserAddress u"),
    @NamedQuery(name = "UserAddress.findByAddressId", query = "SELECT u FROM UserAddress u WHERE u.addressId = :addressId"),
    @NamedQuery(name = "UserAddress.findByAddressLine1", query = "SELECT u FROM UserAddress u WHERE u.addressLine1 = :addressLine1"),
    @NamedQuery(name = "UserAddress.findByAddressLine2", query = "SELECT u FROM UserAddress u WHERE u.addressLine2 = :addressLine2"),
    @NamedQuery(name = "UserAddress.findByCity", query = "SELECT u FROM UserAddress u WHERE u.city = :city"),
    @NamedQuery(name = "UserAddress.findByCountry", query = "SELECT u FROM UserAddress u WHERE u.country = :country"),
    @NamedQuery(name = "UserAddress.findByTelephone", query = "SELECT u FROM UserAddress u WHERE u.telephone = :telephone")})
public class UserAddress implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "address_id")
    private Integer addressId;
    @Column(name = "address_line1")
    private String addressLine1;
    @Column(name = "address_line2")
    private String addressLine2;
    @Column(name = "city")
    private String city;
    @Column(name = "country")
    private String country;
    @Column(name = "telephone")
    private String telephone;
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @ManyToOne(optional = false)
    private Users userId;

    public UserAddress() {
    }

    public UserAddress(Integer addressId) {
        this.addressId = addressId;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (addressId != null ? addressId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserAddress)) {
            return false;
        }
        UserAddress other = (UserAddress) object;
        if ((this.addressId == null && other.addressId != null) || (this.addressId != null && !this.addressId.equals(other.addressId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.UserAddress[ addressId=" + addressId + " ]";
    }
    
}
