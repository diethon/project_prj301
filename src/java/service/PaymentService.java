/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import model.CartItem;
import model.OrderDetails;

/**
 *
 * @author hoang
 */
public class PaymentService {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("MedicineAppPU");

    public Integer addPaymentService(OrderDetails order) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            if (order.getStatus() == null) {
                order.setStatus("Processing");
            }
            if (order.getCreatedAt() == null) {
                order.setCreatedAt(new Date());
            }
            if (order.getModifiedAt() == null) {
                order.setModifiedAt(new Date());
            }
            em.persist(order);
            transaction.commit();
            return order.getOrderId();
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
        return 0;
    }

    public OrderDetails searchOrderDetails(int user_id, BigDecimal total) {
        EntityManager em = emf.createEntityManager();

        String query = "SELECT o FROM OrderDetails o WHERE o.userId = :user_id "
                + "AND o.total = :total "
                + "AND o.status = :status "
                + "AND o.createdAt IS NOT NULL";

        try {
            OrderDetails order = em.createQuery(query, OrderDetails.class)
                    .setParameter("user_id", user_id)
                    .setParameter("total", total)
                    .setParameter("status", "Processing")
                    .getSingleResult();
            return order;
        } catch (Exception e) {
            System.err.println("No order found for user_id: " + user_id + " and total: " + total);
            return null;
        } finally {
            em.close();
        }
    }

    public void updatePaymentService(OrderDetails order, String status) {
        if (order == null) {
            System.err.println("Order is null. Cannot update payment.");
            return;
        }

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();

            if (!order.getStatus().equals(status)) {
                order.setStatus(status);
            } else {
                System.out.println("Status is already " + status + ". No update needed.");
            }

            order.setModifiedAt(new Date());

            em.merge(order);
            transaction.commit();
            System.out.println("Payment status updated successfully to " + status);
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            System.err.println("Error updating payment status: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (em.isOpen()) {
                em.close();
            }
        }
    }

}
