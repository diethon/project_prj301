/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
@Table(name = "product_discount")
@NamedQueries({
    @NamedQuery(name = "ProductDiscount.findAll", query = "SELECT p FROM ProductDiscount p"),
    @NamedQuery(name = "ProductDiscount.findByDiscountId", query = "SELECT p FROM ProductDiscount p WHERE p.discountId = :discountId"),
    @NamedQuery(name = "ProductDiscount.findByName", query = "SELECT p FROM ProductDiscount p WHERE p.name = :name"),
    @NamedQuery(name = "ProductDiscount.findByDescription", query = "SELECT p FROM ProductDiscount p WHERE p.description = :description"),
    @NamedQuery(name = "ProductDiscount.findByDiscountPercent", query = "SELECT p FROM ProductDiscount p WHERE p.discountPercent = :discountPercent"),
    @NamedQuery(name = "ProductDiscount.findByActive", query = "SELECT p FROM ProductDiscount p WHERE p.active = :active"),
    @NamedQuery(name = "ProductDiscount.findByCreatedAt", query = "SELECT p FROM ProductDiscount p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "ProductDiscount.findByModifiedAt", query = "SELECT p FROM ProductDiscount p WHERE p.modifiedAt = :modifiedAt")})
public class ProductDiscount implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "discount_id")
    private Integer discountId;
    @Column(name = "name")
    private String name;
    @Column(name = "description")
    private String description;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "discount_percent")
    private BigDecimal discountPercent;
    @Column(name = "active")
    private Boolean active;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "modified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedAt;
    @OneToMany(mappedBy = "discountId")
    private Collection<Products> productsCollection;

    public ProductDiscount() {
    }

    public ProductDiscount(Integer discountId) {
        this.discountId = discountId;
    }

    public Integer getDiscountId() {
        return discountId;
    }

    public void setDiscountId(Integer discountId) {
        this.discountId = discountId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
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

    public Collection<Products> getProductsCollection() {
        return productsCollection;
    }

    public void setProductsCollection(Collection<Products> productsCollection) {
        this.productsCollection = productsCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (discountId != null ? discountId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductDiscount)) {
            return false;
        }
        ProductDiscount other = (ProductDiscount) object;
        if ((this.discountId == null && other.discountId != null) || (this.discountId != null && !this.discountId.equals(other.discountId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ProductDiscount[ discountId=" + discountId + " ]";
    }
    
}
