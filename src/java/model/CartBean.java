/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.List;

public class CartBean {

    private List<CartItem> cartItems;
    private BigDecimal total;

    // Getter and Setter for cartItems
    public List<CartItem> getCartItems() {
        return cartItems;
    }

    public void setCartItems(List<CartItem> cartItems) {
        this.cartItems = cartItems;
    }

    // Getter and Setter for total
    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    // Method to calculate the total price of the cart
    public void calculateTotal() {
        total = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            BigDecimal price = item.getProductId().getPrice();
//            BigDecimal discountedPrice = price.subtract(price.multiply(item.getProductId().getDiscountPercent()).divide(new BigDecimal(100)));
            total = total.add(price.multiply(new BigDecimal(item.getQuantity())));
        }
    }
}
