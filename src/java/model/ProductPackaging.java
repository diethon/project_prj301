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
@Table(name = "product_packaging")
@NamedQueries({
    @NamedQuery(name = "ProductPackaging.findAll", query = "SELECT p FROM ProductPackaging p"),
    @NamedQuery(name = "ProductPackaging.findByPackagingId", query = "SELECT p FROM ProductPackaging p WHERE p.packagingId = :packagingId"),
    @NamedQuery(name = "ProductPackaging.findByName", query = "SELECT p FROM ProductPackaging p WHERE p.name = :name"),
    @NamedQuery(name = "ProductPackaging.findByDescription", query = "SELECT p FROM ProductPackaging p WHERE p.description = :description"),
    @NamedQuery(name = "ProductPackaging.findByCreatedAt", query = "SELECT p FROM ProductPackaging p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "ProductPackaging.findByModifiedAt", query = "SELECT p FROM ProductPackaging p WHERE p.modifiedAt = :modifiedAt")})
public class ProductPackaging implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "packaging_id")
    private Integer packagingId;
    @Basic(optional = false)
    @Column(name = "name")
    private String name;
    @Column(name = "description")
    private String description;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "modified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedAt;
    @OneToMany(mappedBy = "packagingId")
    private Collection<Products> productsCollection;

    public ProductPackaging() {
    }

    public ProductPackaging(Integer packagingId) {
        this.packagingId = packagingId;
    }

    public ProductPackaging(Integer packagingId, String name) {
        this.packagingId = packagingId;
        this.name = name;
    }

    public Integer getPackagingId() {
        return packagingId;
    }

    public void setPackagingId(Integer packagingId) {
        this.packagingId = packagingId;
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
        hash += (packagingId != null ? packagingId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductPackaging)) {
            return false;
        }
        ProductPackaging other = (ProductPackaging) object;
        if ((this.packagingId == null && other.packagingId != null) || (this.packagingId != null && !this.packagingId.equals(other.packagingId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ProductPackaging[ packagingId=" + packagingId + " ]";
    }
    
}
