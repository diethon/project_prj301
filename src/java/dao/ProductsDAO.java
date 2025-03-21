/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import model.ProductCategory;
import model.Products;

/**
 *
 * @author anhqu
 */
public class ProductsDAO extends GenericDAO<Products> {

    public ProductsDAO() {
        super(Products.class);
    }

    public List<Products> findByCategory(ProductCategory category) {
        TypedQuery<Products> query = getEntityManager().createQuery(
                "SELECT p FROM Products p WHERE p.categoryId = :category", Products.class);
        query.setParameter("category", category);  // Truyền đối tượng ProductCategory vào
        return query.getResultList(); // Trả về danh sách sản phẩm thuộc loại sản phẩm (category)
    }

    public Products findById(int productId) {
        EntityManager em = getEntityManager();
        try {
            // Tìm sản phẩm theo ID
            Products product = em.find(Products.class, productId);

            // Lấy danh sách ảnh của sản phẩm (nếu có)
            if (product != null) {
                // Sử dụng fetch để tải ảnh liên quan
                product.getProductImagesCollection().size(); // Force loading of images collection
            }
            return product;
        } finally {
            em.close();
        }
    }

}
