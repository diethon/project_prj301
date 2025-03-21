/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
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
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author 84395
 */
@Entity
@Table(name = "payment_details")
@NamedQueries({
    @NamedQuery(name = "PaymentDetails.findAll", query = "SELECT p FROM PaymentDetails p"),
    @NamedQuery(name = "PaymentDetails.findByPaymentDetailId", query = "SELECT p FROM PaymentDetails p WHERE p.paymentDetailId = :paymentDetailId"),
    @NamedQuery(name = "PaymentDetails.findByAmount", query = "SELECT p FROM PaymentDetails p WHERE p.amount = :amount"),
    @NamedQuery(name = "PaymentDetails.findByProvider", query = "SELECT p FROM PaymentDetails p WHERE p.provider = :provider"),
    @NamedQuery(name = "PaymentDetails.findByStatus", query = "SELECT p FROM PaymentDetails p WHERE p.status = :status"),
    @NamedQuery(name = "PaymentDetails.findByCreatedAt", query = "SELECT p FROM PaymentDetails p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "PaymentDetails.findByModifiedAt", query = "SELECT p FROM PaymentDetails p WHERE p.modifiedAt = :modifiedAt")})
public class PaymentDetails implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "payment_detail_id")
    private Integer paymentDetailId;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "amount")
    private BigDecimal amount;
    @Column(name = "provider")
    private String provider;
    @Column(name = "status")
    private String status;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "modified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedAt;
    @JoinColumn(name = "order_id", referencedColumnName = "order_id")
    @ManyToOne(optional = false)
    private OrderDetails orderId;

    public PaymentDetails() {
    }

    public PaymentDetails(Integer paymentDetailId) {
        this.paymentDetailId = paymentDetailId;
    }

    public Integer getPaymentDetailId() {
        return paymentDetailId;
    }

    public void setPaymentDetailId(Integer paymentDetailId) {
        this.paymentDetailId = paymentDetailId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getModifiedAt() {
        return modifiedAt;
    }

    public void setModifiedAt(Date modifiedAt) {
        this.modifiedAt = modifiedAt;
    }

    public OrderDetails getOrderId() {
        return orderId;
    }

    public void setOrderId(OrderDetails orderId) {
        this.orderId = orderId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (paymentDetailId != null ? paymentDetailId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PaymentDetails)) {
            return false;
        }
        PaymentDetails other = (PaymentDetails) object;
        if ((this.paymentDetailId == null && other.paymentDetailId != null) || (this.paymentDetailId != null && !this.paymentDetailId.equals(other.paymentDetailId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.PaymentDetails[ paymentDetailId=" + paymentDetailId + " ]";
    }
    
}
