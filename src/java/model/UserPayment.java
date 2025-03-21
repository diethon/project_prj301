/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
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
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author 84395
 */
@Entity
@Table(name = "user_payment")
@NamedQueries({
    @NamedQuery(name = "UserPayment.findAll", query = "SELECT u FROM UserPayment u"),
    @NamedQuery(name = "UserPayment.findByPaymentId", query = "SELECT u FROM UserPayment u WHERE u.paymentId = :paymentId"),
    @NamedQuery(name = "UserPayment.findByPaymentType", query = "SELECT u FROM UserPayment u WHERE u.paymentType = :paymentType"),
    @NamedQuery(name = "UserPayment.findByAccountNo", query = "SELECT u FROM UserPayment u WHERE u.accountNo = :accountNo"),
    @NamedQuery(name = "UserPayment.findByExpiry", query = "SELECT u FROM UserPayment u WHERE u.expiry = :expiry")})
public class UserPayment implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "payment_id")
    private Integer paymentId;
    @Column(name = "payment_type")
    private String paymentType;
    @Column(name = "account_no")
    private String accountNo;
    @Column(name = "expiry")
    @Temporal(TemporalType.DATE)
    private Date expiry;
    @OneToMany(mappedBy = "paymentId")
    private Collection<OrderDetails> orderDetailsCollection;
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    @ManyToOne(optional = false)
    private Users userId;

    public UserPayment() {
    }

    public UserPayment(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(String accountNo) {
        this.accountNo = accountNo;
    }

    public Date getExpiry() {
        return expiry;
    }

    public void setExpiry(Date expiry) {
        this.expiry = expiry;
    }

    public Collection<OrderDetails> getOrderDetailsCollection() {
        return orderDetailsCollection;
    }

    public void setOrderDetailsCollection(Collection<OrderDetails> orderDetailsCollection) {
        this.orderDetailsCollection = orderDetailsCollection;
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
        hash += (paymentId != null ? paymentId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof UserPayment)) {
            return false;
        }
        UserPayment other = (UserPayment) object;
        if ((this.paymentId == null && other.paymentId != null) || (this.paymentId != null && !this.paymentId.equals(other.paymentId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.UserPayment[ paymentId=" + paymentId + " ]";
    }
    
}
