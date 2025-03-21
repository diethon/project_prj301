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
@WebServlet(name="CartServlet", urlPatterns={"/carts"})
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CartService cartService;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        // Initialize CartService and ProductService
        cartService = new CartService();
        productService = new ProductService();  // This assumes you have a ProductService to fetch products
    }

    // Handle GET request: Show the cart items
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        
        
        // Get the logged-in user
        Users user = (Users) request.getSession().getAttribute("user");
        

        if (user == null) {
            response.sendRedirect("login");  // Redirect to login if no user is found
            return;
        }

        // Retrieve the shopping session for the user
        ShoppingSession shoppingSession = cartService.findOrCreateShoppingSession(user);

        // Retrieve all the cart items for the shopping session
        request.setAttribute("cart", shoppingSession);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    // Handle POST request: Add to cart, Update quantity, or Remove from cart
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");  // Redirect to login if no user is found
            return;
        }

        if ("add".equals(action)) {
            // Add to cart
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Products product = productService.getProductById(productId);

            if (product != null) {
                ShoppingSession shoppingSession = cartService.findOrCreateShoppingSession(user);
                CartItem cartItem = new CartItem();
                cartItem.setProductId(product);
                cartItem.setQuantity(quantity);

                // Add the CartItem to the session
                cartService.addCartItem(shoppingSession, cartItem);
            }

        } else if ("update".equals(action)) {
            // Update cart quantity
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            // Retrieve the cart item and update the quantity
            CartItem cartItem = cartService.getCartItemById(cartItemId);
            cartItem.setQuantity(newQuantity);
            cartService.updateCartItem(cartItem);
        } else if ("remove".equals(action)) {
            // Remove item from cart
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            cartService.removeCartItem(cartItemId);
        }

        // After performing actions, redirect back to the cart page to show updated cart
        response.sendRedirect("NewServlet");
    }
}