/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.CartBean;
import service.CartService;
import service.ProductService;
import model.CartItem;
import model.Products;
import model.ShoppingSession;
import model.Users;

/**
 *
 * @author 84395
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/carts"})
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CartService cartService;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        productService = new ProductService();  // This assumes you have a ProductService to fetch products
    }

    // Handle GET request: Show the cart items
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Get the logged-in user
        Users user = (Users) request.getSession().getAttribute("user");
        List<CartItem> cart = null;
        if (user == null) {
            response.sendRedirect("login");  // Redirect to login if no user is found
            return;
        }
        ShoppingSession shoppingSession = cartService.findOrCreateShoppingSession(user);
        List<CartItem> cartItems = cartService.getCartItemsBySession(shoppingSession);
        CartBean cartBean = new CartBean();
        cartBean.setCartItems(cartItems);
        cartBean.calculateTotal();
        request.setAttribute("cart", cartBean);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
        // Retrieve all the cart items for the shopping session
        System.out.println("cart--------------- do post");
        System.out.println(cart);
    }
    // Handle POST request: Add to cart, Update quantity, or Remove from cart

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        List<CartItem> cart = null;

        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");  // Redirect to login if no user is found
            return;
        }
        ShoppingSession shoppingSession = cartService.findOrCreateShoppingSession(user);
        System.out.println("---------------------------------------------------------");
        System.out.println(user);
        if (null == action) {
            shoppingSession = cartService.findOrCreateShoppingSession(user);
            cart = cartService.getCartItemsBySession(shoppingSession);
        } else {
            switch (action) {
                case "add":
                    int productId = Integer.parseInt(request.getParameter("productId"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    Products product = productService.getProductById(productId);
                    System.out.println(product);
                    if (product != null) {
                        CartItem cartItem = new CartItem();
                        cartItem.setProductId(product);
                        cartItem.setQuantity(quantity);
                        cartService.checkAndAddCartItem(shoppingSession, cartItem);
                    }
                    cart = cartService.getCartItemsBySession(shoppingSession);
                    System.out.println("----------------------");
                    System.out.println(shoppingSession);
                    request.setAttribute("cart", cart);
                    break;
                case "update": {
                    int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
                    int newQuantity = Integer.parseInt(request.getParameter("quantity"));
                    // Retrieve the cart item and update the quantity
                    CartItem cartItem = cartService.getCartItemById(cartItemId);
                    cartItem.setQuantity(newQuantity);
                    cartService.updateCartItem(shoppingSession, cartItem);
                    break;
                }
                case "remove": {
                    int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
                    CartItem cartItem = cartService.getCartItemById(cartItemId);
                    cartItem.setQuantity(0);
                    cartService.updateCartItem(shoppingSession, cartItem);
                    break;
                }
                default:
                    shoppingSession = cartService.findOrCreateShoppingSession(user);
                    cart = cartService.getCartItemsBySession(shoppingSession);
                    break;
            }
        }
        System.out.println("cart---------------");
        System.out.println(cart);
        request.setAttribute("cart", cart);
        response.sendRedirect("carts");
    }
}
