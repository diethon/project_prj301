<%@ page import="model.CartItem" %>
<%@ page import="model.Products" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.CartItemDAO" %>
<%@ page import="dao.ProductsDAO" %>

<jsp:useBean id="cartDAO" class="dao.CartItemDAO" scope="page"/>
<jsp:useBean id="productDAO" class="dao.ProductsDAO" scope="page"/>

<jsp:useBean id="cartItems" class="java.util.ArrayList" scope="request"/>

<%
    List<CartItem> cartItemList = cartDAO.findAll(); 
    request.setAttribute("cartItems", cartItemList);
    double totalPrice = 0;
    for (CartItem cartItem : cartItemList) {
        totalPrice += cartItem.getProductId().getPrice().doubleValue() * cartItem.getQuantity();
    }
    request.setAttribute("totalPrice", totalPrice);
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Giỏ Hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding: 20px;
                text-align: center;
            }
            .cart-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
            }
            .cart-item {
                border: 1px solid #ddd;
                padding: 20px;
                width: 200px;
                background-color: #fff;
                text-align: center;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .cart-item img {
                width: 100%;
                height: 150px;
                object-fit: contain;
            }
            .cart-item button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 5px;
                cursor: pointer;
                width: 100%;
            }
            .cart-item input {
                width: 100%;
                margin: 5px 0;
                padding: 5px;
            }
            .cart-item .price {
                font-weight: bold;
                margin-top: 10px;
            }
            .cart-item a {
                color: #007bff;
                text-decoration: none;
                margin-top: 5px;
                display: inline-block;
            }
            .cart-summary {
                font-size: 18px;
                font-weight: bold;
                margin-top: 20px;
            }
            .cart-summary .total-price {
                color: #28a745;
                font-size: 22px;
                margin-top: 10px;
            }
            .checkout-button {
                background-color: #007bff;
                color: white;
                padding: 10px;
                text-decoration: none;
                font-size: 18px;
                border-radius: 5px;
                margin-top: 20px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <h2>Giỏ Hàng Của Bạn</h2>

        <div class="cart-container">
            <c:forEach var="cartItem" items="${cartItems}">
                <div class="cart-item">
                    <img src="${cartItem.product.imageUrl}" alt="${cartItem.product.name}">
                    <h3>${cartItem.product.name}</h3>
                    <p class="price">${cartItem.product.price} VND</p>
                    <form action="<%= request.getContextPath() %>/cart" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cartItemId" value="${cartItem.id}">
                        <input type="number" name="quantity" value="${cartItem.quantity}" min="1" required>
                        <button type="submit">Cập nhật</button>
                    </form>
                    <form action="<%= request.getContextPath() %>/cart" method="post">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="cartItemId" value="${cartItem.id}">
                        <button type="submit">Xóa</button>
                    </form>
                    <a href="<%= request.getContextPath() %>/productDetail?id=${cartItem.product.id}">Xem chi tiết</a>
                </div>
            </c:forEach>
        </div>

        <div class="cart-summary">
            <p>Tổng tiền: <span class="total-price">${totalPrice} VND</span></p>
            <a href="<%= request.getContextPath() %>/checkout.jsp" class="checkout-button">Tiến hành thanh toán</a>
        </div>
    </body>
</html>
