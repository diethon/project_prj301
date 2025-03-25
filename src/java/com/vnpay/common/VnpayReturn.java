/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.vnpay.common;

import dao.CartItemDAO;
import dao.OrderDetailsDAO;
import dao.ProductInventoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.CartItem;
import model.OrderDetails;
import model.ShoppingSession;
import model.Users;
import org.apache.jasper.tagplugins.jstl.core.ForEach;
import service.CartService;
import service.PaymentService;
import service.ProductService;

@WebServlet(name = "VnpayReturn", urlPatterns = {"/vnpayReturn"})
public class VnpayReturn extends HttpServlet {

    private CartService cartService;
    private CartItemDAO cartItemDao;
    private OrderDetailsDAO orderDao;
    private PaymentService paymentservice;
    private ProductInventoryDAO productInventoryDAO;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDetailsDAO();
        paymentservice = new PaymentService();
        cartItemDao = new CartItemDAO();
        cartService = new CartService();
        productInventoryDAO = new ProductInventoryDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = Config.hashAllFields(fields);
            if (signValue.equals(vnp_SecureHash)) {
                String paymentCode = request.getParameter("vnp_TransactionNo");
                String orderId = request.getParameter("vnp_TxnRef");
                System.out.println("order " + orderId);
                OrderDetails orderDetails = orderDao.findById(Integer.parseInt(orderId));
                boolean transSuccess = false;
                String status = "Failed";
                if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                    status = "Completed";
                    transSuccess = true;
                }
                paymentservice.updatePaymentService(orderDetails, status);
                request.setAttribute("transResult", transSuccess);
                if (transSuccess) {
                    HttpSession session = request.getSession();

                    String selectedItems = (String) session.getAttribute("selectedItemsIds");
                    System.out.println(selectedItems + "test chuoi");
                    if (selectedItems != null && !selectedItems.isEmpty()) {
                        String[] selectedItemIds = selectedItems.split(",");
                        List<Integer> selectedItemIdList = new ArrayList<>();
                        for (String itemId : selectedItemIds) {
                            selectedItemIdList.add(Integer.parseInt(itemId));
                        }
                        Users user = (Users) request.getSession().getAttribute("user");
                        ShoppingSession shoppingSession = cartService.findOrCreateShoppingSession(user);
                        ArrayList<CartItem> cartItems = cartItemDao.findCartItemBylistId(selectedItemIdList);
                        productInventoryDAO.updatePaymentSuccess(shoppingSession, cartItems);
                        request.getRequestDispatcher("checkout.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("errorMessage", "Thanh toán không thành công. Vui lòng thử lại.");
                    request.getRequestDispatcher("checkouterr.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Thanh toán không hợp lệ. Vui lòng thử lại.");
                request.getRequestDispatcher("checkouterr.jsp").forward(request, response);
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
