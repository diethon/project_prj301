/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Collection;
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

/**
 *
 * @author 84395
 */
@Entity
@Table(name = "product_original")
@NamedQueries({
    @NamedQuery(name = "ProductOriginal.findAll", query = "SELECT p FROM ProductOriginal p"),
    @NamedQuery(name = "ProductOriginal.findByOriginId", query = "SELECT p FROM ProductOriginal p WHERE p.originId = :originId"),
    @NamedQuery(name = "ProductOriginal.findByNameCountry", query = "SELECT p FROM ProductOriginal p WHERE p.nameCountry = :nameCountry")})
public class ProductOriginal implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "origin_id")
    private Integer originId;
    @Basic(optional = false)
    @Column(name = "name_country")
    private String nameCountry;
    @OneToMany(mappedBy = "originId")
    private Collection<Products> productsCollection;

    public ProductOriginal() {
    }

    public ProductOriginal(Integer originId) {
        this.originId = originId;
    }

    public ProductOriginal(Integer originId, String nameCountry) {
        this.originId = originId;
        this.nameCountry = nameCountry;
    }

    public Integer getOriginId() {
        return originId;
    }

    public void setOriginId(Integer originId) {
        this.originId = originId;
    }

    public String getNameCountry() {
        return nameCountry;
    }

    public void setNameCountry(String nameCountry) {
        this.nameCountry = nameCountry;
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
        hash += (originId != null ? originId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ProductOriginal)) {
            return false;
        }
        ProductOriginal other = (ProductOriginal) object;
        if ((this.originId == null && other.originId != null) || (this.originId != null && !this.originId.equals(other.originId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ProductOriginal[ originId=" + originId + " ]";
    }
    
}
