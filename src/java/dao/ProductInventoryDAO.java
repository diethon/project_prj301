/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import model.CartItem;
import model.ProductInventory;
import model.ShoppingSession;
import service.CartService;

/**
 *
 * @author anhqu
 */
public class ProductInventoryDAO extends GenericDAO<ProductInventory> {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("MedicineAppPU");
    private static final CartService cartService = new CartService();

    public ProductInventoryDAO() {
        super(ProductInventory.class);
    }

    public int findQuantityByProductId(int productId) {
        EntityManager em = getEntityManager();
        try {
            String query = "SELECT p.quantity FROM ProductInventory p WHERE p.productId.productId = :productId";
            TypedQuery<Integer> typedQuery = em.createQuery(query, Integer.class);
            typedQuery.setParameter("productId", productId);
            Integer quantity = typedQuery.getSingleResult();
            return quantity != null ? quantity : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public void updatePaymentSuccess(ShoppingSession shoppingSession, ArrayList<CartItem> cartItems) {
        for (CartItem cartItem : cartItems) {
            subtractQuantity(cartItem.getProductId().getProductId(), cartItem.getQuantity());
            cartItem.setQuantity(0);
            cartService.updateCartItem(shoppingSession, cartItem);
        }
    }

    public boolean subtractQuantity(int productId, int quantityToSubtract) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();

            ProductInventory productInventory = em.find(ProductInventory.class, productId);

            if (productInventory != null) {
                int currentQuantity = productInventory.getQuantity();

                if (currentQuantity >= quantityToSubtract) {
                    int newQuantity = currentQuantity - quantityToSubtract;
                    productInventory.setQuantity(newQuantity);

                    em.merge(productInventory);
                    transaction.commit();
                    return true;
                } else {
                    System.out.println("Số lượng không đủ để trừ.");
                    return false;
                }
            } else {
                System.out.println("Sản phẩm không tồn tại.");
                return false;
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

}
