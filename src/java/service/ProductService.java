/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import model.Products;

/**
 *
 * @author anhqu
 */
public class ProductService {
     private EntityManagerFactory emf = Persistence.createEntityManagerFactory("MedicineAppPU");

    // Method to get a product by its ID
    public Products getProductById(int productId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Products.class, productId);
        } finally {
            em.close();
        }
    }
}
