/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import model.CartItem;

/**
 *
 * @author anhqu
 */
public class CartItemDAO extends GenericDAO<CartItem> {

    public CartItemDAO() {
        super(CartItem.class);
    }

    public ArrayList<CartItem> findCartItemBylistId(List<Integer> idList) {
        ArrayList<CartItem> cartList = new ArrayList<>();
        EntityManager em = getEntityManager();
        try {
            for (int i : idList) {
                String query = "SELECT c FROM CartItem c WHERE  c.cartItemId = :cartItemId";
                TypedQuery<CartItem> typedQuery = em.createQuery(query, CartItem.class);
                typedQuery.setParameter("cartItemId", i);
                cartList.add(typedQuery.getSingleResult());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return cartList;
        } finally {
            em.close();
        }
        return cartList;
    }
}
