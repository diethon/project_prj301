/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Collection;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
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
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author anhqu
 */
@Entity
@Table(name = "products")
@NamedQueries({
    @NamedQuery(name = "Products.findAll", query = "SELECT p FROM Products p"),
    @NamedQuery(name = "Products.findByProductId", query = "SELECT p FROM Products p WHERE p.productId = :productId"),
    @NamedQuery(name = "Products.findByNameProduct", query = "SELECT p FROM Products p WHERE p.nameProduct = :nameProduct"),
    @NamedQuery(name = "Products.findByDescription", query = "SELECT p FROM Products p WHERE p.description = :description"),
    @NamedQuery(name = "Products.findBySku", query = "SELECT p FROM Products p WHERE p.sku = :sku"),
    @NamedQuery(name = "Products.findByPrice", query = "SELECT p FROM Products p WHERE p.price = :price"),
    @NamedQuery(name = "Products.findByIngredient", query = "SELECT p FROM Products p WHERE p.ingredient = :ingredient"),
    @NamedQuery(name = "Products.findByCreatedAt", query = "SELECT p FROM Products p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "Products.findByModifiedAt", query = "SELECT p FROM Products p WHERE p.modifiedAt = :modifiedAt"),
    @NamedQuery(name = "Products.findByCategoryId", query = "SELECT p FROM Products p WHERE p.categoryId = :categoryId"),
    @NamedQuery(name = "Products.findByState", query = "SELECT p FROM Products p WHERE p.state = :state")})
public class Products implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "product_id")
    private Integer productId;
    @Basic(optional = false)
    @Column(name = "name_product")
    private String nameProduct;
    @Column(name = "description")
    private String description;
    @Basic(optional = false)
    @Column(name = "SKU")
    private String sku;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "price")
    private BigDecimal price;
    @Column(name = "ingredient")
    private String ingredient;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "modified_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date modifiedAt;
    @Column(name = "state")
    private Boolean state;
    @JoinColumn(name = "category_id", referencedColumnName = "category_id")
    @ManyToOne
    private ProductCategory categoryId;
    @JoinColumn(name = "discount_id", referencedColumnName = "discount_id")
    @ManyToOne
    private ProductDiscount discountId;
    @JoinColumn(name = "origin_id", referencedColumnName = "origin_id")
    @ManyToOne
    private ProductOriginal originId;
    @JoinColumn(name = "packaging_id", referencedColumnName = "packaging_id")
    @ManyToOne
    private ProductPackaging packagingId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "productId")
    private Collection<ProductImages> productImagesCollection;
    @OneToOne(cascade = CascadeType.ALL, mappedBy = "productId")
    private ProductInventory productInventory;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "productId")
    private Collection<CartItem> cartItemCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "productId")
    private Collection<OrderItems> orderItemsCollection;

    public Products() {
    }

    public Products(Integer productId) {
        this.productId = productId;
    }

    public Products(Integer productId, String nameProduct, String sku) {
        this.productId = productId;
        this.nameProduct = nameProduct;
        this.sku = sku;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getNameProduct() {
        return nameProduct;
    }

    public void setNameProduct(String nameProduct) {
        this.nameProduct = nameProduct;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getIngredient() {
        return ingredient;
    }

    public void setIngredient(String ingredient) {
        this.ingredient = ingredient;
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

    public Boolean getState() {
        return state;
    }

    public void setState(Boolean state) {
        this.state = state;
    }

    public ProductCategory getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(ProductCategory categoryId) {
        this.categoryId = categoryId;
    }

    public ProductDiscount getDiscountId() {
        return discountId;
    }

    public void setDiscountId(ProductDiscount discountId) {
        this.discountId = discountId;
    }

    public ProductOriginal getOriginId() {
        return originId;
    }

    public void setOriginId(ProductOriginal originId) {
        this.originId = originId;
    }

    public ProductPackaging getPackagingId() {
        return packagingId;
    }

    public void setPackagingId(ProductPackaging packagingId) {
        this.packagingId = packagingId;
    }

    public Collection<ProductImages> getProductImagesCollection() {
        return productImagesCollection;
    }

    public void setProductImagesCollection(Collection<ProductImages> productImagesCollection) {
        this.productImagesCollection = productImagesCollection;
    }

    public ProductInventory getProductInventory() {
        return productInventory;
    }

    public void setProductInventory(ProductInventory productInventory) {
        this.productInventory = productInventory;
    }

    public Collection<CartItem> getCartItemCollection() {
        return cartItemCollection;
    }

    public void setCartItemCollection(Collection<CartItem> cartItemCollection) {
        this.cartItemCollection = cartItemCollection;
    }

    public Collection<OrderItems> getOrderItemsCollection() {
        return orderItemsCollection;
    }

    public void setOrderItemsCollection(Collection<OrderItems> orderItemsCollection) {
        this.orderItemsCollection = orderItemsCollection;
    }

    public String getImageUrl() {
        if (productImagesCollection != null && !productImagesCollection.isEmpty()) {
            return productImagesCollection.iterator().next().getImageUrl(); // Return the first image URL
        }
        return null; // Return null if no images are found
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (productId != null ? productId.hashCode() : 0);
        return hash;
    }

    public ProductInventory getInventoryId() {
        return productInventory;
    }

    public void setInventoryId(ProductInventory inventory) {
        this.productInventory = inventory;
    }

    public String formatPrice(BigDecimal price) {
        DecimalFormat formatter = new DecimalFormat("#,###");
        return formatter.format(price).replace(",", ".");  // Replace commas with dots
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Products)) {
            return false;
        }
        Products other = (Products) object;
        if ((this.productId == null && other.productId != null) || (this.productId != null && !this.productId.equals(other.productId))) {
            return false;
        }
        return true;
    }

    public BigDecimal getDiscountPercent() {
        if (discountId != null) {
            return discountId.getDiscountPercent();
        }
        return BigDecimal.ZERO;  // Trả về 0 nếu không có discount
    }

    @Override
    public String toString() {
        return "model.Products[ productId=" + productId + " ]";
    }

}
