package service;

import dao.ShoppingSessionDAO;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import model.CartItem;
import model.ShoppingSession;
import model.Users;

public class CartService {

    // EntityManagerFactory to manage entities
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("MedicineAppPU");
    private static final ShoppingSessionDAO shoppingDao = new ShoppingSessionDAO();

    // Get CartItems by session
    public List<CartItem> getCartItemsBySession(ShoppingSession shoppingSession) {
        EntityManager em = emf.createEntityManager();
        List<CartItem> cartItems = em.createQuery("SELECT c FROM CartItem c WHERE c.sessionId = :session", CartItem.class)
                .setParameter("session", shoppingSession)
                .getResultList();
        em.close();
        System.out.println("--------------");
//      
        System.out.println(cartItems);
        return cartItems;
    }

    // Get a specific CartItem by its ID
    public CartItem getCartItemById(int cartItemId) {
        EntityManager em = emf.createEntityManager();
        CartItem cartItem = em.find(CartItem.class, cartItemId);
        em.close();
        return cartItem;
    }

    public int getQuantityProduct(ShoppingSession shoppingSession) {
        int number = 0;
        List<CartItem> cartItems = getCartItemsBySession(shoppingSession);
        for (CartItem cartItem : cartItems) {
            if (cartItem.getQuantity() != 0) {
                number++;
            }
        }
        return number;
    }

    // Add a CartItem to the cart (ShoppingSession)
    public void addCartItem(ShoppingSession shoppingSession, CartItem cartItem) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            cartItem.setSessionId(shoppingSession);
            // Persist the cart item

            if (cartItem.getCreatedAt() == null) {
                cartItem.setCreatedAt(new Date());
            }
            if (cartItem.getModifiedAt() == null) {
                cartItem.setModifiedAt(new Date());
            }
            em.persist(cartItem);
            // Update the shopping session's total
            updateShoppingSessionTotal(shoppingSession, em);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace(); // Or log the exception
        } finally {
            em.close();
        }
    }

    // Remove a CartItem by its ID
//    public void removeCartItem(int cartItemId) {
//        EntityManager em = emf.createEntityManager();
//        EntityTransaction transaction = em.getTransaction();
//        try {
//            transaction.begin();
//            CartItem cartItem = em.find(CartItem.class, cartItemId);
//            if (cartItem != null) {
//                em.remove(cartItem);
//            }
//            transaction.commit();
//        } catch (Exception e) {
//            if (transaction.isActive()) {
//                transaction.rollback();
//            }
//            e.printStackTrace(); // Or log the exception
//        } finally {
//            em.close();
//        }
//    }
    public void checkAndAddCartItem(ShoppingSession shoppingSession, CartItem cartItem) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            List<CartItem> existingCartItems = em.createQuery("SELECT c FROM CartItem c WHERE c.sessionId = :session AND c.productId = :product", CartItem.class)
                    .setParameter("session", shoppingSession)
                    .setParameter("product", cartItem.getProductId())
                    .getResultList();

            if (existingCartItems.isEmpty()) {
                cartItem.setSessionId(shoppingSession);
                em.persist(cartItem);
            } else {
                CartItem existingItem = existingCartItems.get(0);
                existingItem.setQuantity(existingItem.getQuantity() + cartItem.getQuantity());
                em.merge(existingItem); // Cập nhật cartItem
            }

            updateShoppingSessionTotal(shoppingSession, em);

            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // Update a CartItem
    public void updateCartItem(ShoppingSession shoppingSession, CartItem cartItem) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            // Check if CartItem exists
            CartItem existingItem = em.find(CartItem.class, cartItem.getCartItemId());
            if (existingItem != null) {
                updateShoppingSessionTotal(shoppingSession, em);
                em.merge(cartItem); // Update the cart item
            } else {
                throw new IllegalArgumentException("Cart item not found for update.");
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace(); // Or log the exception
        } finally {
            em.close();
        }
    }

    // Find or create a ShoppingSession for a User
    public ShoppingSession findOrCreateShoppingSession(Users user) {
        EntityManager em = emf.createEntityManager();
        ShoppingSession session = em.createQuery("SELECT s FROM ShoppingSession s WHERE s.userId = :user", ShoppingSession.class)
                .setParameter("user", user)
                .getResultList()
                .stream()
                .findFirst()
                .orElse(new ShoppingSession());

        if (session.getSessionId() == null) {
            session.setUserId(user);
            session.setCreatedAt(new java.util.Date());
            session.setModifiedAt(new java.util.Date());
            session.setTotal(BigDecimal.ZERO);
            em.persist(session);
            shoppingDao.create(session);
        }
        em.close();
        System.out.println("shopping session" + session);
        return session;
    }

    // Update the shopping session's total price
    private void updateShoppingSessionTotal(ShoppingSession shoppingSession, EntityManager em) {
        BigDecimal total = (BigDecimal) em.createQuery("SELECT SUM(ci.productId.price * ci.quantity) FROM CartItem ci WHERE ci.sessionId = :session", BigDecimal.class)
                .setParameter("session", shoppingSession)
                .getSingleResult();
        shoppingSession.setTotal(total);
        shoppingSession.setModifiedAt(new java.util.Date());
        em.merge(shoppingSession); // Save the updated session with the new total
    }

    // Remove a CartItem and update the session total
    public void removeItemAndUpdateTotal(ShoppingSession shoppingSession, int cartItemId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            CartItem cartItem = em.find(CartItem.class, cartItemId);
            if (cartItem != null) {
                cartItem.setQuantity(0);
                em.merge(cartItem);
                updateShoppingSessionTotal(shoppingSession, em);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }

    }

}
