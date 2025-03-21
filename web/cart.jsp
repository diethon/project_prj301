<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ hàng - SmartCare</title>
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
        <link href="css/cart.css" rel="stylesheet">
        <link rel="Website Icon " type="png" href="img/logo.png">
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>

            <div class="container mt-5 mb-5">
                <h2>Giỏ hàng của bạn</h2>

            <c:if test="${empty cart.cartItems}">
                <div class="empty-cart text-center">
                    <i class="fa fa-shopping-cart fa-5x mb-3"></i>
                    <h3>Giỏ hàng của bạn đang trống</h3>
                    <p>Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm</p>
                    <a href="home" class="btn btn-primary mt-3">Tiếp tục mua sắm</a>
                </div>
            </c:if>

            <c:if test="${not empty cart.cartItems}">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th>Xóa</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cart.cartItems}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${item.product.imageUrl}" alt="${item.product.nameProduct}" class="cart-item-image mr-3">
                                            <div>
                                                <h5><a href="product?id=${item.product.productId}">${item.product.nameProduct}</a></h5>
                                                <small>${item.product.sku}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${item.product.discountPercent != null && item.product.discountPercent > 0}">
                                            <span class="original-price">${item.product.price} VNĐ</span><br>
                                            <span class="discounted-price">${item.product.discountedPrice} VNĐ</span>
                                        </c:if>
                                        <c:if test="${item.product.discountPercent == null || item.product.discountPercent == 0}">
                                            ${item.product.price} VNĐ
                                        </c:if>
                                    </td>
                                    <td>
                                        <form action="carts" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                            <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control quantity-input">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary mt-2">Cập nhật</button>
                                        </form>
                                    </td>
                                    <td>${item.subtotal} VNĐ</td>
                                    <td>
                                        <form action="carts" method="post">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                            <button type="submit" class="btn btn-sm btn-danger">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-right"><strong>Tổng cộng:</strong></td>
                                <td colspan="2"><strong>${cart.total} VNĐ</strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="cart-actions d-flex justify-content-between">
                    <a href="home" class="btn btn-outline-secondary">
                        <i class="fa fa-arrow-left mr-2"></i>Tiếp tục mua sắm
                    </a>
                    <a href="checkout" class="btn btn-primary">
                        Thanh toán<i class="fa fa-arrow-right ml-2"></i>
                    </a>
                </div>
            </c:if>
        </div>

        <jsp:include page="Footer.jsp"></jsp:include>
    </body>
</html>

